$vaultName = 'devmarket-dev'
$sqlPassword = 'djfrpwd456#'

Remove-Module -Name DevOpsFlex.Automation.PowerShell -ErrorAction SilentlyContinue -Verbose
Import-Module $PSScriptRoot\..\DevOpsFlex.Automation.PowerShell.psd1 -Force -Verbose

Register-AzureSubscriptionInKeyVault -KeyVaultName $vaultName `
                                     -KeyType 'Primary' `
                                     -SqlPassword $sqlPassword
