---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 11/07/2026
PlatyPS schema version: 2024-05-01
title: Invoke-FabricGitUpdate
---

# Invoke-FabricGitUpdate

## SYNOPSIS

Updates a Fabric workspace with the latest commits from the connected Git branch.

## SYNTAX

### __AllParameterSets

```
Invoke-FabricGitUpdate [-WorkspaceId] <guid> [[-RemoteCommitHash] <string>]
 [[-WorkspaceHead] <string>] [[-ConflictResolutionPolicy] <string>] [-AllowOverrideItems]
 [-NoAutoResolve] [-NoWait] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Updates the workspace with commits pushed to the connected branch.
Workspace items may be
overwritten, so the cmdlet asks for confirmation by default; use -Confirm:$false to skip
the prompt.

If -RemoteCommitHash or -WorkspaceHead are not supplied, they are looked up with
Get-FabricGitStatus just before the update.
Use -NoAutoResolve to turn off this lookup;
-RemoteCommitHash is then required.

## EXAMPLES

### EXAMPLE 1

Invoke-FabricGitUpdate -WorkspaceId '11111111-1111-1111-1111-111111111111' -Confirm:$false

Updates the workspace to the latest remote commit without prompting.

### EXAMPLE 2

Invoke-FabricGitUpdate -WorkspaceId '11111111-1111-1111-1111-111111111111' -ConflictResolutionPolicy PreferRemote -AllowOverrideItems

Updates the workspace and resolves conflicts in favour of the remote branch.

## PARAMETERS

### -AllowOverrideItems

Allows the update to override incoming items that conflict with workspace items.

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

### -ConflictResolutionPolicy

How to resolve conflicts: PreferRemote or PreferWorkspace.
When omitted, the update fails
if there are conflicts.

```yaml
Type: System.String
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

### -NoAutoResolve

Does not look up RemoteCommitHash and WorkspaceHead automatically.

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

### -RemoteCommitHash

The full SHA hash of the remote commit to update to.
Looked up automatically when omitted.

```yaml
Type: System.String
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

### -WorkspaceHead

The full SHA hash the workspace is synced to.
Looked up automatically when omitted.

```yaml
Type: System.String
DefaultValue: ''
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

## NOTES

https://learn.microsoft.com/en-us/rest/api/fabric/core/git/update-from-git

Requires the workspace Contributor role or higher.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

