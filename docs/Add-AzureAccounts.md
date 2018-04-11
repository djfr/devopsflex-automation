---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# Add-AzureAccounts

## SYNOPSIS
Wraps Add-AzureAccount and Add-AzureRmAccount.

## SYNTAX

```
Add-AzureAccounts [<CommonParameters>]
```

## DESCRIPTION
Logs you in ASM and ARM by wrapping Add-AzureAccount and Add-AzureRmAccount.

## EXAMPLES

### EXAMPLE 1
```
Add-AzureAccounts
```

This command will log you in both ASM and ARM.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Currently CmdletBinding only has internal support for -Verbose.

## RELATED LINKS
