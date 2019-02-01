---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# Add-EswApplicationGatewayCertificate

## SYNOPSIS
Adds a certificate from Key Vault to an Application Gateway.

## SYNTAX

```
Add-EswApplicationGatewayCertificate [-AppGatewayName] <String> [-ResourceGroupName] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Adds a certificate from Key Vault to an Application Gateway.

## EXAMPLES

### EXAMPLE 1
```
Adds a certificate from the key vault deployed to the 'eus-platform-test' to the application gateway named 'esw-we-fabric-test-ag-01'
```

Add-EswApplicationGatewayCertificate -AppGatewayName 'esw-we-fabric-test-ag-01' -ResourceGroupName 'eus-platform-test'

## PARAMETERS

### -AppGatewayName
The name of the application gateway that the certificate will be added to.

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

### -ResourceGroupName
The name of the azure resource group that the application gateway is in.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function assumes you are connected to ARM (Login-AzAccount) and that you are already in the right subscription on ARM.

## RELATED LINKS
