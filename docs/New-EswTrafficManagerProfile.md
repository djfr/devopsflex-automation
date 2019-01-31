---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# New-EswTrafficManagerProfile

## SYNOPSIS
Create a traffic manager profile and configure it's endpoints.

## SYNTAX

```
New-EswTrafficManagerProfile [-Name] <String> [-ResourceGroupName] <String> [-DnsPrefix] <String>
 [-DnsEndpoints] <PSObject[]> [-Port <Int32>] [-ProbePath <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Create a traffic manager profile and configure it's endpoints.

## EXAMPLES

### EXAMPLE 1
```
New-EswTrafficManagerProfile -Name 'test-profile' -ResourceGroupName 'test-rg' -DnsPrefix 'test-devops-api' -DnsEndpoints $dnsEndpoints -Port '555'
```

Will create a test-profile with the test-devops-api prefix using the dns endpoints passed in on port 555.
See the DNSEndpoint class in the FabricEndpoints.ps1 script.

## PARAMETERS

### -Name
The name of the traffic manager profile to create.

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

### -DnsPrefix
The prefix for the DNS to create.

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

### -DnsEndpoints
Array of the DnsEndpoint class that contains the Uri and Region for each endpoint.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The port to use.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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
Force the re-creation of the traffic manager profile.

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
