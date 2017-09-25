---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version: 
schema: 2.0.0
---

# Disconnect-AzureEswNetworkSecurityGroups

## SYNOPSIS
Kill switch for NSGs in ARM VNets and NICs.

## SYNTAX

### VNet
```
Disconnect-AzureEswNetworkSecurityGroups -VNet <PSVirtualNetwork> [-Subnet <String>]
```

### Nic
```
Disconnect-AzureEswNetworkSecurityGroups [-Nic <PSNetworkInterface>]
```

## DESCRIPTION
Kill switch for NSGs in ARM VNets and NICs.
Dissociates NSGs from VNets, Subnets and Nics in a fast and efficient manner

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-AzureRmVirtualNetwork -Name my-vnet -ResourceGroupName my-rg | Disconnect-AzureEswNetworkSecurityGroups
```

Dissociates all NSGs from all the subnets in the my-vnet ARM Virtual Network.

### -------------------------- EXAMPLE 2 --------------------------
```
Get-AzureRmVirtualNetwork -Name my-vnet -ResourceGroupName my-rg | Disconnect-AzureEswNetworkSecurityGroups -Subnet my-subnet
```

Dissociates all NSGs from just for the my-subnet Subnet in the my-vnet ARM Virtual Network.

### -------------------------- EXAMPLE 3 --------------------------
```
Get-AzureRmNetworkInterface -Name my-nic -ResourceGroupName my-rg | Disconnect-AzureEswNetworkSecurityGroups
```

Dissociates all NSGs from the ARM NIC my-nic.

## PARAMETERS

### -VNet
The target VNet to dissociates NSGs from.

```yaml
Type: PSVirtualNetwork
Parameter Sets: VNet
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Subnet
The target Subnet in the VNet to dissociates NSGs from.
If $null it will attempt to dissociate all NSGs from all Subnets in the VNet.

```yaml
Type: String
Parameter Sets: VNet
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Nic
The target NIC (Network Interface card) to dissociates NSGs from.

```yaml
Type: PSNetworkInterface
Parameter Sets: Nic
Aliases: 

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

