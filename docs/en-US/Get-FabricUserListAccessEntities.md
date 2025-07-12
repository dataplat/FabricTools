---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricUserListAccessEntities
---

# Get-FabricUserListAccessEntities

## SYNOPSIS

Retrieves access entities for a specified user in Microsoft Fabric.

## SYNTAX

### __AllParameterSets

```
Get-FabricUserListAccessEntities [-UserId] <guid> [[-Type] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function retrieves a list of access entities associated with a specified user in Microsoft Fabric.
It supports filtering by entity type and handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1

This example retrieves all access entities associated with the user having ID "user-12345".

```powershell
Get-FabricUserListAccessEntities -UserId "user-12345"
```

### EXAMPLE 2

This example retrieves only the 'Dashboard' access entities associated with the user having ID "user-12345".

```powershell
Get-FabricUserListAccessEntities -UserId "user-12345" -Type "Dashboard"
```

## PARAMETERS

### -Type

The type of access entity to filter the results by.
This parameter is optional and supports predefined values such as 'CopyJob', 'Dashboard', 'DataPipeline', etc.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -UserId

The unique identifier of the user whose access entities are to be retrieved.
This parameter is mandatory.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
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

## NOTES

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

