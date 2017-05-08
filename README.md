devopsflex-automation
=======================

PowerShell module to automate certain tasks that are used to complement ARM templates and other development support automation against Windows Azure.

## Functions in this module

#### [New-AzurePrincipalWithCert](docs/New-AzurePrincipalWithCert.md)

Creates an Azure Service Principal that uses an x509 certificate to authenticate against the Azure AD.

#### [Remove-AzurePrincipalWithCert](docs/Remove-AzurePrincipalWithCert.md)

Removes an Azure Service Principal that uses an x509 certificate to authenticate against the Azure AD.

#### [New-AzurePrincipalWithSecret](docs/New-AzurePrincipalWithSecret.md)

Creates an Azure Service Principal that uses a password to authenticate against the Azure AD.

#### [Remove-AzurePrincipalWithSecret](docs/Remove-AzurePrincipalWithSecret.md)

Removes an Azure Service Principal that uses a password to authenticate against the Azure AD.

#### [Set-AzureVMOSDiskSize](docs/Set-AzureVMOSDiskSize.md)

Resizes the operating system VHD on an ASM Azure VM.

#### [Get-MyUserObjectId](docs/Get-MyUserObjectId.md)

Gets the current user (from Get-AzureRmContext) AD object ID.

#### [Add-MeToKeyvault](docs/Add-MeToKeyvault.md)

Adds the current user (from Get-AzureRmContext) to a specific keyvault with all permissions on both secrets and keys.

#### [Register-AzureSubscriptionInKeyVault](docs/Register-AzureSubscriptionInKeyVault.md)

Scans the current subscription and adds all relevant component keys and connections strings to a specific keyvault.
Currently supports:

- Azure Storage accounts (both ASM and ARM)
- Azure ServiceBus namespaces
- Azure SQL databases

#### [Get-AzureAllVNets](docs/Get-AzureAllVNets.md)

Scans all subscriptions that the account has access to for both ARM and ASM VNets and lists the relevant bits:

- Name
- AddressPrefix
- Type (ARM/ASM)
- Subscription Namer

#### [New-SWRandomPassword](docs/New-SWRandomPassword.md)

Helper method to generate strong passwords.

#### [New-UserInKeyVault](docs/New-UserInKeyVault.md)

Uses New-SWRandomPassword to generate a password for the new user account and stores everything
in a specified KeyVault including full tags that allow for easy labeling of the secrets.
