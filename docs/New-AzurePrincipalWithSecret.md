---
external help file: DevOpsFlex.Automation.PowerShell-Help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version: 
schema: 2.0.0
---

# New-AzurePrincipalWithSecret

## SYNOPSIS
Creates an Azure Service Principal that uses a password to authenticate against the Azure AD.

## SYNTAX

```
New-AzurePrincipalWithSecret [-SystemName] <String> [-PrincipalPurpose] <String> [-EnvironmentName] <String>
 [-PrincipalPassword] <String> [[-VaultSubscriptionId] <String>] [-PrincipalName <String>]
```

## DESCRIPTION
Creates an Azure Service Principal that uses a password to authenticate against the Azure AD.

In detail the script will:

Create the Azure AD Application, specifying the password as it's User Assertion method.

Create the Azure Service Principal for the AD Application we just created.

Populate the system keyvault with all the relevant configuration fields so that the system can find and use the service principal, including the password.

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -SystemName
The name of the system that we are creating the service principal for.

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

### -PrincipalPurpose
The purpose of the principal to be created.
Can only be 'Configuration' or 'Authentication'.

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

### -EnvironmentName
The name of the environment that the service principal is going to be used on.

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

### -PrincipalPassword
The password for the principal that we are creating.

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

### -VaultSubscriptionId
The GUID identifier of the Azure subscription where the keyvaults are deployed to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrincipalName
The optional principal name to prepend to all the generated naming conventions.

This is mostly to allow people from differentiating principals for the same system/purpose/environment when they need to issue multiple.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

