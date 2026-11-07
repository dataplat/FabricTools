---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Git
Locale: en-US
Module Name: FabricTools
ms.date: 11/07/2026
PlatyPS schema version: 2024-05-01
title: Get-FabricGitStatus
---

# Get-FabricGitStatus

## SYNOPSIS

Gets the Git status of the items in a Fabric workspace.

## SYNTAX

### Default (Default)

```
Get-FabricGitStatus -WorkspaceId <guid> [-NoWait] [<CommonParameters>]
```

### ChangesOnly

```
Get-FabricGitStatus -WorkspaceId <guid> -ChangesOnly [-NoWait] [<CommonParameters>]
```

### ConflictsOnly

```
Get-FabricGitStatus -WorkspaceId <guid> -ConflictsOnly [-NoWait] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Returns the Git status of a workspace that is connected to Git: the workspace head, the
latest remote commit hash and the list of items that changed in the workspace and/or in
the remote branch, including conflicts.

By default the full API response is returned with a WorkspaceId property added.
With
-ChangesOnly or -ConflictsOnly, one flattened object per changed item is returned instead
(WorkspaceId, ItemName, ItemType, ObjectId, LogicalId, WorkspaceChange, RemoteChange,
ConflictType).
These objects can be piped into Invoke-FabricGitCommit to commit selected
items only.

## EXAMPLES

### EXAMPLE 1

Get-FabricGitStatus -WorkspaceId '11111111-1111-1111-1111-111111111111'

Returns workspaceHead, remoteCommitHash and changes of the workspace.

### EXAMPLE 2

Get-FabricGitStatus -WorkspaceId '11111111-1111-1111-1111-111111111111' -ChangesOnly | Format-Table ItemName, ItemType, WorkspaceChange, RemoteChange

Lists the changed items as a table.

### EXAMPLE 3

Get-FabricWorkspace -WorkspaceName 'Sales' | Get-FabricGitStatus -ConflictsOnly

Lists the items in conflict in the 'Sales' workspace.

## PARAMETERS

### -ChangesOnly

Returns one flattened object per changed item instead of the full response.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ChangesOnly
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ConflictsOnly

Like -ChangesOnly, but returns only items with a conflict.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ConflictsOnly
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoWait

Returns the long-running operation details instead of waiting for it to finish.

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

### -WorkspaceId

The ID of the workspace.
Accepts pipeline input by property name (alias Id).

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

### System.Guid

{{ Fill in the Description }}

## OUTPUTS

### System.Management.Automation.PSCustomObject

{{ Fill in the Description }}

## NOTES

https://learn.microsoft.com/en-us/rest/api/fabric/core/git/get-status

Requires the workspace Contributor role or higher.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

