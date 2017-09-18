---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version: http://blog.simonw.se/powershell-generating-random-password-for-active-directory/
schema: 2.0.0
---

# New-SWRandomPassword

## SYNOPSIS
Generates one or more complex passwords designed to fulfill the requirements for Active Directory

## SYNTAX

### FixedLength (Default)
```
New-SWRandomPassword [-PasswordLength <Int32>] [-InputStrings <String[]>] [-FirstChar <String>]
 [-Count <Int32>]
```

### RandomLength
```
New-SWRandomPassword [-MinPasswordLength <Int32>] [-MaxPasswordLength <Int32>] [-InputStrings <String[]>]
 [-FirstChar <String>] [-Count <Int32>]
```

## DESCRIPTION
Generates one or more complex passwords designed to fulfill the requirements for Active Directory

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-SWRandomPassword
```

C&3SX6Kn

Will generate one password with a length between 8  and 12 chars.

### -------------------------- EXAMPLE 2 --------------------------
```
New-SWRandomPassword -MinPasswordLength 8 -MaxPasswordLength 12 -Count 4
```

7d&5cnaB
!Bh776T"Fw
9"C"RxKcY
%mtM7#9LQ9h

Will generate four passwords, each with a length of between 8 and 12 chars.

### -------------------------- EXAMPLE 3 --------------------------
```
New-SWRandomPassword -InputStrings abc, ABC, 123 -PasswordLength 4
```

3ABa

Generates a password with a length of 4 containing atleast one char from each InputString

### -------------------------- EXAMPLE 4 --------------------------
```
New-SWRandomPassword -InputStrings abc, ABC, 123 -PasswordLength 4 -FirstChar abcdefghijkmnpqrstuvwxyzABCEFGHJKLMNPQRSTUVWXYZ
```

3ABa

Generates a password with a length of 4 containing atleast one char from each InputString that will start with a letter from 
the string specified with the parameter FirstChar

## PARAMETERS

### -MinPasswordLength
{{Fill MinPasswordLength Description}}

```yaml
Type: Int32
Parameter Sets: RandomLength
Aliases: Min

Required: False
Position: Named
Default value: 8
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxPasswordLength
{{Fill MaxPasswordLength Description}}

```yaml
Type: Int32
Parameter Sets: RandomLength
Aliases: Max

Required: False
Position: Named
Default value: 12
Accept pipeline input: False
Accept wildcard characters: False
```

### -PasswordLength
{{Fill PasswordLength Description}}

```yaml
Type: Int32
Parameter Sets: FixedLength
Aliases: 

Required: False
Position: Named
Default value: 8
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputStrings
{{Fill InputStrings Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: @('abcdefghijklmnopqrstuvwxyz', 'ABCEFGHIJKLMNOPQRSTUVWXYZ', '0123456789', '!£$%^&*(){}[]#_')
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstChar
{{Fill FirstChar Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Count
{{Fill Count Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### [String]

## NOTES
Written by Simon Wåhlin, blog.simonw.se

## RELATED LINKS

[http://blog.simonw.se/powershell-generating-random-password-for-active-directory/](http://blog.simonw.se/powershell-generating-random-password-for-active-directory/)

