---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 04/01/2026
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
 [[-ServicePrincipalSecret] <securestring>] [[-Credential] <pscredential>] [-Reset]
 [-UseDeviceAuthentication] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Connects to the Fabric WebAPI by using the cmdlet Connect-AzAccount.
This function retrieves the authentication token for the Fabric API and sets up the headers for API calls.
User sign-in uses interactive authentication by default. Use -UseDeviceAuthentication if the interactive broker or browser cannot be used.

## EXAMPLES

### EXAMPLE 1

Connects to the stated Tenant with existing credentials

```powershell
Connect-FabricAccount -TenantId '12345678-1234-1234-1234-123456789012'
```

### EXAMPLE 2

Connects as a service principal using a PSCredential object. The username is the service principal's application ID.

```powershell
$credential = Get-Credential -UserName '<service-principal-app-id>' -Message 'Enter the service principal client secret'
Connect-FabricAccount -TenantId '<tenant-id>' -Credential $credential
```

### EXAMPLE 3

Connects as Service Principal using AppId and secret

```powershell
$TenantID               = '12345678-1234-1234-1234-123456789012'
$ServicePrincipalId     = '4cbbe76e-1234-1234-0000-ffffffffffff'
$ServicePrincipalSecret = 'xyz'

$ServicePrincipalSecretSecure = ($ServicePrincipalSecret | ConvertTo-SecureString -AsPlainText -Force)
Connect-FabricAccount -TenantId $TenantID -ServicePrincipalId $ServicePrincipalId -ServicePrincipalSecret $ServicePrincipalSecretSecure -Reset
```

### EXAMPLE 4

Connects using device code authentication when interactive sign-in is unavailable.

```powershell
Connect-FabricAccount -UseDeviceAuthentication
```

### EXAMPLE 5

Connects as Service Principal using credential object

```powershell
$TenantID               = '12345678-1234-1234-1234-123456789012'
$ServicePrincipalId     = '4cbbe76e-1234-1234-0000-ffffffffffff'
$ServicePrincipalSecret = 'xyz'

$ServicePrincipalSecretSecure = ($ServicePrincipalSecret | ConvertTo-SecureString -AsPlainText -Force)
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ServicePrincipalId, $ServicePrincipalSecretSecure
Connect-FabricAccount -TenantId $TenantID -Credential $credential -Verbose -Reset
```

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

A PSCredential object containing a service principal's application ID as the username and client secret as the password. This is not for signing in as a user with a username and password.

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

Runs the command in a mode that only reports what would happen without performing the actions.

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
