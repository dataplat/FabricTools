---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricLakehouseTable
---

# Get-FabricLakehouseTable

## SYNOPSIS

Retrieves tables from a specified Lakehouse in a Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricLakehouseTable [-WorkspaceId] <guid> [[-LakehouseId] <guid>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function retrieves tables from a specified Lakehouse in a Fabric workspace.
It handles pagination using a continuation token to ensure all data is retrieved.

## EXAMPLES

### EXAMPLE 1

This example retrieves all tables from the specified Lakehouse in the specified workspace.

```powershell
Get-FabricLakehouseTable -WorkspaceId "your-workspace-id" -LakehouseId "your-lakehouse-id"
```

## PARAMETERS

### -LakehouseId

The ID of the Lakehouse from which to retrieve tables.

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

### -WorkspaceId

The ID of the workspace containing the Lakehouse.

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

### System.Object

{{ Fill in the Description }}

## NOTES

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

