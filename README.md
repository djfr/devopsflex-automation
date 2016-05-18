devopsflex-automation
=======================

PowerShell module to automate certain tasks that are used to complement ARM templates and other development support automation against Windows Azure.

Push to PSGallery build:

![](https://djfr.visualstudio.com/_apis/public/build/definitions/08587db2-4c39-4e7b-8bd1-caef22e0cd47/3/badge)

## Functions in this module

#### New-AzurePrincipalWithCert

Creates an Azure Service Principal that uses an x509 certificate to authenticate against the Azure AD.

#### Remove-AzurePrincipalWithCert

Removes an Azure Service Principal that uses an x509 certificate to authenticate against the Azure AD.

#### New-AzurePrincipalWithSecret

Creates an Azure Service Principal that uses a password to authenticate against the Azure AD.

#### Remove-AzurePrincipalWithSecret

Removes an Azure Service Principal that uses a password to authenticate against the Azure AD.

#### Set-AzureVMOSDiskSize

Resizes the operating system VHD on an ASM Azure VM.

#### Get-MyUserObjectId

Gets the current user (from Get-AzureRmContext) AD object ID.

#### Add-MeToKeyvault

Adds the current user (from Get-AzureRmContext) to a specific keyvault with all permissions on both secrets and keys.

#### Register-AzureSubscriptionInKeyVault

Scans the current subscription and adds all relevant component keys and connections strings to a specific keyvault.
Currently supports:

- Azure Storage accounts (both ASM and ARM)
- Azure ServiceBus namespaces
- Azure SQL databases