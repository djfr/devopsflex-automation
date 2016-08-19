$vaultSubscriptionId = '[ID HERE]'

Remove-Module -Name DevOpsFlex.Automation.PowerShell -ErrorAction SilentlyContinue -Verbose
Import-Module $PSScriptRoot\..\DevOpsFlex.Automation.PowerShell.psd1 -Force -Verbose

$azureAdApplication = New-AzurePrincipalWithSecret -SystemName 'djfr' `
                                                   -PrincipalPurpose 'Authentication' `
                                                   -EnvironmentName 'test' `
                                                   -PrincipalPassword 'djfrpwd' `
                                                   -VaultSubscriptionId $vaultSubscriptionId `
                                                   -PrincipalName 'Keyvault'

$azureAdApplication | Remove-AzurePrincipalWithSecret -VaultSubscriptionId $vaultSubscriptionId
#Remove-AzurePrincipalWithSecret -ADApplicationId '[ID HERE]' -VaultSubscriptionId $vaultSubscriptionId