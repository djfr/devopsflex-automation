[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "", Scope="Function", Target="*")]
param()

function Get-EnvironmentForResourceName
{
    param(
        [parameter(Mandatory=$true, Position=0)]
        [string] $EnvironmentRegex,

        [parameter(Mandatory=$true, ValueFromPipeline=$true, Position=1)]
        [string] $Input
    )

    $Input -match $EnvironmentRegex | Out-Null
    $Matches[1] -match '\W*(\w*)' | Out-Null
    return $Matches[1]
}

function Register-AzureStorage
{
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$true)]
        [ValidateSet('Primary','Secondary')]
        [string] $KeyType,

        [parameter(Mandatory=$false)]
        [string] $ResourceGroup,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentFilter,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentRegex,

        [switch] $ARMOnly
    )

    if($ARMOnly -eq $false) {
        Get-AzureStorageAccount | Get-AzureStorageKey | foreach {
            if(($EnvironmentFilter -ne $null) -and (($_.StorageAccountName | Get-EnvironmentForResourceName $EnvironmentRegex) -ne $EnvironmentFilter)) { continue }

            $keyName = $_.StorageAccountName -replace $EnvironmentRegex, ''
            $null = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String  $_.$KeyType -AsPlainText –Force)
        }
    }

    switch($KeyType)
    {
        "Primary" {$keyIndex = 0}
        "Secondary" {$keyIndex = 1}
        default {$keyIndex = 0}
    }

    if($ResourceGroup -eq $null) {
        $storageAccounts = Get-AzureRmStorageAccount
    }
    else {
        $storageAccounts = Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroup
    }

    $storageAccounts | select StorageAccountName, @{Name="Key";Expression={(Get-AzureRmStorageAccountKey -ResourceGroupName $_.ResourceGroupName -Name $_.StorageAccountName)[$keyIndex].Value}} | foreach {
        if(($EnvironmentFilter -ne $null) -and (($_.StorageAccountName | Get-EnvironmentForResourceName $EnvironmentRegex) -ne $EnvironmentFilter)) { continue }

        $keyName = $_.StorageAccountName -replace $EnvironmentRegex, ''
        $null = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String $_.Key -AsPlainText –Force)
    }
}

function Register-AzureServiceBus
{
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentFilter,

        [parameter(Mandatory=$false)]
        [string] $SbAccessRuleName,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentRegex
    )

    Get-AzureSBNamespace | foreach { Get-AzureSBAuthorizationRule -Namespace $_.Name } | where { $_.Name -eq 'RootManageSharedAccessKey' } | foreach {
        if(($EnvironmentFilter -ne $null) -and (($_.Namespace | Get-EnvironmentForResourceName $EnvironmentRegex) -ne $EnvironmentFilter)) { continue }

        $keyName = $_.Namespace -replace $EnvironmentRegex, ''
        $null = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String $_.ConnectionString -AsPlainText –Force)
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
        [string] $ResourceGroup,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentFilter,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentRegex,

        [switch] $SetSqlPassword
    )

    if($ResourceGroup -eq $null) {
        $rgs = Get-AzureRmResourceGroup
    }
    else {
        $rgs = Get-AzureRmResourceGroup -Name $ResourceGroup
    }

    $rgs | Get-AzureRmSqlServer | Get-AzureRmSqlDatabase | where { $_.DatabaseName -ne 'master' } | foreach {
        if(($EnvironmentFilter -ne $null) -and (($_.DatabaseName | Get-EnvironmentForResourceName $EnvironmentRegex) -ne $EnvironmentFilter)) { continue }

        $server = $_ | Get-AzureRmSqlServer

        # Set the SqlPassword on the server
        if($SetSqlPassword) {
            $server | Set-AzureRmSqlServer -SqlAdministratorPassword (ConvertTo-SecureString -String $SqlPassword -AsPlainText –Force)
        }

        $connectionString = "Server=tcp:$($server.ServerName).database.windows.net; Database=$($_.DatabaseName); User ID=$($server.SqlAdministratorLogin)@$($server.ServerName); Password=$SqlPassword; Trusted_Connection=False; Encrypt=True; MultipleActiveResultSets=True;"
        $keyName = $_.DatabaseName -replace $EnvironmentRegex, ''
        $null = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String $connectionString -AsPlainText –Force)
    }
}

###########################################################
#       Register-AzureSubscriptionInKeyVault
###########################################################

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
        [string] $ResourceGroup,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentFilter,

        [parameter(Mandatory=$false)]
        [string] $StgEnvRegex = '(.{3})$',

        [parameter(Mandatory=$false)]
        [string] $SbEnvRegex = '(-[^-]*)$',

        [parameter(Mandatory=$false)]
        [string] $SqlEnvRegex = '(-[^-]*)$',

        [parameter(Mandatory=$false)]
        [string] $SbAccessRuleName = 'RootManageSharedAccessKey',

        [switch] $SetSqlPassword,

        [switch] $ARMOnly
    )

    Register-AzureStorage -KeyVaultName $KeyVaultName -KeyType $KeyType -ResourceGroup $ResourceGroup -EnvironmentRegex $StgEnvRegex -ARMOnly:$ARMOnly

    Register-AzureSqlDatabase -KeyVaultName $KeyVaultName -SqlPassword $SqlPassword -ResourceGroup $ResourceGroup -EnvironmentRegex $SqlEnvRegex -SetSqlPassword:$SetSqlPassword

    if($ARMOnly -eq $false) {
        Register-AzureServiceBus -KeyVaultName $KeyVaultName -ResourceGroup $ResourceGroup -SbAccessRuleName $SbAccessRuleName -EnvironmentRegex $SbEnvRegex
    }
}
