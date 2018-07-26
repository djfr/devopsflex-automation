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

    #Is this a single or multi-region environment?
    $rgs = Get-AzureRmResourceGroup | ? { $_.ResourceGroupName -match '((we|eus|ase|sea)-(platform)-(ci|test|prep|sand|prod))' }

    if($rgs.Count -gt 1) {
        $multiRegion = $true
    }

    #Which environment is this?
    $rgs[0].ResourceGroupName -match '((we|eus|ase|sea)-(platform)-(ci|test|prep|sand|prod))' > $null
    $environment = $Matches[4]

    #Environment level variables
    $dnsEndpoints = @()

    switch($environment)
    {
        "sand" { $dnsConfiguration = "sandbox" }
        "prep" { $dnsConfiguration = "preprod" }
        "prod" { $dnsConfiguration = "production" }
        default { $dnsConfiguration = $environment }
    }

    if($environment -eq 'prod' -or $environment -eq 'sand') {
        $dnsSuffix = 'com'
    }
    else {
        $dnsSuffix = 'net'
    }

    $dnsZone = "$dnsConfiguration.eshopworld.$dnsSuffix"

    #Configure resources for each region in the environment
    foreach($rg in $rgs) {
        $rg.ResourceGroupName -match '((we|eus|ase|sea)-(platform)-(ci|test|prep|sand|prod))' > $null
        $region = $Matches[2]

        if($UseSsl.IsPresent) {
            $lbs = Get-AzureRmLoadBalancer -ResourceGroupName $rg.ResourceGroupName | ? { $_.Name.ToLower() -match '-ilb' }
            $dnsLayerSuffix = "-lb"
        }
        else {
            $lbs = Get-AzureRmLoadBalancer -ResourceGroupName $rg.ResourceGroupName | ? { $_.Name.ToLower() -match '-lb' }
            $dnsLayerSuffix = ""
        }        

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

            if($multiRegion) {
                $dnsName = "$Name-$region$dnsLayerSuffix"
            }
            else {
                $dnsName = "$Name$dnsLayerSuffix"
            }

            if($Force.IsPresent) {
                New-EswDnsEndpoint -DnsName $dnsName -ResourceGroupName "global-platform-$environment" -DnsZone $dnsZone -IpAddress $pip -Force
            }
            else {
                New-EswDnsEndpoint -DnsName $dnsName -ResourceGroupName "global-platform-$environment" -DnsZone $dnsZone -IpAddress $pip
            }  

            if(-not $UseSsl.IsPresent) {
                $dnsEndpoints += [DnsEndpoint]@{Uri = "$dnsName.$dnsZone"; Region = $region;}
            }      
        }

        #App Gateways    
        if($UseSsl.IsPresent) {
            $appGateways = Get-AzureRmApplicationGateway -ResourceGroupName $rg.ResourceGroupName

            if(!($multiRegion)){
                $ag = $appGateways | ? { $_.HttpListeners.Count -lt 20 } | Select-Object -First 1
            }else {
                $ag = $appGateways | ? { $_.HttpListeners.Count -lt 19 } | Select-Object -First 1
            }
            
            $listener = $appGateways | % { $_.HttpListeners } | ? { $_.Name -eq $Name }            

            if($ag -eq $null -and $listener -eq $null) {
                #Provision new AG
                New-EswApplicationGateway -ResourceGroupName $rg.ResourceGroupName

                $appGateways = Get-AzureRmApplicationGateway -ResourceGroupName $rg.ResourceGroupName
                $ag = $appGateways | ? { $_.HttpListeners.Count -lt 2 } | Select-Object -First 1

                Add-EswApplicationGatewayCertificate -AppGatewayName $ag.Name -ResourceGroupName $rg.ResourceGroupName
            }            

            if($listener -ne $null -and $Force.IsPresent) {
                #Remove and re-add config
                $ag = $appGateways | ? { $listener[0].Id.Contains($_.Name) }
                
                if ($multiRegion) {
                    New-EswApplicationGatewayConfig -AppGatewayName $ag.Name -ResourceGroupName $ag.ResourceGroupName -Name "$Name" -Port $Port -DnsName $dnsName -DnsSuffix $dnsZone -IsMultiRegion -Force
                }else {
                    New-EswApplicationGatewayConfig -AppGatewayName $ag.Name -ResourceGroupName $ag.ResourceGroupName -Name $Name -Port $Port -DnsName $dnsName -DnsSuffix $dnsZone -Force
                }
            }elseif($listener -eq $null) {
                #Add new config                
                if ($multiRegion) {
                    New-EswApplicationGatewayConfig -AppGatewayName $ag.Name -ResourceGroupName $ag.ResourceGroupName -Name "$Name" -Port $Port -DnsName $dnsName -DnsSuffix $dnsZone -IsMultiRegion
                }else {
                    New-EswApplicationGatewayConfig -AppGatewayName $ag.Name -ResourceGroupName $ag.ResourceGroupName -Name $Name -Port $Port -DnsName $dnsName -DnsSuffix $dnsZone
                }
            }         

            $pipRes = Get-AzureRmResource -ResourceId ($ag.FrontendIPConfigurations[0].PublicIPAddress.Id)
            $pip = (Get-AzureRmPublicIpAddress -Name $pipRes.ResourceName -ResourceGroupName $pipRes.ResourceGroupName).IpAddress

            if($multiRegion) {
                $dnsName = "$Name-$region"
            }
            else {
                $dnsName = "$Name"
            }

            if($Force.IsPresent) {
                New-EswDnsEndpoint -DnsName $dnsName -ResourceGroupName "global-platform-$environment" -DnsZone $dnsZone -IpAddress $pip -Force
            }
            else {
                New-EswDnsEndpoint -DnsName $dnsName -ResourceGroupName "global-platform-$environment" -DnsZone $dnsZone -IpAddress $pip
            }  

            $dnsEndpoints += [DnsEndpoint]@{Uri = "$dnsName.$dnsZone"; Region = $region;}
        }
    }

    #Traffic Manager
    if($dnsEndpoints.Count -gt 1) {        
        $tmDnsPrefix = "esw-$Name-$environment"
        $tmDns = "$tmDnsPrefix.trafficmanager.net"
        $rgName = "global-platform-$environment"

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
}