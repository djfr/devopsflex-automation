#
# AzureSubscriptionInKeyVault.psm1
#

### Scans both ASM and ARM storage accounts and pushes all relevant keys to KeyVault
function Scan-AzureStorage
{
    param()
    {
        [parameter(Mandatory=$true)]
        [ValidateSet('Primary','Secondary')]
        [string] $KeyType

        [parameter(Mandatory=$true)]
        [string] $KeyVaultName
    }

    Get-AzureStorageAccount | Get-AzureStorageKey | foreach {
        Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $_.StorageAccountName -SecretValue (ConvertTo-SecureString -String $_.$KeyType -AsPlainText –Force)
    }

    switch($KeyType)
    {
        "Primary" {$keyIndex = 0}
        "Secondary" {$keyIndex = 1}
        default {$keyIndex = 0}
    }

    Get-AzureRmStorageAccount | select StorageAccountName, @{Name="Key";Expression={(Get-AzureRmStorageAccountKey -ResourceGroupName $_.ResourceGroupName -Name $_.StorageAccountName)[$index].Value}} | foreach {
        Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $_.StorageAccountName -SecretValue (ConvertTo-SecureString -String $_.Key -AsPlainText –Force)
    }
}

function Scan-AzureServiceBus
{
    param()
    {
        [parameter(Mandatory=$true)]
        [ValidateSet('Primary','Secondary')]
        [string] $KeyType,

        [parameter(Mandatory=$true)]
        [string] $KeyVaultName
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
        [ValidateSet('Primary','Secondary')]
        [string] $KeyType,

        [parameter(Mandatory=$true, Position=1)]
        [string] $KeyVaultName
    }


}