# Import functions
. "$PSScriptRoot\AzureADHelpers.ps1"
. "$PSScriptRoot\AzureKeyvaultHelpers.ps1"
. "$PSScriptRoot\AzurePrincipalWithCert.ps1"
. "$PSScriptRoot\AzurePrincipalWithSecret.ps1"
. "$PSScriptRoot\AzureProfileHelpers.ps1"
. "$PSScriptRoot\AzureSQLHelpers.ps1"
. "$PSScriptRoot\AzureServicesInKeyVault.ps1"
. "$PSScriptRoot\AzureVNetHelpers.ps1"
. "$PSScriptRoot\ResizeASMDisk.ps1"

# Export functions
Export-ModuleMember -Function @(
    # AzureADHelpers
    'Get-MyUserObjectId'

    # AzureKeyvaultHelpers
    'Add-MeToKeyvault'
    'Add-UserToKeyVault'
    'New-SWRandomPassword'
    'New-UserInKeyVault'

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

    # AzureSQLHelpers
    'New-AzureSQLDbOwner'

    # AzureServicesInKeyVault
    'Register-AzureServiceBus'
    'Register-AzureSqlDatabase'
    'Register-AzureCosmosDB'
    'Register-AzureRedisCache'

    # AzureVNetHelpers
    'Disconnect-AzureEswNetworkSecurityGroups'
    'Get-AzureAllVNets'

    # ResizeASMDisk
    'Set-AzureVMOSDiskSize'
)
