function Register-AzureServiceBusInKeyVault
{
<#
.SYNOPSIS
Adds Azure service bus connection strings as secrets to keyvault.

.DESCRIPTION
Scans service bus namespaces for authorization rules and sets the keyvault secret to the connection string.

.PARAMETER KeyVaultName 
Specifies the key vault to set the secrets in.

.PARAMETER ResourceGroup
Specifies the target resource group

.PARAMETER Environment
Specifies the environment to limit the service bus namespace on.

.PARAMETER Regex
Specifies the regex to limit the service bus namespace on.

.EXAMPLE
Register-AzureServiceBus -KeyVaultName "test-vault" -ResourceGroup "testRG" -Environment "uat" -Regex "(esw)"
This command sets secrets in the test-vault for all environments ending in uat and containing esw in their namespace.

.NOTES
Currently CmdletBinding doesn't have any internal support built-in.
#>
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$false)]
        [string] $ResourceGroup,

        [parameter(Mandatory=$false)]
        [string] $Environment,

        [parameter(Mandatory=$false)]
        [string] $Regex
    )

    if(!$ResourceGroup) {
        $rules = Get-AzureRmServiceBusNamespace | % { Get-AzureRmServiceBusAuthorizationRule -Namespace $_.Name -ResourceGroupName $_.ResourceGroup } | ? { $_.Name -eq 'RootManageSharedAccessKey' } 

    }
    else {
        $rules = Get-AzureRmResourceGroup -Name $ResourceGroup | Get-AzureRmServiceBusNamespace | % { Get-AzureRmServiceBusAuthorizationRule -Namespace $_.Name -ResourceGroupName $_.ResourceGroup } | ? { $_.Name -eq 'RootManageSharedAccessKey' } 
    }
    
    $rules | % { 
        if(($Environment -eq $null) -or ($_.Namespace -match "-$Environment`$")) {
            if(($Regex -eq $null) -or ($_.Namespace -match "$Regex")) {
                $keyName = $_.Namespace.Remove($_.Namespace.LastIndexOf('-'))

                Write-Output "Pushing $($keyName) to $($KeyVaultName)"

                $null = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String $_.ConnectionString -AsPlainText -Force)
            }
        }
    }
}

function Register-AzureSqlDatabaseInKeyVault
{
<#
.SYNOPSIS
Adds Azure sql database connection strings as secrets to keyvault.

.DESCRIPTION
Scans sql database instances based on the search criteria and sets the key vault secrets to the connection strings.

.PARAMETER KeyVaultName 
Specifies the key vault to set the secrets in.

.PARAMETER ResourceGroup
Specifies the resource group the azure sql server is in.

.PARAMETER Environment
Specifies the environment to limit the sql database name on.

.PARAMETER Regex
Specifies the regex to limit the sql database name on.

.PARAMETER SqlSaPassword
SQL Administrator password to use.

.PARAMETER ConfigurationKeyVaultName
Key vault name to get existing sql username and password secrets from.

.EXAMPLE
Register-AzureSqlDatabase -KeyVaultName "test-vault" -ResourceGroup "test-rg" -Environment "uat" -Regex "(esw)" -SqlSaPassword "#sapasword1234" -ConfigurationKeyVaultName "sqlkvtest"
This command sets secrets in the test-vault for all environments ending in uat and containing esw in their name.

.NOTES
Currently CmdletBinding doesn't have any internal support built-in.
#>
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$false)]
        [string] $ResourceGroup,

        [parameter(Mandatory=$false)]
        [string] $Environment,

        [parameter(Mandatory=$false)]
        [string] $Regex,

        [parameter(Mandatory=$true, ParameterSetName='SaUser')]
        [string] $SqlSaPassword,

        [parameter(Mandatory=$true, ParameterSetName='KeyVaultUser')]
        [string] $ConfigurationKeyVaultName
    )

    if(!$ResourceGroup) {
        $dbs = Get-AzureRmSqlServer | Get-AzureRmSqlDatabase | ? { $_.DatabaseName -ne 'master' }
    }
    else {
        $dbs = Get-AzureRmResourceGroup -Name $ResourceGroup | Get-AzureRmSqlServer | Get-AzureRmSqlDatabase | ? { $_.DatabaseName -ne 'master' }
    }

    $dbs | % {
        if(($Environment -eq $null) -or ($_.DatabaseName -match "-$Environment`$")) {
            if(($Regex -eq $null) -or ($_.DatabaseName -match "$Regex")) {
                $server = $_ | Get-AzureRmSqlServer

                if($SqlSaPassword -ne $null) {
                    $sqlUser = $server.SqlAdministratorLogin
                    $sqlPwd = $SqlSaPassword
                }
                else {
                    $userKey = "$($_.DatabaseName.Replace('-', ''))user"
                    $pwdKey = "$userKey-pwd"

                    $sqlUser = (Get-AzureKeyVaultSecret -VaultName $ConfigurationKeyVaultName -Name $userKey).SecretValueText
                    $sqlPwd = (Get-AzureKeyVaultSecret -VaultName $ConfigurationKeyVaultName -Name $pwdKey).SecretValueText
                }

                $connectionString = "Server=tcp:$($server.ServerName).database.windows.net; Database=$($_.DatabaseName); User ID=$sqlUser@$($server.ServerName); Password=$sqlPwd; Trusted_Connection=False; Encrypt=True; MultipleActiveResultSets=True;"

                Write-Output "Pushing SQLConnectionString to $($KeyVaultName)"

                $null = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name 'SQLConnectionString' -SecretValue (ConvertTo-SecureString -String $connectionString -AsPlainText -Force)
            }
        }
    } 
}

