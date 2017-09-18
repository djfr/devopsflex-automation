function New-AzureSQLDbOwner
{
<#

.SYNOPSIS
Generates a user/password pair for Azure SQL authentication and adds that user as a dbowner for the target database.

.DESCRIPTION
Generes a user/password pair for Azure SQL authentication and adds that user as a dbowner for the target database.
It then uploads the generated pair to keyvault with relevant tags applied.

.PARAMETER SqlDbName
The name of the Azure SQL database that we want to add the new dbowner user to.

.PARAMETER SqlDbUser
The Azure SQL username to use as login to create the generated user.
This user needs to be sa in the database.

.PARAMETER SqlDbPwd
The Azure SQL password to use as login to create the generated user.
This user needs to be sa in the database.

.PARAMETER KeyVaultName
The name of the keyvault where we are adding the generated username/password pair.

.EXAMPLE
New-AzureSQLDbOwner -SqlDbName my-sql-db -SqlDbUser my-SqlSaUser -SqlDbPassword my-SqlSaPwd -KeyVaultName my-keyvault
Will generated a username/password pair and add is as a dbowner for my-sql-db database. It will use my-SqlSaUser/my-SqlSaPwd
to create the new user, this needs to be an sa user with access to the master database.

.FUNCTIONALITY
Generates Azure SQL dbowner users.
   
#>

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
