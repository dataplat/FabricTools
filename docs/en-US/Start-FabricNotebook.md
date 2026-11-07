---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Notebook
Locale: en-US
Module Name: FabricTools
ms.date: 11/07/2026
PlatyPS schema version: 2024-05-01
title: Start-FabricNotebook
---

# Start-FabricNotebook

## SYNOPSIS

Starts a notebook in Microsoft Fabric.

## SYNTAX

### ById (Default)

```
Start-FabricNotebook -WorkspaceId <guid> -NotebookId <guid> [-NoWait] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByName

```
Start-FabricNotebook -WorkspaceId <guid> -NotebookName <string> [-NoWait] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Submits a RunNotebook job in the specified workspace and waits for its
terminal job status by default.
Notebook names must match exactly one
notebook in that workspace.
Polling follows the job-instance Location
and honors Retry-After, rather than using the generic LRO endpoints.

## EXAMPLES

### EXAMPLE 1

Start-FabricNotebook -WorkspaceId '11111111-1111-1111-1111-111111111111' -NotebookName 'Daily load'

Runs Daily load and returns its final job instance.

### EXAMPLE 2

Start-FabricNotebook -WorkspaceId '11111111-1111-1111-1111-111111111111' -NotebookId '22222222-2222-2222-2222-222222222222' -NoWait

Submits the notebook and returns its current job instance promptly.

### EXAMPLE 3

Start-FabricNotebook -WorkspaceId '11111111-1111-1111-1111-111111111111' -NotebookName 'Daily load' -WhatIf

Resolves the notebook and previews execution without submitting a job.

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

### -NotebookId

The ID of the notebook to run.
Cannot be combined with NotebookName.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ById
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NotebookName

The display name of the notebook to run.
Cannot be combined with NotebookId.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByName
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

Returns the submitted job's current instance without waiting for completion.

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

The ID of the workspace containing the notebook.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
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

## OUTPUTS

### System.Management.Automation.PSCustomObject

The current or final job instance

{{ Fill in the Description }}

## NOTES

Requires an authenticated Fabric session.
Notebook parameters and compute
configuration are not supported.

Author: FabricTools Team

## RELATED LINKS

{{ Fill in the related links here }}

