﻿[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "", Scope="Function", Target="*")]
param()

###########################################################
#       New-AzurePrincipalWithSecret
###########################################################

function New-AzurePrincipalWithSecret
{
<#
.SYNOPSIS
Adds AzureRM Active Directory Application and persists secrets to Key Vault for it.

.DESCRIPTION
1. Creates a new Azure Active Directory Application
2. Creates new secrets in Azure Key Vault for the AAD Application, namely the TenantId, IdentifierUri, ApplicationId and Application Secret

.PARAMETER SystemName 
The system the application is for.

.PARAMETER PrincipalPurpose
The purpose of the principal Authentication or Configuration.

.PARAMETER EnvironmentName
The environment the application is for.

.PARAMETER PrincipalPassword
The password for the principal.

.PARAMETER VaultSubscriptionId
The subscription Id that Key Vault is on.

.PARAMETER PrincipalName
The name of the Key Vault principal.

.EXAMPLE
New-AzurePrincipalWithSecret -SystemName 'sys1' `
                             -PrincipalPurpose 'Authentication' `
                             -EnvironmentName 'test' `
                             -PrincipalPassword 'something123$' `
                             -VaultSubscriptionId '[ID HERE]' `
                             -PrincipalName 'test'
.NOTES
Currently CmdletBinding doesn't have any internal support built-in.
#>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=0)]
        [string] $SystemName,

        [parameter(Mandatory=$true, Position=1)]
        [ValidateSet('Configuration','Authentication')]
        [string] $PrincipalPurpose,

        [parameter(Mandatory=$true, Position=2)]
        [string] $EnvironmentName,

        [parameter(Mandatory=$true, Position=4)]
        [string] $PrincipalPassword,

        [parameter(Mandatory=$false, Position=5)]
        [string] $VaultSubscriptionId,

        [parameter(Mandatory=$false, Position=6)]
        [string] $PrincipalName
    )

    # GUARD: There are no non letter characters on the Principal Name
    if(-not [string]::IsNullOrWhiteSpace($PrincipalName) -and -not ($PrincipalName -match "^([A-Za-z])*$")) {
        throw 'The PrincipalName must be letters only, either lower and upper case. Cannot contain any digits or any non-alpha-numeric characters.'
    }

    # Uniform all the namings
    if([string]::IsNullOrWhiteSpace($PrincipalName)) {
        $principalIdDashed = "$($SystemName)-$($PrincipalPurpose)".ToLower()
        $principalIdDotted = "$($SystemName).$($PrincipalPurpose)".ToLower()
        $identifierUri = "https://$($SystemName).$($PrincipalPurpose).$($EnvironmentName)".ToLower()
    }
    else {
        $principalIdDashed = "$($SystemName)-$($PrincipalPurpose)-$($PrincipalName)".ToLower()
        $principalIdDotted = "$($SystemName).$($PrincipalPurpose).$($PrincipalName.ToLower())"
        $identifierUri = "https://$($SystemName).$($PrincipalPurpose).$($EnvironmentName).$($PrincipalName)".ToLower()
    }

    # GUARD: AD application already exists, return the existing ad application
    $previousApplication = Get-AzureRmADApplication -DisplayNameStartWith $principalIdDotted
    if($previousApplication -ne $null) {
        Write-Warning 'An AD Application Already exists that looks identical to what you are trying to create'
        return $previousApplication
    }

    # GUARD: Certificate system vault exists
    $systemVaultName = "$($SystemName)-$($EnvironmentName)".ToLower()
    if((Get-AzureRmKeyVault -VaultName $systemVaultName) -eq $null) {
        throw "The system vault $systemVaultName doesn't exist in the current subscription. Create it before running this cmdlet!"
    }

    # Aquire the tenant ID on the subscription we are creating the principal on, not on the vault subscription!
    $tenantId = (Get-AzureRmContext).Subscription.TenantId

    # Create the Azure Active Directory Application
    $azureAdApplication = New-AzureRmADApplication -DisplayName $principalIdDotted `
                                                   -HomePage $identifierUri `
                                                   -IdentifierUris $identifierUri `
                                                   -Password $PrincipalPassword `
                                                   -Verbose

    Write-Host -ForegroundColor Green  "Application ID: $($azureAdApplication.ApplicationId)"

    # Create the Service Principal and connect it to the Application
    $null = New-AzureRmADServicePrincipal -ApplicationId $azureAdApplication.ApplicationId

    # Switch to the KeyVault Techops-Management subscription
    $currentSubId = (Get-AzureRmContext).Subscription.SubscriptionId
    if(($VaultSubscriptionId -ne $null) -and ($currentSubId -ne $VaultSubscriptionId)) {
        Select-AzureRmSubscription -SubscriptionId $VaultSubscriptionId -ErrorAction Stop
    }

    # Populate the system keyvault with all relevant principal configuration information
    $null = Set-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$principalIdDashed-TenantId" -SecretValue (ConvertTo-SecureString -String $tenantId -AsPlainText –Force)
    $null = Set-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$principalIdDashed-IdentifierUri" -SecretValue (ConvertTo-SecureString -String $identifierUri -AsPlainText –Force)
    $null = Set-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$principalIdDashed-ApplicationId" -SecretValue (ConvertTo-SecureString -String $($azureAdApplication.ApplicationId) -AsPlainText –Force)
    $null = Set-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$principalIdDashed-ApplicationSecret" -SecretValue (ConvertTo-SecureString -String $PrincipalPassword -AsPlainText –Force)

    # Swap back to the subscription the user was in
    if(($VaultSubscriptionId -ne $null) -and ($currentSubId -ne $VaultSubscriptionId)) {
        Select-AzureRmSubscription -SubscriptionId $currentSubId | Out-Null
    }

    return $azureAdApplication
}

###########################################################
#       Remove-AzurePrincipalWithSecret
###########################################################

function Remove-AzurePrincipalWithSecret
{
<#
.SYNOPSIS
Removes the Azure Active Directory Application, Principal and any secrets stored for it.

.DESCRIPTION
Removes the Azure Active Directory Application, Principal and any secrets stored for it.

.PARAMETER ADApplicationId 
The Id of the Azure Active Directory Application you with to remove.

.PARAMETER ADApplication
The Azure Active Directory Application you with to remove.

.PARAMETER VaultSubscriptionId
The subscription Id that Key Vault is on.

.EXAMPLE
Remove-AzurePrincipalWithSecret -ADApplicationId '[ID HERE]' -VaultSubscriptionId '[ID HERE]'

.NOTES
Currently CmdletBinding doesn't have any internal support built-in.
#>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$false, Position=0)]
        [string] $ADApplicationId,

        [parameter(
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=1)]
        [object] $ADApplication,

        [parameter(Mandatory=$true, Position=2)]
        [string] $VaultSubscriptionId
    )

    # GUARD: At least one parameter is supplied
    if((-not $ADApplicationId) -and (-not $ADApplication)) {
        throw 'You must either supply the PSADApplication object in the pipeline or the ApplicationID guid.'
    }

    if(-not $ADApplication) {
        $adApp = Get-AzureRmADApplication -ApplicationId $ADApplicationId

        # GUARD: If ADApplicationId is supplied, make sure it's a valid one that really exists
        if(-not $adApp) {
            throw "The specified ADApplicationID [$ADApplicationId] doesn't exist"
        }

        $identifierUri = $adApp.IdentifierUris[0]
    }
    else {
        $identifierUri = $ADApplication.IdentifierUris[0]
    }

    # Break the Identifier URI of the AD Application into it's individual components so that we can infer everything else.
    if(-not ($identifierUri -match 'https:\/\/(?<system>[^.]*).(?<purpose>[^.]*).(?<environment>[^.]*).(?<principalName>[^.]*)')) {
        throw "Can't infer the correct system information from the identifier URI [$identifierUri] in the AD Application, was this service principal created with this Module?"
    }

    $systemName = $Matches['system']
    $principalPurpose = $Matches['purpose']
    $environmentName = $Matches['environment']
    $principalName = $Matches['principalName']

    # Uniform all the namings
    if([string]::IsNullOrWhiteSpace($principalName)) {
        $dashName = "$systemName-$principalName"
        $dotName = "$systemName.$principalName"
    }
    else {
        $dashName = "$systemName-$principalPurpose-$principalName"
        $dotName = "$systemName.$principalPurpose.$principalName"
    }

    # Switch to the KeyVault Techops-Management subscription
    $currentSubId = (Get-AzureRmContext).Subscription.SubscriptionId
    if($currentSubId -ne $VaultSubscriptionId) {
        Select-AzureRmSubscription -SubscriptionId $VaultSubscriptionId -ErrorAction Stop
    }

    $systemVaultName = "$($systemName)-$($environmentName)".ToLower() 

    # 1. Remove the principal configuration information from the system keyvault
    Remove-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$dashName-TenantId" -Force -Confirm:$false
    Remove-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$dashName-IdentifierUri" -Force -Confirm:$false
    Remove-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$dashName-ApplicationId" -Force -Confirm:$false
    Remove-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$dashName-ApplicationSecret" -Force -Confirm:$false

    # Swap back to the subscription the user was in
    if($currentSubId -ne $VaultSubscriptionId) {
        Select-AzureRmSubscription -SubscriptionId $currentSubId | Out-Null
    }

    # 2. Remove the AD Service Principal
    $servicePrincipal = Get-AzureRmADServicePrincipal -SearchString $dotName -ErrorAction SilentlyContinue
    if($servicePrincipal) {
        Remove-AzureRmADServicePrincipal -ObjectId $servicePrincipal.Id -Force
    }
    else {
        Write-Warning "Couldn't find any Service Principal using the search string [$dotName]"
    }

    # 3. Remove the AD Application
    $adApplication = Get-AzureRmADApplication -DisplayNameStartWith $dotName -ErrorAction SilentlyContinue
    if($adApplication) {
        Remove-AzureRmADApplication -ObjectId $adApplication.ObjectId -Force
    }
}
