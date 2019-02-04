---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# Add-AzScanPrincipalToDomainKeyVaults

## SYNOPSIS

scans through all Evolution recognized environment/domain/region permutations and adds secret access policy for given object principal id to ensure that configuration management process can write to the KeyVault when populating the slot configuration

## SYNTAX

```
Add-AzScanPrincipalToDomainKeyVaults [-IdentityObjectId] <String> [<CommonParameters>]
```

## DESCRIPTION

when configuration management pipeline iterates through all the slots and scans for its Azure resources, it needs permissions to be able to update the slot's configuration KeyVault

this functions ensures the corresponding permissions are set for all applicable Evolution KeyVaults

when running it, you need to have permissions to access all Evolution subscriptions and to update KeyVault Access policies

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -IdentityObjectId
id of the identity principal to set access policy for

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


### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS
