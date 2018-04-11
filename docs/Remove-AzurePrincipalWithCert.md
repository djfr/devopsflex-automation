---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# Remove-AzurePrincipalWithCert

## SYNOPSIS
Removes the Azure Active Directory Application, Principal and the cert stored for it.

## SYNTAX

```
Remove-AzurePrincipalWithCert [[-ADApplicationId] <String>] [[-ADApplication] <Object>]
 [[-VaultSubscriptionId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Removes the Azure Active Directory Application, Principal and the cert stored for it.

## EXAMPLES

### EXAMPLE 1
```
Remove-AzurePrincipalWithCert -ADApplicationId '[ID HERE]' -VaultSubscriptionId '[ID HERE]'
```

## PARAMETERS

### -ADApplicationId
The Id of the Azure Active Directory Application you with to remove.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ADApplication
The Azure Active Directory Application you with to remove.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -VaultSubscriptionId
The subscription Id that Key Vault is on.

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
