# Import functions
. "$PSScriptRoot\AutorestCreateProject.ps1"
. "$PSScriptRoot\AzureADHelpers.ps1"
. "$PSScriptRoot\AzureKeyvaultHelpers.ps1"
. "$PSScriptRoot\AzurePrincipalWithCert.ps1"
. "$PSScriptRoot\AzurePrincipalWithSecret.ps1"
. "$PSScriptRoot\AzureProfileHelpers.ps1"
. "$PSScriptRoot\AzureSQLHelpers.ps1"
. "$PSScriptRoot\AzureServicesInKeyVault.ps1"
. "$PSScriptRoot\AzureVNetHelpers.ps1"
. "$PSScriptRoot\FabricEndpoint.ps1"
. "$PSScriptRoot\ResizeASMDisk.ps1"

# Export functions
Export-ModuleMember -Function @(
    # AutorestCreateProject
    'New-AutoRestProject'

    # AzureADHelpers
    'Get-MyUserObjectId'

    # AzureKeyvaultHelpers
    'Add-MeToKeyvault'
    'Add-UserToKeyVault'
    'Get-AadAuthFile'
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
    'Register-AzureServiceBusInKeyVault'
    'Register-AzureSqlDatabaseInKeyVault'
    'Register-AzureCosmosDBInKeyVault'
    'Register-AzureRedisCacheInKeyVault'

    # AzureVNetHelpers
    'Disconnect-AzureEswNetworkSecurityGroups'
    'Get-AzureAllVNets'

    # FabricEndpoint
    'New-FabricEndPoint'

    # ResizeASMDisk
    'Set-AzureVMOSDiskSize'
)
