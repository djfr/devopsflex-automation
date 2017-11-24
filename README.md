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

#### [Register-AzureServiceBusInKeyVault](docs/Register-AzureServiceBusInKeyVault.md)

Adds Azure service bus connection strings as secrets to keyvault.
Scans service bus namespaces for authorization rules and sets the keyvault secret to the connection string.

#### [Register-AzureSqlDatabaseInKeyVault](docs/Register-AzureSqlDatabaseInKeyVault.md)

Adds Azure sql database connection strings as secrets to keyvault.
Scans sql database instances based on the search criteria and sets the key vault secrets to the connection strings.

#### [Register-AzureCosmosDBInKeyVault](docs/Register-AzureCosmosDBInKeyVault.md)

Adds Azure cosmos db primary keys as secrets to keyvault.
Scans cosmos db account instances based on the search criteria and sets the key vault secrets to the primary keys.

#### [Register-AzureRedisCacheInKeyVault](docs/Register-AzureRedisCacheInKeyVault.md)

Adds Azure redis cache primary keys as secrets to keyvault.
Scans redis cache instances based on the search criteria and sets the key vault secrets to the primary keys.

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

#### [New-AzureSQLDbOwner](docs/New-AzureSQLDbOwner.md)

Generes a user/password pair for Azure SQL authentication and adds that user as a dbowner for the target database.
It then uploads the generated pair to keyvault with relevant tags applied.

#### [Disconnect-AzureEswNetworkSecurityGroups](docs/Disconnect-AzureEswNetworkSecurityGroups.md)

Kill switch for NSGs in ARM VNets and NICs. <br />
Dissociates NSGs from VNets, Subnets and Nics in a fast and efficient manner.