function Register-AzureCosmosDBInKeyVault
{
<#
.SYNOPSIS
Adds Azure cosmos db primary keys as secrets to keyvault.

.DESCRIPTION
Scans cosmos db account instances based on the search criteria and sets the key vault secrets to the primary keys.

.PARAMETER KeyVaultName 
Specifies the key vault to set the secrets in.

.PARAMETER ResourceGroup
Specifies the resource group the cosmos db account is in.

.PARAMETER Environment
Specifies the environment to limit the cosmos db account name on.

.PARAMETER Regex
Specifies the regex to limit the cosmos db account name on.

.EXAMPLE
Register-AzureCosmosDB -KeyVaultName "test-vault" -ResourceGroup "test-rg" -Environment "uat" -Regex "(esw)"
This command sets secrets in the test-vault for all environments ending in uat and containing esw in their name.

.NOTES
Currently CmdletBinding doesn't have any internal support built-in.
#>
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$true)]
        [string] $ResourceGroup,

        [parameter(Mandatory=$false)]
        [string] $Environment,

        [parameter(Mandatory=$false)]
        [string] $Regex
    )

    $rsType = "Microsoft.DocumentDb/databaseAccounts"
    $cosmosAccounts = Get-AzureRmResource -ResourceType $rsType -ResourceGroupName $ResourceGroup
    
    $cosmosAccounts | % { 
        if(($Environment -eq $null) -or ($_.Name -match "-$Environment`$")) {
            if(($Regex -eq $null) -or ($_.Name -match "$Regex")) {
                $keyName = $_.Name.Remove($_.Name.LastIndexOf('-')) 
                
                $keys = Invoke-AzureRmResourceAction -Action listKeys -ResourceType $rsType -ResourceGroupName $ResourceGroup -ResourceName $_.Name -Force

                Write-Output "Pushing $($keyName) to $($KeyVaultName)"
                
                $null = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String $keys.primaryMasterKey -AsPlainText -Force)         
            }
        }
    }
}

function Register-AzureRedisCacheInKeyVault
{
<#
.SYNOPSIS
Adds Azure redis cache primary keys as secrets to keyvault.

.DESCRIPTION
Scans redis cache instances based on the search criteria and sets the key vault secrets to the primary keys.

.PARAMETER KeyVaultName 
Specifies the key vault to set the secrets in.

.PARAMETER ResourceGroup
Specifies the resource group the redis cache is in.

.PARAMETER Environment
Specifies the environment to limit the redis cache name on.

.PARAMETER Regex
Specifies the regex to limit the redis cache name on.

.EXAMPLE
Register-AzureRedisCache -KeyVaultName "test-vault" -ResourceGroup "test-rg" -Environment "uat" -Regex "(esw)"
This command sets secrets in the test-vault for all environments ending in uat and containing esw in their name.

.NOTES
Currently CmdletBinding doesn't have any internal support built-in.
#>
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$false)]
        [string] $ResourceGroup,

        [parameter(Mandatory=$false)]
        [string] $Environment,

        [parameter(Mandatory=$false)]
        [string] $Regex
    )

    if(!$ResourceGroup) {
        $caches = Get-AzureRmRedisCache
    }
    else {
        $caches = Get-AzureRmRedisCache -ResourceGroupName $ResourceGroup
    }

    $caches | % { 
        if(($Environment -eq $null) -or ($_.Name -match "-$Environment`$")) {
            if(($Regex -eq $null) -or ($_.Name -match "$Regex")) {
                $keyName = $_.Name.Remove($_.Name.LastIndexOf('-')) 
                
                $primaryKey = (Get-AzureRmRedisCacheKey -ResourceGroupName $_.ResourceGroupName -Name $_.Name).PrimaryKey

                Write-Output "Pushing $($keyName) to $($KeyVaultName)"

                $null = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String $primaryKey -AsPlainText -Force)         
            }
        }
    }
}