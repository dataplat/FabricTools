---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricWorkspaceUser
---

# Get-FabricWorkspaceUser

## SYNOPSIS

Retrieves the user(s) of a workspace.

## SYNTAX

### WorkspaceId

```
Get-FabricWorkspaceUser -WorkspaceId <guid> [<CommonParameters>]
```

### WorkspaceObject

```
Get-FabricWorkspaceUser -Workspace <Object[]> [<CommonParameters>]
```

## ALIASES

Get-FabricWorkspaceUsers Get-FabWorkspaceUsers

## DESCRIPTION

The Get-FabricWorkspaceUser function retrieves the details of the users of a workspace.

## EXAMPLES

### EXAMPLE 1

Get-FabricWorkspaceUser -WorkspaceId '12345678-1234-1234-1234-123456789012

This example retrieves the users of a workspace of the workspace with the ID '12345678-1234-1234-1234-123456789012'.

### EXAMPLE 2

$workspace = Get-FabricWorkspace -WorkspaceName 'prod-workspace'
$workspace | Get-FabricWorkspaceUser

This example retrieves the users of the prod-workspace workspace by piping the object.

### EXAMPLE 3

Get-FabricWorkspaceUser -Workspace (Get-FabricWorkspace -WorkspaceName 'prod-workspace')

This example retrieves the users of the prod-workspace workspace by piping the object.

### EXAMPLE 4

Get-FabricWorkspace| Get-FabricWorkspaceUser

This example retrieves the users of all of the workspaces.
IMPORTANT: This will not return the workspace name or ID at present.

### EXAMPLE 5

Get-FabricWorkspace| Foreach-Object {
Get-FabricWorkspaceUser -WorkspaceId $_.Id | Select-Object @{Name='WorkspaceName';Expression={$_.displayName;}}, *
}

This example retrieves the users of all of the workspaces.
It will also add the workspace name to the output.

## PARAMETERS

### -Workspace

The workspace object.
This normally comes from the Get-FabricWorkspace cmdlet.
This is a mandatory parameter if WorkspaceId is not provided.

```yaml
Type: System.Object[]
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

The ID of the workspace.
This is a mandatory parameter if Workspace is not provided.

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

It supports multiple aliases for backward compatibility.
The function defines parameters for the workspace ID and workspace object.
If the parameter set name is 'WorkspaceId', it retrieves the workspace object.
It then makes a GET request to the PowerBI API to retrieve the users of the workspace and returns the 'value' property of the response, which contains the users.

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

