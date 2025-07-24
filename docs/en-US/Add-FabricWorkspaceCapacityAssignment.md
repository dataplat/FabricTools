---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Add-FabricWorkspaceCapacityAssignment
---

# Add-FabricWorkspaceCapacityAssignment

## SYNOPSIS

Assigns a Fabric workspace to a specified capacity.

## SYNTAX

### __AllParameterSets

```
Add-FabricWorkspaceCapacityAssignment [-WorkspaceId] <guid> [-CapacityId] <guid>
 [<CommonParameters>]
```

## ALIASES

Assign-FabricWorkspaceCapacity

## DESCRIPTION

The `Add-FabricWorkspaceCapacityAssignment` function sends a POST request to assign a workspace to a specific capacity.

## EXAMPLES

### EXAMPLE 1

Assigns the workspace with ID "workspace123" to the capacity "capacity456".

```powershell
Add-FabricWorkspaceCapacityAssignment -WorkspaceId "workspace123" -CapacityId "capacity456"
```

## PARAMETERS

### -CapacityId

The unique identifier of the capacity to which the workspace should be assigned.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WorkspaceId

The unique identifier of the workspace to be assigned.

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

