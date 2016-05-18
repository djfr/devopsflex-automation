
# Import functions
$rootModulePath = Split-Path $script:MyInvocation.MyCommand.Path
. "$PSScriptRoot\AzureADHelpers.ps1"
. "$PSScriptRoot\AzurePrincipalWithCert.ps1"
. "$PSScriptRoot\AzurePrincipalWithSecret.ps1"
. "$PSScriptRoot\AzureSubscriptionInKeyVault.ps1"
. "$PSScriptRoot\ResizeASMDisk.ps1"

# Export functions
Export-ModuleMember -Function @(
    # AzureADHelpers
    'Get-MyUserObjectId'
    'Add-MeToKeyvault'
    # AzurePrincipalWithCert
    'New-AzurePrincipalWithCert'
    'Remove-AzurePrincipalWithCert'
    # AzurePrincipalWithSecret
    'New-AzurePrincipalWithSecret'
    'Remove-AzurePrincipalWithSecret'
    # AzureSubscriptionInKeyVault
    'Register-AzureSubscriptionInKeyVault'
    # ResizeASMDisk
    'Set-AzureVMOSDiskSize'
    )
