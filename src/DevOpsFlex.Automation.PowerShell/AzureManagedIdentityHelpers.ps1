function Add-UserAssignedIdentityToVmss
{
<#
.SYNOPSIS
Assigns a user-assigned managed identity to a VM scale set.

.DESCRIPTION
Assigns the specified user-assigned managed identity to the specified VM scale set.

.PARAMETER UserAssignedIdentityId
The ID of the user-assigned managed identity.

.EXAMPLE
Assigns the tooling-ci-id user-assigned managed identity to the tooling-vmss scale set in the tooling-rg resource group.
Add-UserAssignedIdentityToVmss tooling-rg tooling-vmss /subscriptions/11111111-2222-3333-4444-555555555555/resourcegroups/example-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/tooling-ci-id

.INPUTS
VM scale sets which user-assigned identity list should have modified

.NOTES
This function assumes you are connected to ARM (Login-AzAccount) and that you are already in the right subscription on ARM.
#>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [Microsoft.Azure.Commands.Compute.Automation.Models.PSVirtualMachineScaleSet] $item,

        [Parameter(Mandatory=$true, Position=1)]
        [string] $UserAssignedIdentityId
    )
    
    process
    {
 	    $identity = $item.Identity
	
        if($identity -eq $null)
        {
	        $identityType = "UserAssigned"
	        $identityIds = @($UserAssignedIdentityId)
        }
        elseif($identity.Type -eq "SystemAssigned")
        {
	        $identityType = "SystemAssignedUserAssigned"
	        $identityIds = @($UserAssignedIdentityId)
        }
        else
        {
            # SystemAssignedUserAssigned and UserAssigned
	        $identityType = $identity.Type
	        $identityIds = @($identity.UserAssignedIdentities.Keys)
	        if(-Not ($identityIds -contains $UserAssignedIdentityId))
	        {
	            $identityIds += $UserAssignedIdentityId
	        }
	        else
	        {
	            #no need to change anything
                return
	        }
        }

        Update-AzVmss -ResourceGroupName $item.ResourceGroupName -Name $item.Name -IdentityType $identityType -IdentityId $identityIds | Out-Null
    }
}
