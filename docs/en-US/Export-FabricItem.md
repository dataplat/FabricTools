---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Export-FabricItem
---

# Export-FabricItem

## SYNOPSIS

Exports items from a Fabric workspace. Either all items in a workspace or a specific item.

## SYNTAX

### __AllParameterSets

```
Export-FabricItem [[-path] <string>] [[-WorkspaceId] <guid>] [[-filter] <scriptblock>]
 [[-itemID] <guid>] [<CommonParameters>]
```

## ALIASES

Export-FabItem

## DESCRIPTION

The Export-FabricItem function exports items from a Fabric workspace to a specified directory.
It can export items of type "Report", "SemanticModel", "SparkJobDefinitionV1" or "Notebook".
If a specific item ID is provided, only that item will be exported.
Otherwise, all items in the workspace will be exported.

## EXAMPLES

### EXAMPLE 1

This example exports all items from the Fabric workspace with the specified ID to the "C:\ExportedItems" directory.

```powershell
Export-FabricItem -workspaceId "12345678-1234-1234-1234-1234567890AB" -path "C:\ExportedItems"
```

### EXAMPLE 2

This example exports the item with the specified ID from the Fabric workspace with the specified ID to the "C:\ExportedItems" directory.

```powershell
Export-FabricItem -workspaceId "12345678-1234-1234-1234-1234567890AB" -itemID "98765432-4321-4321-4321-9876543210BA" -path "C:\ExportedItems"
```

## PARAMETERS

### -filter

A script block used to filter the items to be exported.
Only items that match the filter will be exported.
The default filter includes items of type "Report", "SemanticModel", "SparkJobDefinitionV1" or "Notebook".

```yaml
Type: System.Management.Automation.ScriptBlock
DefaultValue: '{ $_.type -in @("Report", "SemanticModel", "Notebook", "SparkJobDefinitionV1") }'
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

### -itemID

The ID of the specific item to export.
If provided, only that item will be exported.

```yaml
Type: System.Guid
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

### -path

The path to the directory where the items will be exported.
The default value is '.\pbipOutput'.

```yaml
Type: System.String
DefaultValue: .\pbipOutput
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

### -WorkspaceId

The ID of the Fabric workspace.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Author: Rui Romano

This function is based on the Export-FabricItems function written by Rui Romano.
https://github.com/microsoft/Analysis-Services/tree/master/pbidevmode/fabricps-pbip

## RELATED LINKS

{{ Fill in the related links here }}

