###########################################################
#       Add-MeToKeyvault
###########################################################

function Add-MeToKeyvault
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=0)]
        [string] $KeyvaultName
    )

    $userId = Get-MyUserObjectId
    Set-AzureRmKeyVaultAccessPolicy -VaultName $KeyvaultName -ObjectId $userId -PermissionsToKeys all -PermissionsToSecrets all
}


###########################################################
#       Add-UserToKeyVault
###########################################################

function Add-UserToKeyVault
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=0)]
        [string] $KeyvaultName,

        [parameter(Mandatory=$true, Position=1)]
        [string] $Username
    )

    $adUsers = Get-AzureRmADUser | where { $_.UserPrincipalName -match $Username }

    if($adUsers.Count -gt 1) {
        Write-Warning 'Found Multiple users using UserPrincipalName as the search query - Exiting ...'
        $adUsers |ft *
        return
    }
    elseif($adUsers.Count -eq 0) {
        Write-Warning 'Found no users using UserPrincipalName as the search query'

        $adUsers = Get-AzureRmADUser | where { $_.DisplayName -match $Username }

        if($adUsers.Count -gt 1) {
            Write-Warning 'Found Multiple users using DisplayName as the search query - Exiting ...'
            $adUsers |ft *
            return
        }

        if($adUsers.Count -eq 0) {
            Write-Warning 'Found no users using DisplayName as the search query - Exiting ...'
            return
        }
    }

    Write-Host '`nFound a user and adding him to Keyvault:'
    $adUsers |fl

    Set-AzureRmKeyVaultAccessPolicy -VaultName $KeyvaultName -ObjectId $adUsers[0].Id -PermissionsToKeys all -PermissionsToSecrets all > $null
}