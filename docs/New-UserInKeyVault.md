---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version: http://blog.simonw.se/powershell-generating-random-password-for-active-directory/
schema: 2.0.0
---

# New-UserInKeyVault

## SYNOPSIS
Generates a strong password for a Username and stores both the Username and Password in the specified KeyVault.

## SYNTAX

```
New-UserInKeyVault [-KeyvaultName] <String> [-Name] <String> [-Username] <String> [-Type] <String>
 [-MinPasswordLength <Int32>] [-MaxPasswordLength <Int32>]
```

## DESCRIPTION
Generates a strong password for a Username and stores both the Username and Password in the specified KeyVault.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-UserInKeyVault -KeyvaultName 'mykeyvault' -Name 'myuser' -Username 'ausername' -Type 'VM'
```

Will generate a password for the user 'ausername' for a VM and store it in a named pair in keyvault 'mykeyvault' named 'myuser'.

## PARAMETERS

### -KeyvaultName
{{Fill KeyvaultName Description}}

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

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
{{Fill Username Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
{{Fill Type Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinPasswordLength
{{Fill MinPasswordLength Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxPasswordLength
{{Fill MaxPasswordLength Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Written by Simon Wåhlin, blog.simonw.se

## RELATED LINKS

