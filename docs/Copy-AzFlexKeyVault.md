---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# Copy-AzFlexKeyVault

## SYNOPSIS
Copies Secrets and Access Policies from a source KeyVault onto a Destination KeyVault.

## SYNTAX

```
Copy-AzFlexKeyVault [-SourceKeyvaultName] <String> [-SourceResourceGroup] <String>
 [-DestinationKeyvaultName] <String> [-DestinationResourceGroup] <String> [<CommonParameters>]
```

## DESCRIPTION
Copies Secrets and Access Policies from a source KeyVault onto a Destination KeyVault.

You need to be in the right subscription where both KeyVaults are located.
Both source and destination KeyVault need to be on the same subscription.
You need to be loged in azure with 'Login-AzAccount' and you need to have LIST and READ rights on secrets on the target key vault.

## EXAMPLES

### EXAMPLE 1
```
Copy-AzFlexKeyVault -SourceKeyvaultName my-source-kv -SourceResourceGroup my-source-kv-rg -DestinationKeyvaultName my-destination-kv -DestinationResourceGroup my-destination-kv-rg
```

Copies Secrets and Access Policies from the KeyVault my-source-kv in Resource Group my-source-kv-rg to the KeyVault my-destination-kv in Resource Group my-destination-kv-rg.

## PARAMETERS

### -SourceKeyvaultName
The name of the source KeyVault.

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

### -SourceResourceGroup
The name of the source KeyVault Resource Group.

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

### -DestinationKeyvaultName
The name of the destination KeyVault.

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

### -DestinationResourceGroup
The name of the destination KeyVault Resource Group.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
