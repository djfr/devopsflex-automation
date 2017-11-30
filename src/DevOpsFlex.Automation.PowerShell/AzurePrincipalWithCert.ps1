[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "", Scope="Function", Target="*")]
param()

function Set-KeyVaultCertSecret
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true)]
        [string] $CertFolderPath,

        [parameter(Mandatory=$true)]
        [string] $CertPassword,

        [parameter(Mandatory=$true)]
        [string] $SecretName,

        [parameter(Mandatory=$true)]
        [string] $VaultName
    )

    $collection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
    $collection.Import($CertFolderPath, $CertPassword, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)

    $clearBytes = $collection.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12)
    $fileContentEncoded = [System.Convert]::ToBase64String($clearBytes)

    $secret = ConvertTo-SecureString -String $fileContentEncoded -AsPlainText –Force
    $secretContentType = 'application/x-pkcs12'

    Set-AzureKeyVaultSecret -VaultName $VaultName -Name $SecretName -SecretValue $secret -ContentType $secretContentType -Verbose
}

###########################################################
#       New-AzurePrincipalWithCert
###########################################################

function New-AzurePrincipalWithCert
{
<#
.SYNOPSIS
Adds AzureRM Active Directory Application and persists a cert to Key Vault for it.

.DESCRIPTION
1. Creates a new Azure Active Directory Application
2. Creates a new cert in Azure Key Vault for the AAD Application.

.PARAMETER SystemName 
The system the application is for.

.PARAMETER PrincipalPurpose
The purpose of the principal Authentication or Configuration.

.PARAMETER EnvironmentName
The environment the application is for.

.PARAMETER CertFolderPath
Local path to where the cert will be created.

.PARAMETER CertPassword
The password for the cert.

.PARAMETER VaultSubscriptionId
The subscription Id that Key Vault is on.

.PARAMETER PrincipalName
The name of the Key Vault principal.

.EXAMPLE
New-AzurePrincipalWithCert -SystemName 'sys1' `
                           -PrincipalPurpose 'Authentication' `
                           -EnvironmentName 'test' `
                           -CertFolderPath 'C:\Certificates' `
                           -CertPassword 'something123$' `
                           -VaultSubscriptionId '[ID HERE]' `
                           -PrincipalName 'Keyvault'

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

        [parameter(Mandatory=$true, Position=3)]
        [string] $CertFolderPath,

        [parameter(Mandatory=$true, Position=4)]
        [string] $CertPassword,

        [parameter(Mandatory=$false, Position=5)]
        [string] $VaultSubscriptionId,

        [parameter(Mandatory=$false, Position=6)]
        [string] $PrincipalName
    )

    # GUARD: There are no non letter characters on the Cert Name
    if(-not [string]::IsNullOrWhiteSpace($PrincipalName) -and -not ($PrincipalName -match "^([A-Za-z])*$")) {
        throw 'The CertName must be letters only, either lower and upper case. Cannot contain any digits or any non-alpha-numeric characters.'
    }

    # Uniform all the namings
    if([string]::IsNullOrWhiteSpace($PrincipalName)) {
        $principalIdDashed = "$($SystemName)-$($PrincipalPurpose)".ToLower()
        $principalIdDotted = "$($SystemName).$($PrincipalPurpose)".ToLower()
        $identifierUri = "https://$($SystemName).$($PrincipalPurpose).$($EnvironmentName)".ToLower()
    }
    else {
        $principalIdDashed = "$($SystemName)-$($PrincipalPurpose)-$($PrincipalName)".ToLower()
        $principalIdDotted = "$($SystemName).$($PrincipalPurpose).$($PrincipalName)".ToLower()
        $identifierUri = "https://$($SystemName).$($PrincipalPurpose).$($EnvironmentName).$($PrincipalName)".ToLower()
    }

    # GUARD: AD application already exists, return the existing ad application
    $adApplication = Get-AzureRmADApplication -DisplayNameStartWith $principalIdDotted
    if($adApplication -ne $null) {
        Write-Warning 'An AD Application Already exists that looks identical to what you are trying to create'
        return $adApplication
    }

    # GUARD: Certificate system vault exists
    $systemVaultName = "$($SystemName)-$($EnvironmentName)".ToLower()
    if((Get-AzureRmKeyVault -VaultName $systemVaultName) -eq $null) {
        throw "The system vault $systemVaultName doesn't exist in the current subscription. Create it before running this cmdlet!"
    }

    # Create the self signed cert
    $currentDate = Get-Date
    $endDate = $currentDate.AddYears(1)
    $notAfter = $endDate.AddYears(1)

    if($CertFolderPath.EndsWith("\") -eq $false) {
        $CertFolderPath = $CertFolderPath + "\"
    }

    $cert = New-SelfSignedCertificate -CertStoreLocation cert:\localmachine\my `
                                      -DnsName $principalIdDotted `
                                      -KeyExportPolicy Exportable `
                                      -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" `
                                      -NotAfter $notAfter `
                                      -NotBefore $currentDate `
                                      -ErrorAction Stop                                      

    $pwd = ConvertTo-SecureString -String $CertPassword -Force -AsPlainText
    $certPath = "$CertFolderPath$SystemName-$EnvironmentName.pfx"
    $null = Export-PfxCertificate -cert "cert:\localmachine\my\$($cert.Thumbprint)" -FilePath $certPath -Password $pwd -ErrorAction Stop

    # Load the certificate
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certPath, $pwd)
    $KeyValue = [System.Convert]::ToBase64String($cert.GetRawCertData())

    # Aquire the tenant ID on the subscription we are creating the principal on, not on the vault subscription!
    $tenantId = (Get-AzureRmContext).Subscription.TenantId

    # Create the Azure Active Directory Application
    $azureAdApplication = New-AzureRmADApplication -DisplayName $principalIdDotted `
                                                   -HomePage $identifierUri `
                                                   -IdentifierUris $identifierUri `
                                                   -Verbose

    # Create a new Azure Active Directory Application Credential and link it to the previously created Application
    New-AzureRmADAppCredential -ApplicationId $azureAdApplication.ApplicationId -StartDate $cert.NotBefore -EndDate $cert.NotAfter -CertValue ([System.Convert]::ToBase64String($cert.GetRawCertData()))

    Write-Host -ForegroundColor Green  "Application ID: $($azureAdApplication.ApplicationId)"

    # Create the Service Principal and connect it to the Application
    $null = New-AzureRmADServicePrincipal -ApplicationId $azureAdApplication.ApplicationId

    # Switch to the KeyVault Techops-Management subscription
    $currentSubId = (Get-AzureRmContext).Subscription.SubscriptionId
    if(($VaultSubscriptionId -ne $null) -and ($currentSubId -ne $VaultSubscriptionId)) {
        Select-AzureRmSubscription -SubscriptionId $VaultSubscriptionId -ErrorAction Stop
    }

    # Upload the cert and cert passwords to the right keyvaults
    $null = Set-KeyVaultCertSecret -VaultName $systemVaultName -CertFolderPath $certPath -CertPassword $CertPassword -SecretName "$principalIdDashed-Cert"
    $null = Set-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$principalIdDashed-CertPwd" -SecretValue (ConvertTo-SecureString -String $CertPassword -AsPlainText –Force)

    # Populate the system keyvault with all relevant principal configuration information
    $null = Set-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$principalIdDashed-TenantId" -SecretValue (ConvertTo-SecureString -String $tenantId -AsPlainText –Force)
    $null = Set-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$principalIdDashed-IdentifierUri" -SecretValue (ConvertTo-SecureString -String $identifierUri -AsPlainText –Force)
    $null = Set-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$principalIdDashed-ApplicationId" -SecretValue (ConvertTo-SecureString -String $($azureAdApplication.ApplicationId) -AsPlainText –Force)

    # Swap back to the subscription the user was in
    if(($VaultSubscriptionId -ne $null) -and ($currentSubId -ne $VaultSubscriptionId)) {
        Select-AzureRmSubscription -SubscriptionId $currentSubId | Out-Null
    }

    return $azureAdApplication
}

###########################################################
#       Remove-AzurePrincipalWithCert
###########################################################

function Remove-AzurePrincipalWithCert
{
<#
.SYNOPSIS
Removes the Azure Active Directory Application, Principal and the cert stored for it.

.DESCRIPTION
Removes the Azure Active Directory Application, Principal and the cert stored for it.

.PARAMETER ADApplicationId 
The Id of the Azure Active Directory Application you with to remove.

.PARAMETER ADApplication
The Azure Active Directory Application you with to remove.

.PARAMETER VaultSubscriptionId
The subscription Id that Key Vault is on.

.EXAMPLE
Remove-AzurePrincipalWithCert -ADApplicationId '[ID HERE]' -VaultSubscriptionId '[ID HERE]'

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

        [parameter(Mandatory=$false, Position=2)]
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
        $dashName = "$systemName-$principalPurpose"
        $dotName = "$systemName.$principalPurpose"
    }
    else {
        $dashName = "$systemName-$principalPurpose-$principalName"
        $dotName = "$systemName.$principalPurpose.$principalName"
    }

    # Switch to the KeyVault Techops-Management subscription
    $currentSubId = (Get-AzureRmContext).Subscription.SubscriptionId
    if(($VaultSubscriptionId -ne $null) -and ($currentSubId -ne $VaultSubscriptionId)) {
        Select-AzureRmSubscription -SubscriptionId $VaultSubscriptionId -ErrorAction Stop
    }

    $systemVaultName = "$($systemName)-$($environmentName)".ToLower()

    # Remove the cert and cert password from the system keyvault
    Remove-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$dashName-Cert" -Force -Confirm:$false
    Remove-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$dashName-CertPwd" -Force -Confirm:$false

    # Remove the principal configuration information from the system keyvault
    Remove-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$dashName-TenantId" -Force -Confirm:$false
    Remove-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$dashName-IdentifierUri" -Force -Confirm:$false
    Remove-AzureKeyVaultSecret -VaultName $systemVaultName -Name "$dashName-ApplicationId" -Force -Confirm:$false

    # Swap back to the subscription the user was in
    if(($VaultSubscriptionId -ne $null) -and ($currentSubId -ne $VaultSubscriptionId)) {
        Select-AzureRmSubscription -SubscriptionId $currentSubId | Out-Null
    }

    # Remove the AD Service Principal
    $servicePrincipal = Get-AzureRmADServicePrincipal -SearchString $dotName -ErrorAction SilentlyContinue
    if($servicePrincipal) {
        Remove-AzureRmADServicePrincipal -ObjectId $servicePrincipal.Id -Force
    }
    else {
        Write-Warning "Couldn't find any Service Principal using the search string [$dotName]"
    }

    # Remove the AD Application
    $adApplication = Get-AzureRmADApplication -DisplayNameStartWith $dotName -ErrorAction SilentlyContinue
    if($adApplication) {
        Remove-AzureRmADApplication -ObjectId $adApplication.ObjectId -Force
    }
}
