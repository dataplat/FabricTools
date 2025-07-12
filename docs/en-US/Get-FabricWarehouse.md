---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricWarehouse
---

# Get-FabricWarehouse

## SYNOPSIS

Retrieves warehouse details from a specified Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricWarehouse [-WorkspaceId] <guid> [[-WarehouseId] <guid>] [[-WarehouseName] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function retrieves warehouse details from a specified workspace using either the provided WarehouseId or WarehouseName.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1

This example retrieves the warehouse details for the warehouse with ID "warehouse-67890" in the workspace with ID "workspace-12345".

```powershell
Get-FabricWarehouse -WorkspaceId "workspace-12345" -WarehouseId "warehouse-67890"
```

### EXAMPLE 2

This example retrieves the warehouse details for the warehouse named "My Warehouse" in the workspace with ID "workspace-12345".

```powershell
Get-FabricWarehouse -WorkspaceId "workspace-12345" -WarehouseName "My Warehouse"
```

## PARAMETERS

### -WarehouseId

The unique identifier of the warehouse to retrieve.
This parameter is optional.

```yaml
Type: System.Guid
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

### -WarehouseName

The name of the warehouse to retrieve.
This parameter is optional.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -WorkspaceId

The unique identifier of the workspace where the warehouse exists.
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

