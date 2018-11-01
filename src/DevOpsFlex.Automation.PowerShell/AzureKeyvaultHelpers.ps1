class EswUser
{
    [string] $Username
    [securestring] $Password
}

# Taken from: https://gallery.technet.microsoft.com/scriptcenter/Generate-a-random-and-5c879ed5
function New-SWRandomPassword {
    <#
    .Synopsis
       Generates one or more complex passwords designed to fulfill the requirements for Active Directory
    .DESCRIPTION
       Generates one or more complex passwords designed to fulfill the requirements for Active Directory
    .EXAMPLE
       New-SWRandomPassword
       C&3SX6Kn

       Will generate one password with a length between 8  and 12 chars.
    .EXAMPLE
       New-SWRandomPassword -MinPasswordLength 8 -MaxPasswordLength 12 -Count 4
       7d&5cnaB
       !Bh776T"Fw
       9"C"RxKcY
       %mtM7#9LQ9h

       Will generate four passwords, each with a length of between 8 and 12 chars.
    .EXAMPLE
       New-SWRandomPassword -InputStrings abc, ABC, 123 -PasswordLength 4
       3ABa

       Generates a password with a length of 4 containing atleast one char from each InputString
    .EXAMPLE
       New-SWRandomPassword -InputStrings abc, ABC, 123 -PasswordLength 4 -FirstChar abcdefghijkmnpqrstuvwxyzABCEFGHJKLMNPQRSTUVWXYZ
       3ABa

       Generates a password with a length of 4 containing atleast one char from each InputString that will start with a letter from 
       the string specified with the parameter FirstChar
    .OUTPUTS
       [String]
    .NOTES
       Written by Simon Wåhlin, blog.simonw.se
       http://blog.simonw.se/powershell-generating-random-password-for-active-directory/
    .FUNCTIONALITY
       Generates random passwords
    .LINK
       
   
    #>

    [CmdletBinding(DefaultParameterSetName='FixedLength',ConfirmImpact='None')]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$false, ParameterSetName='RandomLength')]
        [ValidateScript({$_ -gt 0})]
        [Alias('Min')]
        [int]$MinPasswordLength = 8,
        
        [Parameter(Mandatory=$false, ParameterSetName='RandomLength')]
        [ValidateScript({
                if($_ -ge $MinPasswordLength){$true}
                else{Throw 'Max value cannot be lesser than min value.'}})]
        [Alias('Max')]
        [int]$MaxPasswordLength = 12,

        [Parameter(Mandatory=$false, ParameterSetName='FixedLength')]
        [ValidateRange(1,2147483647)]
        [int]$PasswordLength = 8,
        
        [String[]]$InputStrings = @('abcdefghijklmnopqrstuvwxyz', 'ABCEFGHIJKLMNOPQRSTUVWXYZ', '0123456789', '!£$%^&*(){}[]#_'),

        [String] $FirstChar,
        
        [ValidateRange(1,2147483647)]
        [int]$Count = 1
    )

    Begin {
        Function Get-Seed{
            # Generate a seed for randomization
            $RandomBytes = New-Object -TypeName 'System.Byte[]' 4
            $Random = New-Object -TypeName 'System.Security.Cryptography.RNGCryptoServiceProvider'
            $Random.GetBytes($RandomBytes)
            [BitConverter]::ToUInt32($RandomBytes, 0)
        }
    }

    Process {
        For($iteration = 1;$iteration -le $Count; $iteration++){
            $Password = @{}
            # Create char arrays containing groups of possible chars
            [char[][]]$CharGroups = $InputStrings

            # Create char array containing all chars
            $AllChars = $CharGroups | ForEach-Object {[Char[]]$_}

            # Set password length
            if($PSCmdlet.ParameterSetName -eq 'RandomLength')
            {
                if($MinPasswordLength -eq $MaxPasswordLength) {
                    # If password length is set, use set length
                    $PasswordLength = $MinPasswordLength
                }
                else {
                    # Otherwise randomize password length
                    $PasswordLength = ((Get-Seed) % ($MaxPasswordLength + 1 - $MinPasswordLength)) + $MinPasswordLength
                }
            }

            # If FirstChar is defined, randomize first char in password from that string.
            if($PSBoundParameters.ContainsKey('FirstChar')){
                $Password.Add(0,$FirstChar[((Get-Seed) % $FirstChar.Length)])
            }
            # Randomize one char from each group
            Foreach($Group in $CharGroups) {
                if($Password.Count -lt $PasswordLength) {
                    $Index = Get-Seed
                    While ($Password.ContainsKey($Index)){
                        $Index = Get-Seed                        
                    }
                    $Password.Add($Index,$Group[((Get-Seed) % $Group.Count)])
                }
            }

            # Fill out with chars from $AllChars
            for($i=$Password.Count;$i -lt $PasswordLength;$i++) {
                $Index = Get-Seed
                While ($Password.ContainsKey($Index)){
                    $Index = Get-Seed                        
                }
                $Password.Add($Index,$AllChars[((Get-Seed) % $AllChars.Count)])
            }
            Write-Output -InputObject $(-join ($Password.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value))
        }
    }
}

###########################################################
#       Add-MeToKeyvault
###########################################################

function Add-MeToKeyvault
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=0)]
        [string] $KeyvaultName
    )

    $userId = Get-MyUserObjectId
    Set-AzureRmKeyVaultAccessPolicy -VaultName $KeyvaultName -ObjectId $userId -PermissionsToKeys all -PermissionsToSecrets all
}


###########################################################
#       Add-UserToKeyVault
###########################################################

