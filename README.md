devopsflex-environments
=======================

PowerShell module to automate certain tasks that are used to complement ARM templates and other development support automation against Windows Azure.

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
