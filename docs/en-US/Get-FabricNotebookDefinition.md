---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricNotebookDefinition
---

# Get-FabricNotebookDefinition

## SYNOPSIS

Retrieves the definition of a notebook from a specific workspace in Microsoft Fabric.

## SYNTAX

### __AllParameterSets

```
Get-FabricNotebookDefinition [-WorkspaceId] <guid> [[-NotebookId] <guid>]
 [[-NotebookFormat] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function fetches the notebook's content or metadata from a workspace.
It supports retrieving notebook definitions in the Jupyter Notebook (`ipynb`) format.
Handles both synchronous and asynchronous operations, with detailed logging and error handling.

## EXAMPLES

### EXAMPLE 1

Get-FabricNotebookDefinition -WorkspaceId "12345" -NotebookId "67890"

Retrieves the definition of the notebook with ID `67890` from the workspace with ID `12345` in the `ipynb` format.

### EXAMPLE 2

Get-FabricNotebookDefinition -WorkspaceId "12345"

Retrieves the definitions of all notebooks in the workspace with ID `12345` in the `ipynb` format.

## PARAMETERS

### -NotebookFormat

Specifies the format of the notebook definition.
Currently, only 'ipynb' is supported.
Default: 'ipynb'.

```yaml
Type: System.String
DefaultValue: ipynb
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

### -NotebookId

(Optional)The unique identifier of the notebook whose definition needs to be retrieved.

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

### -WorkspaceId

(Mandatory) The unique identifier of the workspace from which the notebook definition is to be retrieved.

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
- Handles long-running operations asynchronously.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

