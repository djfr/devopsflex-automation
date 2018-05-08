function New-FabricEndPoint
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=0)]
        [ValidateSet('default', 'checkout', 'logistics', 'payments')]
        [string] $Component,

        [parameter(Mandatory=$true, Position=0)]
        [string] $Name,

        [parameter(Mandatory=$true, Position=1)]
        [int] $Port,

        [parameter(Mandatory=$false)]
        [string] $ProbePath = "/Probe",

        [switch] $UseSsl
    )



    # Find the load balancer(s)
    $lbs = Get-AzureRmLoadBalancer | ? { $_.Name.ToLower() -match $Component }

    if($UseSsl.IsPresent) {
        $lbs = $lbs | ? { $_.Name -match '-ilb' }
    }
    else {
        $lbs = $lbs | ? { $_.Name -match '-lb' }
    }

    $lbs | % {
        Write-Host "LB: $($_.Name)"

        # Find the Configuration / DNS record settings
        $_.Name -match '\w*-(\w*)-\w*-(\w*)-\w*-\w*' > $null
        $region = $Matches[1]
        $configuration = $Matches[2]

        if($configuration -eq 'prod') {
            $dnsSuffix = 'com'
        }
        else {
            $dnsSuffix = 'net'
        }

        if($lbs.Count -gt 1) {
            $dnsName = "$Name-$region"
        }
        else {
            $dnsName = "$Name"
        }

        # Find the public IP address of the load balancer
        $pipRes = Get-AzureRmResource -ResourceId ($_.FrontendIpConfigurations[0].PublicIpAddress.Id)

        Write-Host "$pipRes"

        $pip = (Get-AzureRmPublicIpAddress -Name $pipRes.ResourceName -ResourceGroupName $pipRes.ResourceGroupName).IpAddress

        Write-Host "DNS: $dnsName"
        Write-Host "Region: $region"
        Write-Host "Configuration: $configuration"
        Write-Host "PIP: $pip"

        New-AzureRmDnsRecordSet -Name "$dnsName" `
                                -RecordType A `
                                -ZoneName "$configuration.eshopworld.$dnsSuffix" `
                                -ResourceGroupName "global-platform-$configuration" `
                                -Ttl 360 `
                                -DnsRecords (New-AzureRmDnsRecordConfig -IPv4Address "$pip")

        $probeName = "$Name-probe"
        $_ | Add-AzureRmLoadBalancerProbeConfig -Name "$probeName" `
                                                -Protocol Http `
                                                -Port 80 `
                                                -RequestPath $ProbePath `
                                                -IntervalInSeconds 360 `
                                                -ProbeCount 2
        $_ | Set-AzureRmLoadBalancer

        $probeId = ((Get-AzureRmLoadBalancer -Name $_.Name -ResourceGroupName $_.ResourceGroupName).Probes | ? { $_.Name -match "$Name-probe"})[0].Id
        $_ | Add-AzureRmLoadBalancerRuleConfig -Name "$Name" `
                                               -Protocol Http `
                                               -ProbeId $probeId `
                                               -FrontendPort $Port `
                                               -BackendPort $Port `
                                               -FrontendIpConfigurationId $_.FrontendIpConfigurations[0].Id `
                                               -BackendAddressPoolId $_.BackendAddressPools[0].Id
        $_ | Set-AzureRmLoadBalancer
    }
}
