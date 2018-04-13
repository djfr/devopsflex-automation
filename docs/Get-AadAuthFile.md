---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# Get-AadAuthFile

## SYNOPSIS
Gets the contents of the keyvault and maps it to an Azure auth settings file.

## SYNTAX

```
Get-AadAuthFile [-KeyvaultName] <String> [-FileLocation <String>] [-FileName <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the contents of the keyvault and maps it to an Azure auth settings file.
Overrides the current file if it already exists, which is the desired behaviour, since what's on keyvault is the final set of settings.

You need to be loged in azure with 'Login-AzAccount' and you need to have LIST and READ rights on secrets on the target key vault.

## EXAMPLES

### EXAMPLE 1
```
Get-AadAuthFile -KeyvaultName 'my-kv'
```

Maps the contents of the 'my-kv' keyvault to the file '%LOCALAPPDATA%\Eshopworld\developer.azureauth'.

### EXAMPLE 2
```
Get-AadAuthFile -KeyvaultName 'my-kv' -FileLocation 'C:\MyFolder' -FileName 'myfile.azureauth'
```

Maps the contents of the 'my-kv' keyvault to the file 'C:\MyFolder\myfile.azureauth'.

## PARAMETERS

### -KeyvaultName
The name of the source key vault.

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

### -FileLocation
The file location (folder) where we are saving to.
Defaults to %LOCALAPPDATA%\Eshopworld

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: "$($env:LOCALAPPDATA)\Eshopworld"
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
The name of the file.
Defaults to developer.azureauth

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Developer.azureauth
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
