class vNet
{
    [string] $Name
    [string] $AddressSpace
    [string] $Type
    [string] $Subscription
}

function Get-AzureAllVNets
{
<#
.SYNOPSIS
Help method to list all ASM and ARM VNets across all subscriptions that the account has access to.

.DESCRIPTION
Help method to list all ASM and ARM VNets across all subscriptions that the account has access to.

.EXAMPLE
Get-AzureAllVNets | ft *
This will show you the list of all ARM and ASM VNets on all subscriptions you have access to and output an auto formatted table.
#>

    [CmdletBinding()] param()

    $vnets = @()

    Get-AzureRmSubscription -WarningAction SilentlyContinue | % {
        $sub = $_.Name
        Select-AzureRmSubscription -SubscriptionId $_.Id -WarningAction SilentlyContinue > $null
        Select-AzureSubscription -SubscriptionId $_.Id -WarningAction SilentlyContinue > $null

        # ASM
        Get-AzureRmVirtualNetwork | % {
            $vNet = $_.Name
            $_.AddressSpace.AddressPrefixes | % {
                $vnets += [vNet]@{
                              Name = $vNet;
                              AddressSpace = $_;
                              Type = 'ASM';
                              Subscription = $sub;
                          }
            }
        }

        # ARM
        Get-AzureVNetSite | % {
            $vNet = $_.Name
            $_.AddressSpacePrefixes | % {
                $vnets += [vNet]@{
                              Name = $vNet;
                              AddressSpace = $_;
                              Type = 'ASM';
                              Subscription = $sub;
                          }
            }
        }
    }

    Write-Output $vnets # return
}

function Disconnect-AzureEswNetworkSecurityGroups
{
<#
.Synopsis
Kill switch for NSGs in ARM VNets and NICs.

.DESCRIPTION
Kill switch for NSGs in ARM VNets and NICs.
Dissociates NSGs from VNets, Subnets and Nics in a fast and efficient manner.

.PARAMETER VNet
The target VNet to dissociates NSGs from.

.PARAMETER Subnet
The target Subnet in the VNet to dissociates NSGs from.
If $null it will attempt to dissociate all NSGs from all Subnets in the VNet.

.PARAMETER Nic
The target NIC (Network Interface card) to dissociates NSGs from.

.EXAMPLE
Get-AzureRmVirtualNetwork -Name my-vnet -ResourceGroupName my-rg | Disconnect-AzureEswNetworkSecurityGroups
Dissociates all NSGs from all the subnets in the my-vnet ARM Virtual Network.

.EXAMPLE
Get-AzureRmVirtualNetwork -Name my-vnet -ResourceGroupName my-rg | Disconnect-AzureEswNetworkSecurityGroups -Subnet my-subnet
Dissociates all NSGs from just for the my-subnet Subnet in the my-vnet ARM Virtual Network.

.EXAMPLE
Get-AzureRmNetworkInterface -Name my-nic -ResourceGroupName my-rg | Disconnect-AzureEswNetworkSecurityGroups
Dissociates all NSGs from the ARM NIC my-nic.
#>

    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true, ValueFromPipeline=$true, ParameterSetName='VNet')]
        [Microsoft.Azure.Commands.Network.Models.PSVirtualNetwork] $VNet,

        [parameter(Mandatory=$false, ParameterSetName='VNet')]
        [string] $Subnet,

        [parameter(Mandatory=$false, ParameterSetName='Nic')]
        [Microsoft.Azure.Commands.Network.Models.PSNetworkInterface] $Nic
    )

    if($VNet) {
        $subnets = $VNet.Subnets

        if($Subnet) {
            $subnets = $subnets | ? { $_.Name -eq $Subnet }

            if($subnets.Count -eq 0) {
                throw "Couldn't find a subnet named $Subnet in the $($Vnet.Name) VNet"
            }

            $subnets[0]
        }

        if($subnets.Count -gt 1) {
            $ConfirmPreference = 'Low'
            if (!$PSCmdlet.ShouldContinue('Are you sure that you want to disconnect all NSGs from all subnets?',"You're removing all NSGs!")) {
                Write-Warning "You were trying to disconnect all NSGs from the $($Vnet.Name) VNet but you decided to abort"
                Write-Warning "No changes have been made"
                return
            }
        }

        $subnets | % { $_.NetworkSecurityGroup = $null }
        $VNet | Set-AzureRmVirtualNetwork
    }
    elseif($Nic) {
        $Nic.NetworkSecurityGroup = $null
        $Nic | Set-AzureRmNetworkInterface
    } # Drop un-handled parameter sets
}









