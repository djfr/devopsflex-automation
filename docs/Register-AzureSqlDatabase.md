---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version: 
schema: 2.0.0
---

# Register-AzureSqlDatabase

## SYNOPSIS
Adds Azure sql database connection strings as secrets to keyvault.

## SYNTAX

### SaUser
```
Register-AzureSqlDatabase -KeyVaultName <String> [-ResourceGroup <String>] [-Environment <String>]
 [-Regex <String>] -SqlSaPassword <String>
```

### KeyVaultUser
```
Register-AzureSqlDatabase -KeyVaultName <String> [-ResourceGroup <String>] [-Environment <String>]
 [-Regex <String>] -ConfigurationKeyVaultName <String>
```

## DESCRIPTION
Scans sql database instances based on the search criteria and sets the key vault secrets to the connection strings.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
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
{{Fill SqlSaPassword Description}}

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
{{Fill ConfigurationKeyVaultName Description}}

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

## INPUTS

## OUTPUTS

## NOTES
Currently CmdletBinding doesn't have any internal support built-in.

## RELATED LINKS

