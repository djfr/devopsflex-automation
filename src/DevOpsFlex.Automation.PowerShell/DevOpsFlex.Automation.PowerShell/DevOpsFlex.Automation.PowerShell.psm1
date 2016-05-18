<#
    Root empty module
    Just handles the sub-imports of all other modules
#>

$rootModulePath = Split-Path $script:MyInvocation.MyCommand.Path
Import-Module "$rootModulePath\AzureADHelpers.psm1"
Import-Module "$rootModulePath\AzurePrincipalWithCert.psm1"
Import-Module "$rootModulePath\AzurePrincipalWithSecret.psm1"
Import-Module "$rootModulePath\AzureSubscriptionInKeyVault.psm1"
Import-Module "$rootModulePath\ResizeASMDisk.psm1"

Export-ModuleMember -Function @('Get-MyUserObjectId', 'Add-MeToKeyvault',                          # AzureADHelpers
                                'New-AzurePrincipalWithCert', 'Remove-AzurePrincipalWithCert',     # AzurePrincipalWithCert
                                'New-AzurePrincipalWithSecret', 'Remove-AzurePrincipalWithSecret', # AzurePrincipalWithSecret
                                'Register-AzureSubscriptionInKeyVault',                            # AzureSubscriptionInKeyVault
                                'Set-AzureVMOSDiskSize')                                           # ResizeASMDisk
