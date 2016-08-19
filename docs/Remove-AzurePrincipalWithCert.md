---
external help file: DevOpsFlex.Automation.PowerShell-Help.xml
online version: 
schema: 2.0.0
---

# Remove-AzurePrincipalWithCert
## SYNOPSIS
Removes an Azure Service Principal that uses an x509 certificate to authenticate against the Azure AD.

## SYNTAX

```
Remove-AzurePrincipalWithCert [[-ADApplicationId] <String>] [[-ADApplication] <PSADApplication>]
 [[-VaultSubscriptionId] <String>]
```

## DESCRIPTION
Removes an Azure Service Principal that uses an x509 certificate to authenticate against the Azure AD.

In detail the script will:

Remove the encoded 64bit Cert string from keyvault.

Remove all the relevant configuration fields from the system keyvault.

Remove the Cert password from the specific passwords keyvault.

Remove the Azure Service Principal for the AD Application.

Remove the Azure AD Application.

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ADApplicationId
The ID GUID for the AD Application that we want removed.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 0
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -ADApplication
The AD Application that we want removed.

```yaml
Type: PSADApplication
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: 
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -VaultSubscriptionId
The GUID identifier of the Azure subscription where the keyvaults are deployed to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

