# Import functions
. "$PSScriptRoot\AzureADHelpers.ps1"
. "$PSScriptRoot\AzureKeyvaultHelpers.ps1"
. "$PSScriptRoot\AzurePrincipalWithCert.ps1"
. "$PSScriptRoot\AzurePrincipalWithSecret.ps1"
. "$PSScriptRoot\AzureProfileHelpers.ps1"
. "$PSScriptRoot\AzureSubscriptionInKeyVault.ps1"
. "$PSScriptRoot\AzureVNetHelpers.ps1"
. "$PSScriptRoot\ResizeASMDisk.ps1"

# Export functions
Export-ModuleMember -Function @(
    # AzureADHelpers
    'Get-MyUserObjectId'

    # AzureKeyvaultHelpers
    'Add-MeToKeyvault'
    'Add-UserToKeyVault'

    # AzurePrincipalWithCert
    'New-AzurePrincipalWithCert'
    'Remove-AzurePrincipalWithCert'

    # AzurePrincipalWithSecret
    'New-AzurePrincipalWithSecret'
    'Remove-AzurePrincipalWithSecret'

    # AzureProfileHelpers
    'Reset-Alias'
    'Add-AzureAccounts'
    'Switch-AzureSubscription'

    # AzureSubscriptionInKeyVault
    'Register-AzureSubscriptionInKeyVault'

    # AzureVNetHelpers
    'Get-AzureAllVNets'

    # ResizeASMDisk
    'Set-AzureVMOSDiskSize'
    )
