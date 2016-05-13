#
# AzureSubscriptionInKeyVault.psm1
#

### Scans both ASM and ARM storage accounts and pushes all relevant keys to KeyVault
function Scan-AzureStorage
{
    param()
    {
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$true)]
        [ValidateSet('Primary','Secondary')]
        [string] $KeyType
    }

    Get-AzureStorageAccount | Get-AzureStorageKey | foreach {
        $void = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $_.StorageAccountName -SecretValue (ConvertTo-SecureString -String $_.$KeyType -AsPlainText –Force)
    }

    switch($KeyType)
    {
        "Primary" {$keyIndex = 0}
        "Secondary" {$keyIndex = 1}
        default {$keyIndex = 0}
    }

    Get-AzureRmStorageAccount | select StorageAccountName, @{Name="Key";Expression={(Get-AzureRmStorageAccountKey -ResourceGroupName $_.ResourceGroupName -Name $_.StorageAccountName)[$index].Value}} | foreach {
        $void = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $_.StorageAccountName -SecretValue (ConvertTo-SecureString -String $_.Key -AsPlainText –Force)
    }
}

function Scan-AzureServiceBus
{
    param()
    {
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$false)]
        [string] $SbAccessRuleName = 'RootManageSharedAccessKey'
    }

    Get-AzureSBNamespace | foreach { Get-AzureSBAuthorizationRule -Namespace $_.Name } | where { $_.Name -eq 'RootManageSharedAccessKey' } | foreach {
        $void = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $_.Namespace -SecretValue (ConvertTo-SecureString -String $_.ConnectionString -AsPlainText –Force)
    }
}

function Scan-AzureSqlDatabase
{
    param()
    {
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName
    }

}

funtion Register-AzureSubscriptionInKeyVault
{
    param()
    {
        [parameter(Mandatory=$true, Position=0)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$true, Position=1)]
        [ValidateSet('Primary','Secondary')]
        [string] $KeyType,

        [parameter(Mandatory=$false)]
        [string] $SbAccessRuleName = 'RootManageSharedAccessKey'
    }

    Scan-AzureStorage -KeyVaultName $KeyVaultName -KeyType $KeyType
    Scan-AzureServiceBus -KeyVaultName $KeyVaultName -SbAccessRuleName $SbAccessRuleName
}