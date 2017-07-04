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
