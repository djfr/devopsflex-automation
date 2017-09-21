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






























### JUST WORKS IN ARM - by design
function Disconnect-AzureEswNetworkSecurityGroups
{
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [Microsoft.Azure.Commands.Network.Models.PSVirtualNetwork] $VNet,

        [parameter(Mandatory=$false)]
        [string] $Subnet
    )

    # IF SUBNET
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

    ## HANDLE NICs
}









