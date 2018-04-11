---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# Switch-AzureSubscription

## SYNOPSIS
Help method with UI (Out-GridView) for switching across Azure subscriptions.

## SYNTAX

```
Switch-AzureSubscription [<CommonParameters>]
```

## DESCRIPTION
Shows you the list of available subscriptions (Out-GridView) and then selects the chosen one in both ASM and ARM.

## EXAMPLES

### EXAMPLE 1
```
Switch-AzureSubscription
```

This command will show you the list of available subscriptions and then select the chosen one in both ASM and ARM.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Currently CmdletBinding only has internal support for -Verbose.

## RELATED LINKS
