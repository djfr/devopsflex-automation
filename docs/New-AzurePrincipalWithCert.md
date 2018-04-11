---
external help file: DevOpsFlex.Automation.PowerShell-help.xml
Module Name: DevOpsFlex.Automation.PowerShell
online version:
schema: 2.0.0
---

# New-AzurePrincipalWithCert

## SYNOPSIS
Adds AzureRM Active Directory Application and persists a cert to Key Vault for it.

## SYNTAX

```
New-AzurePrincipalWithCert [-SystemName] <String> [-PrincipalPurpose] <String> [-EnvironmentName] <String>
 [-CertFolderPath] <String> [-CertPassword] <String> [[-VaultSubscriptionId] <String>]
 [[-PrincipalName] <String>] [<CommonParameters>]
```

## DESCRIPTION
1.
Creates a new Azure Active Directory Application
2.
Creates a new cert in Azure Key Vault for the AAD Application.

## EXAMPLES

### EXAMPLE 1
```
New-AzurePrincipalWithCert -SystemName 'sys1' `
```

-PrincipalPurpose 'Authentication' \`
                           -EnvironmentName 'test' \`
                           -CertFolderPath 'C:\Certificates' \`
                           -CertPassword 'something123$' \`
                           -VaultSubscriptionId '\[ID HERE\]' \`
                           -PrincipalName 'Keyvault'

## PARAMETERS

### -SystemName
The system the application is for.

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

### -PrincipalPurpose
The purpose of the principal Authentication or Configuration.

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

### -EnvironmentName
The environment the application is for.

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

### -CertFolderPath
Local path to where the cert will be created.

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

### -CertPassword
The password for the cert.

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

### -VaultSubscriptionId
The subscription Id that Key Vault is on.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrincipalName
The name of the Key Vault principal.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Currently CmdletBinding doesn't have any internal support built-in.

## RELATED LINKS
