---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Connect-FabricAccount

## SYNOPSIS
Connects to the Fabric WebAPI.

## SYNTAX

```
Connect-FabricAccount [[-TenantId] <Guid>] [[-ServicePrincipalId] <Guid>]
 [[-ServicePrincipalSecret] <SecureString>] [[-Credential] <PSCredential>] [-Reset]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Connects to the Fabric WebAPI by using the cmdlet Connect-AzAccount.
This function retrieves the authentication token for the Fabric API and sets up the headers for API calls.

## EXAMPLES

### EXAMPLE 1
```
Connect-FabricAccount -TenantId '12345678-1234-1234-1234-123456789012'
```

Connects to the stated Tenant with exisitng credentials

### EXAMPLE 2
```
$credential = Get-Credential
Connect-FabricAccount -TenantId 'xxx' -credential $credential
```

Prompts for Service Principal id and secret and connects as that Service Principal

### EXAMPLE 3
```
Connect-FabricAccount -TenantId 'xxx' -ServicePrincipalId 'appId' -ServicePrincipalSecret $secret
```

Connects as Service Principal using id and secret

## PARAMETERS

### -Credential
A PSCredential object representing a user credential (username and secure password).

```yaml
Type: System.Management.Automation.PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: System.Management.Automation.ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reset
A switch parameter.
If provided, the function resets the Fabric authentication token.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServicePrincipalId
The Client ID (AppId) of the service principal used for authentication.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases: AppId

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServicePrincipalSecret
The **secure string** representing the service principal secret.

```yaml
Type: System.Security.SecureString
Parameter Sets: (All)
Aliases: AppSecret

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantId
The TenantId of the Azure Active Directory tenant you want to connect to and in which your Fabric Capacity is.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
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
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None. This function does not return any output.
## NOTES
Revision History:

- 2024-12-22 - FGE: Added Verbose Output
- 2025-05-26 - Jojobit: Added Service Principal support, with secure string handling and parameter descriptions, as supported by the original FabTools module
- 2025-06-02 - KNO: Added Reset switch to force re-authentication and token refresh

Author: Frank Geisler, Kamil Nowinski

## RELATED LINKS

[Connect-AzAccount https://learn.microsoft.com/de-de/powershell/module/az.accounts/connect-azaccount?view=azps-12.4.0]()