function Add-UserToKeyVault
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [parameter(Mandatory=$true, Position=0)]
        [string] $KeyvaultName,

        [parameter(Mandatory=$true, Position=1)]
        [string] $Username
    )

    $adUsers = Get-AzureRmADUser | where { $_.UserPrincipalName -match $Username }

    if($adUsers.Count -gt 1) {
        Write-Warning 'Found Multiple users using UserPrincipalName as the search query - Exiting ...'
        $adUsers |ft *
        return
    }
    elseif($adUsers.Count -eq 0) {
        Write-Warning 'Found no users using UserPrincipalName as the search query'

        $adUsers = Get-AzureRmADUser | where { $_.DisplayName -match $Username }

        if($adUsers.Count -gt 1) {
            Write-Warning 'Found Multiple users using DisplayName as the search query - Exiting ...'
            $adUsers |ft *
            return
        }

        if($adUsers.Count -eq 0) {
            Write-Warning 'Found no users using DisplayName as the search query - Exiting ...'
            return
        }
    }

    Write-Host '`nFound a user and adding him to Keyvault:'
    $adUsers |fl

    Set-AzureRmKeyVaultAccessPolicy -VaultName $KeyvaultName -ObjectId $adUsers[0].Id -PermissionsToKeys all -PermissionsToSecrets all > $null
}

function New-UserInKeyVault
{
<#
.Synopsis
    Generates a strong password for a Username and stores both the Username and Password in the specified KeyVault.

.DESCRIPTION
    Generates a strong password for a Username and stores both the Username and Password in the specified KeyVault.

.EXAMPLE
    New-UserInKeyVault -KeyvaultName 'mykeyvault' -Name 'myuser' -Username 'ausername' -Type 'VM'
    Will generate a password for the user 'ausername' for a VM and store it in a named pair in keyvault 'mykeyvault' named 'myuser'.

.FUNCTIONALITY
    Creates users stored in KeyVault for DevOps automation code for VMs, Service Fabric, SQL
#>

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=1)]
        [string] $KeyvaultName,

        [parameter(Mandatory=$true, Position=2)]
        [string] $Name,

        [parameter(Mandatory=$true, Position=3)]
        [string] $Username,

        [parameter(Mandatory=$false)]
        [validateset("VM", "Fabric", "SQL", "DB")]
        [string] $Type,

        [int] $MinPasswordLength = 15,
        [int] $MaxPasswordLength = 20
    )

    $password = New-SWRandomPassword -MinPasswordLength $MinPasswordLength -MaxPasswordLength $MaxPasswordLength -InputStrings @('abcdefghijklmnopqrstuvwxyz', 'ABCEFGHIJKLMNOPQRSTUVWXYZ', '0123456789', '#&%!')
    $tags = @{
                 ComponentName=$Name
                 Type='Username'
             }

    if($Type) { $tags += @{ ComponentType=$Type } }

    Set-AzureKeyVaultSecret -VaultName $KeyVaultName `
                            -Name "$Name-$Type-user".ToLower() `
                            -SecretValue (ConvertTo-SecureString $Username -AsPlainText -Force) `
                            -Tags $tags `
                            -Verbose > $null

    Set-AzureKeyVaultSecret -VaultName $KeyVaultName `
                            -Name "$Name-$Type-pwd".ToLower() `
                            -SecretValue (ConvertTo-SecureString $password -AsPlainText -Force) `
                            -Tags $tags `
                            -Verbose > $null

    Write-Information "Generated password for the account $Username : $password"
    Write-Output -InputObject $password
}

function Get-AadAuthFile
{
<#
.Synopsis
Gets the contents of the keyvault and maps it to an Azure auth settings file.

.DESCRIPTION
Gets the contents of the keyvault and maps it to an Azure auth settings file.
Overrides the current file if it already exists, which is the desired behaviour, since what's on keyvault is the final set of settings.

You need to be loged in azure with 'Login-AzAccount' and you need to have LIST and READ rights on secrets on the target key vault.

.PARAMETER KeyvaultName
The name of the source key vault.

.PARAMETER FileLocation
The file location (folder) where we are saving to.
Defaults to %LOCALAPPDATA%\Eshopworld

.PARAMETER FileName
The name of the file.
Defaults to developer.azureauth

.EXAMPLE
Get-AadAuthFile -KeyvaultName 'my-kv'
Maps the contents of the 'my-kv' keyvault to the file '%LOCALAPPDATA%\Eshopworld\developer.azureauth'.

.EXAMPLE
Get-AadAuthFile -KeyvaultName 'my-kv' -FileLocation 'C:\MyFolder' -FileName 'myfile.azureauth'
Maps the contents of the 'my-kv' keyvault to the file 'C:\MyFolder\myfile.azureauth'.
#>

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=1)]
        [string] $KeyvaultName,

        [parameter(Mandatory=$false)]
        [string] $FileLocation = "$($env:LOCALAPPDATA)\Eshopworld",

        [parameter(Mandatory=$false)]
        [string] $FileName = "developer.azureauth"
    )

    New-Item -ItemType Directory -Path $FileLocation -Force > $null
    $authPayload = @{}

    Get-AzureKeyVaultSecret -VaultName $KeyvaultName | % {
        $secret = Get-AzureKeyVaultSecret -VaultName $KeyvaultName -Name $_.Name
        $authPayload.Add($secret.Name, $secret.SecretValueText)
    }

    Set-Content -Value ($authPayload | ConvertTo-Json) -Path (Join-Path $FileLocation $FileName) > $null
}
