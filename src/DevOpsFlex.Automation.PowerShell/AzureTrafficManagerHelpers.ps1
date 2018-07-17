function New-EswTrafficManagerProfile
{
<#

.SYNOPSIS
Create a traffic manager profile and configure it's endpoints.

.DESCRIPTION
Create a traffic manager profile and configure it's endpoints.

.PARAMETER Name
The name of the traffic manager profile to create.

.PARAMETER ResourceGroupName
The Azure resource group name that the load balancer is in.

.PARAMETER DnsPrefix
The prefix for the DNS to create.

.PARAMETER DnsEndpoints
Array of the DnsEndpoint class that contains the Uri and Region for each endpoint.

.PARAMETER Port
The port to use.

.PARAMETER ProbePath
The path of the probe you wish to create. The default is '/Probe'.

.PARAMETER Force
Force the re-creation of the traffic manager profile.

.EXAMPLE
New-EswTrafficManagerProfile -Name 'test-profile' -ResourceGroupName 'test-rg' -DnsPrefix 'test-devops-api' -DnsEndpoints $dnsEndpoints -Port '555'
Will create a test-profile with the test-devops-api prefix using the dns endpoints passed in on port 555.
See the DNSEndpoint class in the FabricEndpoints.ps1 script.

.FUNCTIONALITY
Creates and configures traffic manager profiles.
   
#>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=0)]
        [string] $Name,

        [parameter(Mandatory=$true, Position=1)]
        [string] $ResourceGroupName,

        [parameter(Mandatory=$true, Position=2)]
        [string] $DnsPrefix,

        [parameter(Mandatory=$true, Position=3)]
        [PSObject[]] $DnsEndpoints,

        [int] $Port,

        [string] $ProbePath = "/Probe",

        [switch] $Force
    )

    if($Port) {
        $tmPort = $Port
        $monitorProtocol = "HTTP"
    }
    else {
        $tmPort = 443
        $monitorProtocol = "HTTPS"
    }

    $profile = Get-AzureRmTrafficManagerProfile -Name $Name -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue

    if($profile -ne $null -and $Force.IsPresent) {
        $profile | Remove-AzureRmTrafficManagerProfile -Confirm:$false
        $profile = $null
    }

    if($profile -eq $null) {
        $profile = New-AzureRmTrafficManagerProfile -Name $Name `
                                                    -ResourceGroupName $ResourceGroupName `
                                                    -TrafficRoutingMethod Performance `
                                                    -RelativeDnsName $DnsPrefix `
                                                    -Ttl 30 `
                                                    -MonitorProtocol $monitorProtocol `
                                                    -MonitorPort $tmPort `
                                                    -MonitorPath $ProbePath `
                                                    -MonitorIntervalInSeconds 10 `
                                                    -MonitorTimeoutInSeconds 9 `
                                                    -MonitorToleratedNumberOfFailures 2
    }

    foreach($endpoint in $dnsEndpoints) {
        $tmEndpoints = $profile.Endpoints | ? { $_.Name -eq "$($endpoint.Region)-endpoint" }

        if($tmEndpoints.Count -eq 0) {
            $profile | Add-AzureRmTrafficManagerEndpointConfig -EndpointName "$($endpoint.Region)-endpoint" `
                                                                -Type ExternalEndpoints `
                                                                -Target $endpoint.Uri `
                                                                -EndpointLocation $endpoint.GetRegionName() `
                                                                -EndpointStatus Enabled > $null
        }
    }

    $profile | Set-AzureRmTrafficManagerProfile > $null
}