---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# New-EswApplicationGateway

## SYNOPSIS
Provisions a new Application Gateway for the eShopworld evolution platform.

## SYNTAX

```
New-EswApplicationGateway [-ResourceGroupName] <String> [<CommonParameters>]
```

## DESCRIPTION
Provisions a new Application Gateway for the eShopworld evolution platform.

## EXAMPLES

### EXAMPLE 1
```
Provisions a new Application Gateway to the 'eus-platform-test' resource group, the new gateway's details and configuration will be defined by the last gateway provisioned to that resource group.
```

New-EswApplicationGateway -ResourceGroupName 'eus-platform-test'

## PARAMETERS

### -ResourceGroupName
The name of the azure resource group that the application gateway will be provisioned to.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function assumes you are connected to ARM (Login-AzAccount) and that you are already in the right subscription on ARM.

## RELATED LINKS
