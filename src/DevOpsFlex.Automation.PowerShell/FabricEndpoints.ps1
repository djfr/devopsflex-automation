class DnsEndpoint {
    [string] $Uri
    [string] $Region

    DnsEndpoint () { }

    [string] GetRegionName()
    {
        switch($this.region) {
            "we" { return "West Europe" }
            "eus" { return "East US" }
            "ase" { return "Australia Southeast" }
            "sea" { return "Southeast Asia" }
            default { throw "Unknown region mapping for: $($this.Region)" }
        }

        throw "Unknown region mapping for: $($this.Region)"
    }
}

function New-FabricEndPoint
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=0)]
        [string] $Name,

        [parameter(Mandatory=$true, Position=1)]
        [int] $Port,

        [parameter(Mandatory=$false)]
        [string] $ProbePath = "/Probe",

        [switch] $UseSsl,

        [switch] $Force
    )

    if($UseSsl.IsPresent) {
        $lbs = Get-AzureRmLoadBalancer | ? { $_.Name.ToLower() -match '-ilb' }
        $dnsLayerSuffix = "-lb"
    }
    else {
        $lbs = Get-AzureRmLoadBalancer | ? { $_.Name.ToLower() -match '-lb' }
        $dnsLayerSuffix = ""
    }   

    $dnsEndpoints = @()

    $lbs[0].Name -match '\w*-(\w*)-\w*-(\w*)-\w*-\w*' > $null
    $configuration = $Matches[2]

    switch($configuration)
    {
        "sand" { $dnsConfiguration = "sandbox" }
        "prep" { $dnsConfiguration = "preprod" }
        "prod" { $dnsConfiguration = "production" }
        default { $dnsConfiguration = $configuration }
    }

    if($configuration -eq 'prod' -or $configuration -eq 'sand') {
        $dnsSuffix = 'com'
    }
    else {
        $dnsSuffix = 'net'
    }

    $dnsZone = "$dnsConfiguration.eshopworld.$dnsSuffix"

    #Load balancers
    foreach($lb in $lbs) {
        if($Force.IsPresent) {
            New-EswLoadBalancerConfig -LoadBalancerName $lb.Name -ResourceGroupName $lb.ResourceGroupName -Name $Name -Port $Port -Force
        }
        else {
            New-EswLoadBalancerConfig -LoadBalancerName $lb.Name -ResourceGroupName $lb.ResourceGroupName -Name $Name -Port $Port
        }

        if($UseSsl.IsPresent) {
            $pip = ($lb.FrontendIpConfigurations)[0].PrivateIpAddress
        }
        else {
            $pipRes = $null
            $pipRes = Get-AzureRmResource -ResourceId ($lb.FrontendIpConfigurations[0].PublicIpAddress.Id)
            $pip = (Get-AzureRmPublicIpAddress -Name $pipRes.ResourceName -ResourceGroupName $pipRes.ResourceGroupName).IpAddress
        }

        if($lbs.Count -gt 1) {
            $lb.Name -match '\w*-(\w*)-\w*-(\w*)-\w*-\w*' > $null
            $region = $Matches[1]
            $dnsName = "$Name-$region$dnsLayerSuffix"
        }
        else {
            $dnsName = "$Name$dnsLayerSuffix"
        }

        if($Force.IsPresent) {
            New-EswDnsEndpoint -DnsName $dnsName -ResourceGroupName "global-platform-$configuration" -DnsZone $dnsZone -IpAddress $pip -Force
        }
        else {
            New-EswDnsEndpoint -DnsName $dnsName -ResourceGroupName "global-platform-$configuration" -DnsZone $dnsZone -IpAddress $pip
        }  

        if(-not $UseSsl.IsPresent) {
            $dnsEndpoints += [DnsEndpoint]@{Uri = "$dnsName.$dnsZone";
                                        Region = $region;}
        }      
    }

    Write-Host 'Done with LBs'

    #App Gateways

    if($UseSsl.IsPresent) {
        $appGateways = Get-AzureRmApplicationGateway
        $dnsSuffix = "$dnsConfiguration.eshopworld.$dnsSuffix"

        if ($appGateways.Count -gt 1) {
            $multiRegion = $true
        }

        foreach($ag in $appGateways) {
            if ($multiRegion) {
                if($force.IsPresent) {
                    New-EswApplicationGatewayConfig -AppGatewayName $ag.Name -ResourceGroupName $ag.ResourceGroupName -Name $Name -Port $Port -DnsName $dnsName -DnsSuffix $dnsSuffix -IsMultiRegion -Force
                }
                else {
                    New-EswApplicationGatewayConfig -AppGatewayName $ag.Name -ResourceGroupName $ag.ResourceGroupName -Name $Name -Port $Port -DnsName $dnsName -DnsSuffix $dnsSuffix -IsMultiRegion
                }
                
            }else {
                if($force.IsPresent) {
                    New-EswApplicationGatewayConfig -AppGatewayName $ag.Name -ResourceGroupName $ag.ResourceGroupName -Name $Name -Port $Port -DnsName $dnsName -DnsSuffix $dnsSuffix -Force
                }
                else {
                    New-EswApplicationGatewayConfig -AppGatewayName $ag.Name -ResourceGroupName $ag.ResourceGroupName -Name $Name -Port $Port -DnsName $dnsName -DnsSuffix $dnsSuffix
                }
            }            
        }

        $pipRes = Get-AzureRmResource -ResourceId ($ag.FrontendIPConfigurations[0].PublicIPAddress.Id)
        $pip = (Get-AzureRmPublicIpAddress -Name $pipRes.ResourceName -ResourceGroupName $pipRes.ResourceGroupName).IpAddress

        if($appGateways.Count -gt 1) {
            $appGatewway.Name -match '\w*-(\w*)-\w*-(\w*)-\w*-\w*' > $null
            $region = $Matches[1]
            $dnsName = "$Name-$region"
        }
        else {
            $dnsName = "$Name"
        }

        if($Force.IsPresent) {
            New-EswDnsEndpoint -DnsName $dnsName -ResourceGroupName "global-platform-$configuration" -DnsZone $dnsZone -IpAddress $pip -Force
        }
        else {
            New-EswDnsEndpoint -DnsName $dnsName -ResourceGroupName "global-platform-$configuration" -DnsZone $dnsZone -IpAddress $pip
        }  

        $dnsEndpoints += [DnsEndpoint]@{Uri = "$dnsName.$dnsZone";
                                Region = $region;}

        Write-Host 'Done with AGs'
    }

    #Traffic Manager

    if($dnsEndpoints.Count -gt 1) {        
        $tmDnsPrefix = "esw-$Name-$configuration"
        $tmDns = "$tmDnsPrefix.trafficmanager.net"
        $rgName = "global-platform-$configuration"

        if($UseSsl.IsPresent){
            $tmPort = 443
        }
        else {
            $tmPort = $Port
        }

        if($Force.IsPresent) {
            New-EswDnsEndpoint -DnsName $Name -ResourceGroupName $rgName -DnsZone $dnsZone -RecordType CNAME -CName $tmDns -Force
            New-EswTrafficManagerProfile -Name $Name -ResourceGroupName $rgName -DnsPrefix $tmDnsPrefix -DnsEndpoints $dnsEndpoints -Port $tmPort -Force
        }
        else {
            New-EswDnsEndpoint -DnsName $Name -ResourceGroupName $rgName -DnsZone $dnsZone -RecordType CNAME -CName $tmDns
            New-EswTrafficManagerProfile -Name $Name -ResourceGroupName $rgName -DnsPrefix $tmDnsPrefix -DnsEndpoints $dnsEndpoints -Port $tmPort
        } 
    }

    Write-Host 'Done with TM'    
    Write-Host 'Done with everything'
}