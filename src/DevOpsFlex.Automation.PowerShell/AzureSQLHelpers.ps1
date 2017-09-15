function New-AzureSQLDbOwner
{
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, Position = 1)]
        [string] $SqlDbName,

        [parameter(Mandatory = $true, Position = 2)]
        [string] $SqlDbUser,

        [parameter(Mandatory = $true, Position = 3)]
        [string] $SqlDbPwd,

        [parameter(Mandatory = $true, Position = 4)]
        [string] $KeyVaultName
    )

    $newSqlUser = "$($SqlDbName.Replace('-', ''))user"
    $newSqlPwd = New-SWRandomPassword -MinPasswordLength 12 -MaxPasswordLength 20
    $db = $null

    (Get-AzureRmSqlServer) | % {
        if(-not $db) {
            $dbs = Get-AzureRmSqlDatabase -ServerName $_.ServerName -ResourceGroupName $_.ResourceGroupName | ? { $_.DatabaseName -eq $SqlDbName }
            if($dbs.Count -gt 0) {
                $db = $dbs[0]
            }
        }
    }

    if(-not $db) {
        throw "Couldn't find a database named $SqlDbName in the current subscription."
    }

    $sqlServer = Get-AzureRmSqlServer -ServerName $db.ServerName -ResourceGroupName $db.ResourceGroupName

    Invoke-Sqlcmd -ServerInstance "$($sqlServer.ServerName).database.windows.net" -Database "master" -Username $SqlDbUser -Password $SqlDbPwd `
                  -Query "CREATE LOGIN $newSqlUser WITH password='$newSqlPwd';" `
                  -OutputSqlErrors $true -Verbose

    Invoke-Sqlcmd -ServerInstance "$($sqlServer.ServerName).database.windows.net" -Database $SqlDbName -Username $SqlDbUser -Password $SqlDbPwd `
                  -Query "CREATE USER $newSqlUser FROM LOGIN $newSqlUser WITH DEFAULT_SCHEMA = dbo;" `
                  -OutputSqlErrors $true -Verbose

    Invoke-Sqlcmd -ServerInstance "$($sqlServer.ServerName).database.windows.net" -Database $SqlDbName -Username $SqlDbUser -Password $SqlDbPwd `
                  -Query "EXEC sp_addrolemember N'db_owner', N'$newSqlUser';" `
                  -OutputSqlErrors $true -Verbose

    Set-AzureKeyVaultSecret -VaultName $KeyVaultName `
                            -Name "$newSqlUser" `
                            -SecretValue (ConvertTo-SecureString $newSqlUser -AsPlainText -Force) `
                            -Tags @{
                                resourceGroup=$db.ResourceGroupName
                                componentType='database'
                                componentName=$SqlDbName
                                secretType='User'
                            } `
                            -Verbose

    Set-AzureKeyVaultSecret -VaultName $KeyVaultName `
                            -Name "$newSqlUser-pwd" `
                            -SecretValue (ConvertTo-SecureString $newSqlPwd -AsPlainText -Force) `
                            -Tags @{
                                resourceGroup=$db.ResourceGroupName
                                componentType='database'
                                componentName=$SqlDbName
                                secretType='Password'
                            } `
                            -Verbose
}
