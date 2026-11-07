---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 11/07/2026
PlatyPS schema version: 2024-05-01
title: Get-FabricGitConnection
---

# Get-FabricGitConnection

## SYNOPSIS

Gets the Git connection details of a Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricGitConnection [-WorkspaceId] <guid> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Returns the Git connection state of the specified workspace, the Git provider details
(provider type, organization or owner, project, repository, branch and directory) and the
Git sync details (head commit and last sync time).
A WorkspaceId property is added to the
output so it can be piped into the other FabricGit cmdlets.

## EXAMPLES

### EXAMPLE 1

Get-FabricGitConnection -WorkspaceId '11111111-1111-1111-1111-111111111111'

Returns the Git connection details of the workspace.

### EXAMPLE 2

Get-FabricWorkspace -WorkspaceName 'Sales' | Get-FabricGitConnection

Returns the Git connection details of the 'Sales' workspace.

## PARAMETERS

### -WorkspaceId

The ID of the workspace.
Accepts pipeline input by property name (alias Id), so the output
of Get-FabricWorkspace can be piped in.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: 0
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

Object with gitConnectionState (NotConnected

{{ Fill in the Description }}

### System.Management.Automation.PSCustomObject

{{ Fill in the Description }}

## NOTES

https://learn.microsoft.com/en-us/rest/api/fabric/core/git/get-connection

Requires the workspace Admin role.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

