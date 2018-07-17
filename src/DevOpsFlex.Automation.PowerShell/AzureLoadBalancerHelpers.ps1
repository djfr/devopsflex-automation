function New-EswLoadBalancerConfig
{
<#

.SYNOPSIS
Adds a probe and rule to an existing internal or external load balancer.

.DESCRIPTION
Adds a probe and rule to an existing internal or external load balancer.

.PARAMETER LoadBalancerName
The name of the Azure load balancer you wish to configure.

.PARAMETER ResourceGroupName
The Azure resource group name that the load balancer is in.

.PARAMETER Name
The name of the probe/rule you wish to create. The convention is that they will both have the same name.

.PARAMETER Port
The port you want to create the rule for.

.PARAMETER ProbePath
The path of the probe you wish to create. The default is '/Probe'.

.PARAMETER Force
Force the re-configuration of both the probe and the rule.

.EXAMPLE
New-EswLoadBalancerConfig -LoadBalancerName 'test-lb' -ResourceGroupName 'test-rg' -Name 'test' -Port 999
Will create a 'test' probe and rule for port '999' on the 'test-lb' load balancer in the 'test-rg' resource group.

.FUNCTIONALITY
Configures rules on load balancers.
   
#>
    [CmdletBinding()]
    param
    (
		[parameter(Mandatory=$true, Position=0)]
		[string] $LoadBalancerName,

		[parameter(Mandatory=$true, Position=1)]
		[string] $ResourceGroupName,

		[parameter(Mandatory=$true, Position=2)]
		[string] $Name,

		[parameter(Mandatory=$true, Position=3)]
		[string] $Port,

		[string] $ProbePath = "/Probe",

		[switch] $Force
    )
   
    $lbRefresh = Get-AzureRmLoadBalancer -Name $LoadBalancerName -ResourceGroupName $ResourceGroupName
    
    $rule = $null
    $probe = $null    
    try { $rule = ($lb.LoadBalancingRules | ? { $_.Name -eq $Name })[0] } catch {}   
    try { $probe = ($lbRefresh.Probes | ? { $_.Name -eq $Name })[0] } catch {}

    if($rule -or $probe -and $Force.IsPresent) {
        $lbRefresh | Remove-AzureRmLoadBalancerRuleConfig -Name $Name | Remove-AzureRmLoadBalancerProbeConfig -Name $Name | Set-AzureRmLoadBalancer > $null
        $lbRefresh = Get-AzureRmLoadBalancer -Name $LoadBalancerName -ResourceGroupName $ResourceGroupName
        $rule = $null
        $probe = $null
    }

    if($probe -eq $null) {
        $lbRefresh | Add-AzureRmLoadBalancerProbeConfig -Name "$Name" `
                                                        -Protocol Http `
                                                        -Port $Port `
                                                        -RequestPath $ProbePath `
                                                        -IntervalInSeconds 30 `
                                                        -ProbeCount 2 > $null       
    }   

    if($rule -eq $null) {
        $lbRefresh | Add-AzureRmLoadBalancerRuleConfig -Name "$Name" `
                                                        -Protocol Tcp `
                                                        -ProbeId ($lbRefresh.Probes | ? { $_.Name -eq $Name})[0].Id `
                                                        -FrontendPort $Port `
                                                        -BackendPort $Port `
                                                        -FrontendIpConfigurationId $lbRefresh.FrontendIpConfigurations[0].Id `
                                                        -BackendAddressPoolId $lbRefresh.BackendAddressPools[0].Id > $null        
    }

    $lbRefresh | Set-AzureRmLoadBalancer > $null
}