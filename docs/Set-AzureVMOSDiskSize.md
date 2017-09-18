---
external help file: DevOpsFlex.Automation.PowerShell-Help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version: http://blog.simonw.se/powershell-generating-random-password-for-active-directory/
schema: 2.0.0
---

# Set-AzureVMOSDiskSize

## SYNOPSIS
Resizes the operating system VHD on an ASM Azure VM.

## SYNTAX

```
Set-AzureVMOSDiskSize -VM <ServiceOperationContext> [-SizeInGb] <Int32> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Resizes the operating system VHD on an Azure VM.

It contains a guard against shrinking the disk, although it will ultimately allow it if the user wants to.

This meets requirements where a disk was sized up by error and can be safely shrunk back if the partition wasn't increased.

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -VM
The Azure VM object that we want to resize the OS disk on.

```yaml
Type: ServiceOperationContext
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SizeInGb
The new OS disk size in Gb that we want to resize to.

This can be a smaller value then the current size for use cases where one actually wants to shrink the disk.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

