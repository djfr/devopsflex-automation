---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# New-EswLoadBalancerConfig

## SYNOPSIS
Adds a probe and rule to an existing internal or external load balancer.

## SYNTAX

```
New-EswLoadBalancerConfig [-LoadBalancerName] <String> [-ResourceGroupName] <String> [-Name] <String>
 [-Port] <String> [-ProbePath <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Adds a probe and rule to an existing internal or external load balancer.

## EXAMPLES

### EXAMPLE 1
```
New-EswLoadBalancerConfig -LoadBalancerName 'test-lb' -ResourceGroupName 'test-rg' -Name 'test' -Port 999
```

Will create a 'test' probe and rule for port '999' on the 'test-lb' load balancer in the 'test-rg' resource group.

## PARAMETERS

### -LoadBalancerName
The name of the Azure load balancer you wish to configure.

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

### -ResourceGroupName
The Azure resource group name that the load balancer is in.

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
The name of the probe/rule you wish to create.
The convention is that they will both have the same name.

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

### -Port
The port you want to create the rule for.

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

### -ProbePath
The path of the probe you wish to create.
The default is '/Probe'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: /Probe
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Force the re-configuration of both the probe and the rule.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
