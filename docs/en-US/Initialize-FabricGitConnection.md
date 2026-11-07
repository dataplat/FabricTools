---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 11/07/2026
PlatyPS schema version: 2024-05-01
title: Initialize-FabricGitConnection
---

# Initialize-FabricGitConnection

## SYNOPSIS

Initializes the Git connection of a Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Initialize-FabricGitConnection [-WorkspaceId] <guid> [[-InitializationStrategy] <string>] [-NoWait]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Initializes the Git connection of a workspace that is already connected to Git (state
'Connected').
This must be done once after connecting.
The result tells you what to do next
through requiredAction:
- None: workspace and branch are in sync.
- UpdateFromGit: run Invoke-FabricGitUpdate with the returned remoteCommitHash.
- CommitToGit: run Invoke-FabricGitCommit to push the workspace content to the branch.
Use Connect-FabricGit -Initialize to connect and initialize in one call.

## EXAMPLES

### EXAMPLE 1

Initialize-FabricGitConnection -WorkspaceId '11111111-1111-1111-1111-111111111111' -InitializationStrategy PreferRemote

Initializes the Git connection, preferring the content of the remote branch.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -InitializationStrategy

What to do when both the workspace and the Git branch have content.
None (default), PreferRemote or PreferWorkspace.

```yaml
Type: System.String
DefaultValue: None
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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

Object with requiredAction

{{ Fill in the Description }}

### System.Management.Automation.PSCustomObject

{{ Fill in the Description }}

## NOTES

https://learn.microsoft.com/en-us/rest/api/fabric/core/git/initialize-connection

Requires the workspace Admin role.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

