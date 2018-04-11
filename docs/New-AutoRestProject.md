---
external help file: DevOpsFlex.Automation.PowerShell-Help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# New-AutoRestProject

## SYNOPSIS
generates, builds and packs c# client side code for given JSON Swagger URL

## SYNTAX

```
New-AutoRestProject [-DefUrl] <String> [-Namespace] <String> [[-OutputFolder] <String>] [<CommonParameters>]
```

## DESCRIPTION
generate, build and pack nuget package for given JSON Swagger input

Currently supports:

win10-x64

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -DefUrl
URL for the Swagger definition JSON file

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

### -Namespace
Namespace to put generated code into

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

### -OutputFolder
Output folder

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

## RELATED LINKS
