---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 11/07/2026
PlatyPS schema version: 2024-05-01
title: Invoke-FabricGitCommit
---

# Invoke-FabricGitCommit

## SYNOPSIS

Commits changes from a Fabric workspace to the connected Git branch.

## SYNTAX

### __AllParameterSets

```
Invoke-FabricGitCommit [-WorkspaceId] <guid> [[-Comment] <string>] [[-Item] <Object[]>]
 [[-WorkspaceHead] <string>] [-NoAutoResolve] [-NoWait] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Commits workspace changes to the Git branch the workspace is connected to.
Without -Item,
all changes are committed (mode 'All').
With -Item, only the given items are committed
(mode 'Selective').
Items can be piped in from Get-FabricGitStatus -ChangesOnly.

If -WorkspaceHead is not supplied, it is looked up with Get-FabricGitStatus just before
the commit.
Use -NoAutoResolve to turn off this lookup.

## EXAMPLES

### EXAMPLE 1

Invoke-FabricGitCommit -WorkspaceId '11111111-1111-1111-1111-111111111111' -Comment 'Nightly sync'

Commits all workspace changes.

### EXAMPLE 2

Get-FabricGitStatus -WorkspaceId '11111111-1111-1111-1111-111111111111' -ChangesOnly | Where-Object ItemType -eq 'Notebook' | Invoke-FabricGitCommit -Comment 'Notebooks only'

Commits only the changed notebooks.

## PARAMETERS

### -Comment

The commit message.
Maximum 300 characters.

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

### -Item

Items to commit.
Each object must have ObjectId and/or LogicalId properties (as returned
by Get-FabricGitStatus -ChangesOnly), or be a raw change from Get-FabricGitStatus
(with itemMetadata.itemIdentifier).
Accepts pipeline input.

```yaml
Type: System.Object[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAutoResolve

Does not look up WorkspaceHead automatically.
WorkspaceHead is then sent only if supplied.

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
  Position: 3
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

### System.Object[]

{{ Fill in the Description }}

## OUTPUTS

## NOTES

https://learn.microsoft.com/en-us/rest/api/fabric/core/git/commit-to-git

Requires the workspace Contributor role or higher.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

