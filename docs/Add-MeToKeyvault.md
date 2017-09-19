---
external help file: DevOpsFlex.Automation.PowerShell-Help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version: 
schema: 2.0.0
---

# Add-MeToKeyvault

## SYNOPSIS
Adds the current user (from Get-AzureRmContext) to a specific keyvault with all permissions on both secrets and keys.

## SYNTAX

```
Add-MeToKeyvault [-KeyvaultName] <String>
```

## DESCRIPTION
Adds the current user (from Get-AzureRmContext) to a specific keyvault with all permissions on both secrets and keys.

Subscription co-admins won't have default permissions in keyvaults, only the person that created them will have default permissions.

So it is handy to have a simple way to adding yourself with all permissions to a specific keyvault!

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -KeyvaultName
The name of the keyvault that you want to add yourself to.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

