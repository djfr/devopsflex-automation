---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# New-AzureSQLDbOwner

## SYNOPSIS
Generates a user/password pair for Azure SQL authentication and adds that user as a dbowner for the target database.

## SYNTAX

```
New-AzureSQLDbOwner [-SqlDbName] <String> [-SqlDbUser] <String> [-SqlDbPwd] <String> [-KeyVaultName] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Generes a user/password pair for Azure SQL authentication and adds that user as a dbowner for the target database.
It then uploads the generated pair to keyvault with relevant tags applied.

## EXAMPLES

### EXAMPLE 1
```
New-AzureSQLDbOwner -SqlDbName my-sql-db -SqlDbUser my-SqlSaUser -SqlDbPassword my-SqlSaPwd -KeyVaultName my-keyvault
```

Will generated a username/password pair and add is as a dbowner for my-sql-db database.
It will use my-SqlSaUser/my-SqlSaPwd
to create the new user, this needs to be an sa user with access to the master database.

## PARAMETERS

### -SqlDbName
The name of the Azure SQL database that we want to add the new dbowner user to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlDbUser
The Azure SQL username to use as login to create the generated user.
This user needs to be sa in the database.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlDbPwd
The Azure SQL password to use as login to create the generated user.
This user needs to be sa in the database.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyVaultName
The name of the keyvault where we are adding the generated username/password pair.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
