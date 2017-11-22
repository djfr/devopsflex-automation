$env = "test"
$regex = "(sierra)"
$rg = "naughty-dog"
$vaultName = "test-vault"
$sqlPass = "#testing1234"
$kvKeyName = "sqlkvtest"

Remove-Module -Name DevOpsFlex.Automation.PowerShell -ErrorAction SilentlyContinue -Verbose
Import-Module $PSScriptRoot\..\DevOpsFlex.Automation.PowerShell.psd1 -Force -Verbose

#Register-AzureServiceBusInKeyVault -KeyVaultName $vaultName -Environment $env -Regex $regex

#Register-AzureSqlDatabaseInKeyVault -KeyVaultName $vaultName -ResourceGroup $rg -Environment $env -Regex $regex -SqlSaPassword $sqlPass -ConfigurationKeyVaultName $kvKeyName

Register-AzureCosmosDBInKeyVault -KeyVaultName $vaultName -ResourceGroup $rg -Environment $env -Regex $regex

#Register-AzureRedisCacheInKeyVault -KeyVaultName $vaultName -ResourceGroup $rg -Environment $env -Regex $regex