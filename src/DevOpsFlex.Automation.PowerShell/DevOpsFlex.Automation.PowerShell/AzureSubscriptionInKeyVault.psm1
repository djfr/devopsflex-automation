#
# AzureSubscriptionInKeyVault.psm1
#

### Scans both ASM and ARM storage accounts and pushes all relevant keys to KeyVault
function Register-AzureStorage
{
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$true)]
        [ValidateSet('Primary','Secondary')]
        [string] $KeyType,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentRegex
    )

    Get-AzureStorageAccount | Get-AzureStorageKey | foreach {
        $keyName = $_.StorageAccountName -replace $EnvironmentRegex, ''
        $void = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String  $_.$KeyType -AsPlainText –Force)
    }

    switch($KeyType)
    {
        "Primary" {$keyIndex = 0}
        "Secondary" {$keyIndex = 1}
        default {$keyIndex = 0}
    }

    Get-AzureRmStorageAccount | select StorageAccountName, @{Name="Key";Expression={(Get-AzureRmStorageAccountKey -ResourceGroupName $_.ResourceGroupName -Name $_.StorageAccountName)[$keyIndex].Value}} | foreach {
        $keyName = $_.StorageAccountName -replace $EnvironmentRegex, ''
        $void = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String $_.Key -AsPlainText –Force)
    }
}

function Register-AzureServiceBus
{
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$false)]
        [string] $SbAccessRuleName,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentRegex
    )

    Get-AzureSBNamespace | foreach { Get-AzureSBAuthorizationRule -Namespace $_.Name } | where { $_.Name -eq 'RootManageSharedAccessKey' } | foreach {
        $keyName = $_.Namespace -replace $EnvironmentRegex, ''
        $void = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String $_.ConnectionString -AsPlainText –Force)
    }
}

function Register-AzureSqlDatabase
{
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$true)]
        [string] $SqlPassword,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentRegex,

        [switch] $SetSqlPassword
    )

    Get-AzureRmResourceGroup | Get-AzureRmSqlServer | Get-AzureRmSqlDatabase | where { $_.DatabaseName -ne 'master' } | foreach {
        $server = $_ | Get-AzureRmSqlServer

        # Set the SqlPassword on the server
        if($SetSqlPassword) {
            $server | Set-AzureRmSqlServer -SqlAdministratorPassword (ConvertTo-SecureString -String $SqlPassword -AsPlainText –Force)
        }

        $connectionString = "Server=tcp:$($server.ServerName).database.windows.net; Database=$($_.DatabaseName); User ID=$($server.SqlAdministratorLogin)@$($server.ServerName); Password=$SqlPassword; Trusted_Connection=False; Encrypt=True; MultipleActiveResultSets=True;"
        $keyName = $_.DatabaseName -replace $EnvironmentRegex, ''
        $void = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String $connectionString -AsPlainText –Force)
    }
}

function Register-AzureSubscriptionInKeyVault
{
    param(
        [parameter(Mandatory=$true, Position=0)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$true, Position=1)]
        [ValidateSet('Primary','Secondary')]
        [string] $KeyType,

        [parameter(Mandatory=$true, Position=2)]
        [string] $SqlPassword,

        [parameter(Mandatory=$false)]
        [string] $StgEnvRegex = '(.{3})$',

        [parameter(Mandatory=$false)]
        [string] $SbEnvRegex = '(-[^-]*)$',

        [parameter(Mandatory=$false)]
        [string] $SqlEnvRegex = '(-[^-]*)$',

        [parameter(Mandatory=$false)]
        [string] $SbAccessRuleName = 'RootManageSharedAccessKey',

        [switch] $SetSqlPassword
    )

    Register-AzureStorage -KeyVaultName $KeyVaultName -KeyType $KeyType -EnvironmentRegex $StgEnvRegex
    Register-AzureServiceBus -KeyVaultName $KeyVaultName -SbAccessRuleName $SbAccessRuleName -EnvironmentRegex $SbEnvRegex
    Register-AzureSqlDatabase -KeyVaultName $KeyVaultName -SqlPassword $SqlPassword -EnvironmentRegex $SqlEnvRegex -SetSqlPassword:$SetSqlPassword
}
