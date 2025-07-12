---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Connect-FabricAccount
---

# Connect-FabricAccount

## SYNOPSIS

Connects to the Fabric WebAPI.

## SYNTAX

### __AllParameterSets

```
Connect-FabricAccount [[-TenantId] <guid>] [[-ServicePrincipalId] <guid>]
 [[-ServicePrincipalSecret] <securestring>] [[-Credential] <pscredential>] [-Reset] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Connects to the Fabric WebAPI by using the cmdlet Connect-AzAccount.
This function retrieves the authentication token for the Fabric API and sets up the headers for API calls.

## EXAMPLES

### EXAMPLE 1

Connect-FabricAccount -TenantId '12345678-1234-1234-1234-123456789012'

Connects to the stated Tenant with exisitng credentials

### EXAMPLE 2

$credential = Get-Credential
Connect-FabricAccount -TenantId 'xxx' -credential $credential

Prompts for Service Principal id and secret and connects as that Service Principal

### EXAMPLE 3

Connect-FabricAccount -TenantId 'xxx' -ServicePrincipalId 'appId' -ServicePrincipalSecret $secret

Connects as Service Principal using id and secret

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Credential

A PSCredential object representing a user credential (username and secure password).

```yaml
Type: System.Management.Automation.PSCredential
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Reset

A switch parameter.
If provided, the function resets the Fabric authentication token.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServicePrincipalId

The Client ID (AppId) of the service principal used for authentication.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- AppId
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServicePrincipalSecret

The **secure string** representing the service principal secret.

```yaml
Type: System.Security.SecureString
DefaultValue: ''
SupportsWildcards: false
Aliases:
- AppSecret
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TenantId

The TenantId of the Azure Active Directory tenant you want to connect to and in which your Fabric Capacity is.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Tells PowerShell to run the command in a mode that only reports what would happen, but not actually let the command run or make changes.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None. This function does not return any output.

{{ Fill in the Description }}

## NOTES

Revision History:

- 2024-12-22 - FGE: Added Verbose Output
- 2025-05-26 - Jojobit: Added Service Principal support, with secure string handling and parameter descriptions, as supported by the original FabTools module
- 2025-06-02 - KNO: Added Reset switch to force re-authentication and token refresh

Author: Frank Geisler, Kamil Nowinski

## RELATED LINKS

- [Connect-AzAccount https://learn.microsoft.com/de-de/powershell/module/az.accounts/connect-azaccount?view=azps-12.4.0]()
