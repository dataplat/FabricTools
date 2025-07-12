---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Add-FabricWorkspaceRoleAssignment
---

# Add-FabricWorkspaceRoleAssignment

## SYNOPSIS

Assigns a role to a principal for a specified Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Add-FabricWorkspaceRoleAssignment [-WorkspaceId] <guid> [-PrincipalId] <guid>
 [-PrincipalType] <string> [-WorkspaceRole] <string> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Add-FabricWorkspaceRoleAssignments` function assigns a role (e.g., Admin, Contributor, Member, Viewer) to a principal (e.g., User, Group, ServicePrincipal) in a Fabric workspace by making a POST request to the API.

## EXAMPLES

### EXAMPLE 1

Assigns the Admin role to the user with ID "principal123" in the workspace "workspace123".

```powershell
Add-FabricWorkspaceRoleAssignment -WorkspaceId "workspace123" -PrincipalId "principal123" -PrincipalType "User" -WorkspaceRole "Admin"
```

## PARAMETERS

### -PrincipalId

The unique identifier of the principal (User, Group, etc.) to assign the role.

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

### -PrincipalType

The type of the principal.
Allowed values: Group, ServicePrincipal, ServicePrincipalProfile, User.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WorkspaceId

The unique identifier of the workspace.

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

### -WorkspaceRole

The role to assign to the principal.
Allowed values: Admin, Contributor, Member, Viewer.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
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

### System.Collections.Hashtable

{{ Fill in the Description }}

## NOTES

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

