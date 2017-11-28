$vaultSubscriptionId = '[ID HERE]'

Remove-Module -Name DevOpsFlex.Automation.PowerShell -ErrorAction SilentlyContinue -Verbose
Import-Module $PSScriptRoot\..\DevOpsFlex.Automation.PowerShell.psd1 -Force -Verbose

$azureAdApplication = New-AzurePrincipalWithCert -SystemName 'sys1' `
                                                 -PrincipalPurpose 'Authentication' `
                                                 -EnvironmentName 'test' `
                                                 -CertFolderPath 'C:\Certificates' `
                                                 -CertPassword 'something123$' `
                                                 -VaultSubscriptionId $vaultSubscriptionId `
                                                 -PrincipalName 'Keyvault'

$azureAdApplication | Remove-AzurePrincipalWithCert -VaultSubscriptionId $vaultSubscriptionId
#Remove-AzurePrincipalWithCert -ADApplicationId '[ID HERE]' -VaultSubscriptionId $vaultSubscriptionId