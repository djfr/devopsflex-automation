###########################################################
#       Get-MyUserObjectId
###########################################################

function Get-MyUserObjectId
{
    [CmdletBinding()] param()

    $user = (Get-AzureRmContext).Account
    $adUser = Get-AzureRmADUser | where { $_.UserPrincipalName -match $user.Id }

    if($adUser -eq $null) {
        $adUser = Get-AzureRmADUser | where { $_.UserPrincipalName -match $user.Id.Replace("@", "_") }
    }

    if($adUser -eq $null) {
        throw "Couldn't find you in the AD!"
    }

    return $adUser.Id
}
