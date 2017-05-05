---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
online version: 
schema: 2.0.0
---

# Reset-Alias

## SYNOPSIS
Creates and alias with replace functionality.

## SYNTAX

```
Reset-Alias [-Name] <String> [-Value] <String> [-Scope <String>]
```

## DESCRIPTION
Checks if the alias already exists, if it does calls Set-Alias on it, if it doesn't it will create a new alias using New-Alias.
Relays the alias scope.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Reset-Alias list get-childitem
```

This command creates an alias named "list" to represent the Get-ChildItem cmdlet on the "Global" scope.

## PARAMETERS

### -Name
Specifies the new alias.
You can use any alphanumeric characters in an alias, but the first character cannot be a number.

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

### -Value
Specifies the name of the cmdlet or command element that is being aliased.

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

### -Scope
Specifies the scope of the new alias.
Valid values are "Global", "Local", or "Script", or a number relative to the current scope (0 through the number of scopes, where 0 is the current scope and 1 is its parent).
"Local" is the default.
For more information, see about_Scopes.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: Global
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Currently CmdletBinding doesn't have any internal support built-in.

## RELATED LINKS

