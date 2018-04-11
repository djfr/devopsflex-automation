---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# Register-AzureServiceBusInKeyVault

## SYNOPSIS
Adds Azure service bus connection strings as secrets to keyvault.

## SYNTAX

```
Register-AzureServiceBusInKeyVault [-KeyVaultName] <String> [[-Environment] <String>] [[-Regex] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Scans service bus namespaces for authorization rules and sets the keyvault secret to the connection string.

## EXAMPLES

### EXAMPLE 1
```
Register-AzureServiceBus -KeyVaultName "test-vault" -Environment "uat" -Regex "(esw)"
```

This command sets secrets in the test-vault for all environments ending in uat and containing esw in their namespace.

## PARAMETERS

### -KeyVaultName
Specifies the key vault to set the secrets in.

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

### -Environment
Specifies the environment to limit the service bus namespace on.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Regex
Specifies the regex to limit the service bus namespace on.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
