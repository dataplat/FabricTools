---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricItem
---

# Get-FabricItem

## SYNOPSIS

Retrieves fabric items from a workspace.

## SYNTAX

### WorkspaceId

```
Get-FabricItem -WorkspaceId <guid> [-type <string>] [-itemID <guid>] [<CommonParameters>]
```

### WorkspaceObject

```
Get-FabricItem -Workspace <Object> [-type <string>] [-itemID <guid>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Get-FabricItem function retrieves fabric items from a specified workspace.
It can retrieve all items or filter them by item type.

## EXAMPLES

### EXAMPLE 1

This example retrieves all fabric items of type "file" from the workspace with ID "12345".

```powershell
Get-FabricItem -workspaceId "12345" -type "file"
```

## PARAMETERS

### -itemID

The ID of the specific item to retrieve.
If not specified, all items will be retrieved.

```yaml
Type: System.Guid
DefaultValue: ''
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

### -type

(Optional) The type of the fabric items to retrieve.
If not specified, all items will be retrieved.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- itemType
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

### -Workspace

The workspace object from which to retrieve the fabric items.
This parameter can be piped into the function.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WorkspaceObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WorkspaceId

The ID of the workspace from which to retrieve the fabric items.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WorkspaceId
  Position: Named
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

### System.Object

{{ Fill in the Description }}

## OUTPUTS

## NOTES

Author: Rui Romano

## RELATED LINKS

{{ Fill in the related links here }}

