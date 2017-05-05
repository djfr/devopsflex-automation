function Select-AzureAllVNets
{
<#
.SYNOPSIS
Help method to list all ASM and ARM VNets across all subscriptions that the account has access to.

.DESCRIPTION
Help method to list all ASM and ARM VNets across all subscriptions that the account has access to.

.EXAMPLE
Select-AzureEswVNets | ft *
This will show you the list of all ARM and ASM VNets on all subscriptions you have access to and output an auto formatted table.
#>

    [CmdletBinding()] param()

    $vnets = @()

    Get-AzureRmSubscription -WarningAction SilentlyContinue | % {
        $sub = $_.SubscriptionName
        Select-AzureRmSubscription -SubscriptionId $_.SubscriptionId -WarningAction SilentlyContinue > $null
        Select-AzureSubscription -SubscriptionId $_.SubscriptionId -WarningAction SilentlyContinue > $null

        # ASM
        Get-AzureRmVirtualNetwork | % {
            $vNet = $_.Name
            $_.AddressSpace.AddressPrefixes | % {
                $object = New-Object –TypeName PSObject
                $object | Add-Member -MemberType NoteProperty –Name Name –Value $vNet
                $object | Add-Member –MemberType NoteProperty –Name AddressSpace –Value $_
                $object | Add-Member –MemberType NoteProperty –Name Type –Value ASM
                $object | Add-Member –MemberType NoteProperty –Name Subscription –Value $sub

                $vnets += $object
            }
        }

        # ARM
        Get-AzureVNetSite | % {
            $vNet = $_.Name
            $_.AddressSpacePrefixes | % {
                $object = New-Object –TypeName PSObject
                $object | Add-Member -MemberType NoteProperty –Name Name –Value $vNet
                $object | Add-Member –MemberType NoteProperty –Name AddressSpace –Value $_
                $object | Add-Member –MemberType NoteProperty –Name Type –Value ARM
                $object | Add-Member –MemberType NoteProperty –Name Subscription –Value $sub

                $vnets += $object
            }
        }
    }

    Write-Output $vnets # return
}
