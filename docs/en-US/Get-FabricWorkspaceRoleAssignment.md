---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricWorkspaceRoleAssignment
---

# Get-FabricWorkspaceRoleAssignment

## SYNOPSIS

Retrieves role assignments for a specified Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricWorkspaceRoleAssignment [-WorkspaceId] <guid> [[-WorkspaceRoleAssignmentId] <guid>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricWorkspaceRoleAssignments` function fetches the role assignments associated with a Fabric workspace by making a GET request to the API.
If `WorkspaceRoleAssignmentId` is provided, it retrieves the specific role assignment.

## EXAMPLES

### EXAMPLE 1

Fetches all role assignments for the workspace with the ID "workspace123".

```powershell
Get-FabricWorkspaceRoleAssignments -WorkspaceId "workspace123"
```

### EXAMPLE 2

Fetches the role assignment with the ID "role123" for the workspace "workspace123".

```powershell
Get-FabricWorkspaceRoleAssignments -WorkspaceId "workspace123" -WorkspaceRoleAssignmentId "role123"
```

## PARAMETERS

### -WorkspaceId

The unique identifier of the workspace to fetch role assignments for.

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

### -WorkspaceRoleAssignmentId

(Optional) The unique identifier of a specific role assignment to retrieve.

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

### System.Object

{{ Fill in the Description }}

## NOTES

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

