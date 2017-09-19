---
external help file: DevOpsFlex.Automation.PowerShell-Help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version: 
schema: 2.0.0
---

# Register-AzureSubscriptionInKeyVault

## SYNOPSIS
Scans the current subscription for anything that looks like configuration and adds it to a KeyVault instance.

## SYNTAX

```
Register-AzureSubscriptionInKeyVault [-KeyVaultName] <String> [-KeyType] <String> [-SqlPassword] <String>
 [-ResourceGroup <String>] [-EnvironmentFilter <String>] [-StgEnvRegex <String>] [-SbEnvRegex <String>]
 [-SqlEnvRegex <String>] [-SbAccessRuleName <String>] [-SetSqlPassword] [-ARMOnly]
```

## DESCRIPTION
Scans the current subscription for anything that looks like configuration and adds it to a KeyVault instance.

Currently supports:

Azure Storage accounts (both ASM and ARM).

Azure ServiceBus namespaces.

Azure SQL databases.

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -KeyVaultName
The name of the keyvault that you want to add configuration to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyType
Specifies if we want to use 'Primary' or 'Secondary' keys when uploading to KeyVault.

This facilitates the rotation of keys on a scheduled basis and reduces the risk of downtime during the rotation.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlPassword
The SqlPassword for all the databases found for the server sa user.

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

### -ResourceGroup
Allows for a Resource Group filter.

This will only be applied for ARM resources that are bound to Resource Groups.
Anything else will be unfiltered.

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

### -EnvironmentFilter
Allows for environment filters based on Regular Expressions.

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

### -StgEnvRegex
A regular expression that identifies the environment part on a storage account name.

Defaults to: '(.{3})$'.

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

### -SbEnvRegex
A regular expression that identifies the environment part on a service bus namespace.

Defaults to: '(-\[^-\]*)$'.

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

### -SqlEnvRegex
A regular expression that identifies the environment part on a sql database name.

Defaults to: '(-\[^-\]*)$'.

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

### -SbAccessRuleName
The name of the access rule for the service bus namespace that we want to send to KeyVault.

Defaults to: 'RootManageSharedAccessKey'.

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

### -SetSqlPassword
If switched on, the commandlet will set all the sa passwords to the password provided.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ARMOnly
If switched on, only resources exposed in ARM will be scanned.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

