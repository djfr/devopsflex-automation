---
external help file: DevOpsFlex.Automation.PowerShell-Help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# Set-AzureVMOSDiskSize

## SYNOPSIS
Creates and alias with replace functionality.

## SYNTAX

## DESCRIPTION
Checks if the alias already exists, if it does calls Set-Alias on it, if it doesn't it will create a new alias using New-Alias.
Relays the alias scope.

## EXAMPLES

### EXAMPLE 1
```
Reset-Alias list get-childitem
```

This command creates an alias named "list" to represent the Get-ChildItem cmdlet on the "Global" scope.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Currently CmdletBinding doesn't have any internal support built-in.

## RELATED LINKS
