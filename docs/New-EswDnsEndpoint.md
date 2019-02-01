---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# New-EswDnsEndpoint

## SYNOPSIS
Adds a record to a DNS zone.

## SYNTAX

```
New-EswDnsEndpoint [-DnsName] <String> [-ResourceGroupName] <String> [-DnsZone] <String> [-IpAddress <String>]
 [-RecordType <String>] [-CName <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Adds a record to a DNS zone.

## EXAMPLES

### EXAMPLE 1
```
New-EswDnsEndPoint -DnsName 'test-record' -ResourceGroupName 'test-rg' -DnsZone 'test.eshopworld.net' -IpAddress '192.168.5.5'
```

Will create an A record with an ip address of 192.168.5.5 in the test.eshopworld.net zone.

## PARAMETERS

### -DnsName
The name of the DNS record being created.

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

### -DnsZone
The DNS Zone the record will be created in.

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

### -IpAddress
The IP Address of the A record being created.

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

### -RecordType
The type of record being created, defaults to an 'A' record.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: A
Accept pipeline input: False
Accept wildcard characters: False
```

### -CName
If this is CName record being created, this is the url to create it for.

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

### -Force
Force the recreation of the rule.

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
