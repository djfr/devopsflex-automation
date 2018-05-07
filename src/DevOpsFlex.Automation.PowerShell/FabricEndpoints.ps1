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
        [int] $ProbePath = "/Probe",

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
        # Find the Configuration
        $_ -match '\w*-\w*-\w*-(\w*)-\w*-\w*' > $null
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

        # FIND PUBLIC IP ADDRESS OF THE LOAD BALANCER

        New-AzureRmDnsRecordSet -Name "$dnsName" `
                                -RecordType A `
                                -ZoneName "$configuration.eshopworld.$dnsSuffix" `
                                -ResourceGroupName "global-platform-$configuration" `
                                -Ttl 360 `
                                -DnsRecords (New-AzureRmDnsRecordConfig -IPv4Address "1.2.3.4")

        Set-AzureRmLoadBalancerProbeConfig -Name "$Name-probe" `
                                           -LoadBalancer $_ `
                                           -Protocol Http `
                                           -Port 80 `
                                           -RequestPath $ProbePath `
                                           -IntervalInSeconds 360 `
                                           -ProbeCount 2

        Set-AzureRmLoadBalancerRuleConfig -Name "$Name" -Protocol Http `
  -Probe $probe -FrontendPort 80 -BackendPort 80 `
  -FrontendIpConfiguration $feip -BackendAddressPool $bePool
    }
}
