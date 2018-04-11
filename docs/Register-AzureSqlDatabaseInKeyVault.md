---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# Register-AzureSqlDatabaseInKeyVault

## SYNOPSIS
Adds Azure sql database connection strings as secrets to keyvault.

## SYNTAX

### SaUser
```
Register-AzureSqlDatabaseInKeyVault -KeyVaultName <String> [-ResourceGroup <String>] [-Environment <String>]
 [-Regex <String>] -SqlSaPassword <String> [<CommonParameters>]
```

### KeyVaultUser
```
Register-AzureSqlDatabaseInKeyVault -KeyVaultName <String> [-ResourceGroup <String>] [-Environment <String>]
 [-Regex <String>] -ConfigurationKeyVaultName <String> [<CommonParameters>]
```

## DESCRIPTION
Scans sql database instances based on the search criteria and sets the key vault secrets to the connection strings.

## EXAMPLES

### EXAMPLE 1
```
Register-AzureSqlDatabase -KeyVaultName "test-vault" -ResourceGroup "test-rg" -Environment "uat" -Regex "(esw)" -SqlSaPassword "#sapasword1234" -ConfigurationKeyVaultName "sqlkvtest"
```

This command sets secrets in the test-vault for all environments ending in uat and containing esw in their name.

## PARAMETERS

### -KeyVaultName
Specifies the key vault to set the secrets in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroup
Specifies the resource group the azure sql server is in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Environment
Specifies the environment to limit the sql database name on.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Regex
Specifies the regex to limit the sql database name on.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlSaPassword
SQL Administrator password to use.

```yaml
Type: String
Parameter Sets: SaUser
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigurationKeyVaultName
Key vault name to get existing sql username and password secrets from.

```yaml
Type: String
Parameter Sets: KeyVaultUser
Aliases:

Required: True
Position: Named
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
Currently CmdletBinding doesn't have any internal support built-in.

## RELATED LINKS
