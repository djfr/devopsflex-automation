function Register-AzureServiceBus
{
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$false)]
        [string] $EnvironmentFilter,

        [parameter(Mandatory=$false)]
        [string] $SbAccessRuleName,

        [parameter(Mandatory=$false)]
        [string] $Regex
    )

    Get-AzureSBNamespace | foreach { Get-AzureSBAuthorizationRule -Namespace $_.Name } | where { $_.Name -eq 'RootManageSharedAccessKey' } | foreach {
        if(($EnvironmentFilter -ne $null) -and ($_.Namespace -notmatch $Regex)) { continue }

        $keyName = $_.Namespace -replace $EnvironmentRegex, ''
        $null = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $keyName -SecretValue (ConvertTo-SecureString -String $_.ConnectionString -AsPlainText –Force)
    }
}

function Register-AzureSqlDatabase
{
    param(
        [parameter(Mandatory=$true)]
        [string] $KeyVaultName,

        [parameter(Mandatory=$false)]
        [string] $ResourceGroup,

        [parameter(Mandatory=$false)]
        [string] $Environment,

        [parameter(Mandatory=$false)]
        [string] $Regex,

        [parameter(Mandatory=$true, ParameterSetName='SaUser')]
        [string] $SqlSaPassword,

        [parameter(Mandatory=$true, ParameterSetName='KeyVaultUser')]
        [string] $ConfigurationKeyVaultName
    )

    if($ResourceGroup -eq $null) {
        $dbs = Get-AzureRmSqlServer | Get-AzureRmSqlDatabase | where { $_.DatabaseName -ne 'master' }
    }
    else {
        $dbs = Get-AzureRmResourceGroup -Name $ResourceGroup | Get-AzureRmSqlServer | Get-AzureRmSqlDatabase | where { $_.DatabaseName -ne 'master' }
    }

    $dbs | % {
        if(($Environment -eq $null) -or ($_.DatabaseName -match "-$Environment`$")) {
            if(($Regex -eq $null) -or ($_.DatabaseName -match "$Regex")) {
                $server = $_ | Get-AzureRmSqlServer

                if($SqlSaPassword -ne $null) {
                    $sqlUser = $server.SqlAdministratorLogin
                    $sqlPwd = $SqlSaPassword
                }
                else {
                    $userKey = "$($_.DatabaseName.Replace('-', ''))user"
                    $pwdKey = "$userKey-pwd"

                    $sqlUser = (Get-AzureKeyVaultSecret -VaultName $ConfigurationKeyVaultName -Name $userKey).SecretValueText
                    $sqlPwd = (Get-AzureKeyVaultSecret -VaultName $ConfigurationKeyVaultName -Name $pwdKey).SecretValueText
                }

                $connectionString = "Server=tcp:$($server.ServerName).database.windows.net; Database=$($_.DatabaseName); User ID=$sqlUser@$($server.ServerName); Password=$sqlPwd; Trusted_Connection=False; Encrypt=True; MultipleActiveResultSets=True;"
                $connectionString

                $null = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name 'SQLConnectionString' -SecretValue (ConvertTo-SecureString -String $connectionString -AsPlainText –Force)
            }
        }
    }
}
