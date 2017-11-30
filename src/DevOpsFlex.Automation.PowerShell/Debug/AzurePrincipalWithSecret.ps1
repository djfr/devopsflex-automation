$vaultSubscriptionId = '[ID HERE]'

Remove-Module -Name DevOpsFlex.Automation.PowerShell -ErrorAction SilentlyContinue -Verbose
Import-Module $PSScriptRoot\..\DevOpsFlex.Automation.PowerShell.psd1 -Force -Verbose

$azureAdApplication = New-AzurePrincipalWithSecret -SystemName 'sys1' `
                                                   -PrincipalPurpose 'Authentication' `
                                                   -EnvironmentName 'test' `
                                                   -PrincipalPassword 'something123$' `
                                                   -VaultSubscriptionId $vaultSubscriptionId `
                                                   -PrincipalName 'test'

$azureAdApplication | Remove-AzurePrincipalWithSecret -VaultSubscriptionId $vaultSubscriptionId
#Remove-AzurePrincipalWithSecret -ADApplicationId '[ID HERE]' -VaultSubscriptionId $vaultSubscriptionId
