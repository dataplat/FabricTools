---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricKQLDatabaseDefinition
---

# Get-FabricKQLDatabaseDefinition

## SYNOPSIS

Retrieves the definition of a KQLDatabase from a specific workspace in Microsoft Fabric.

## SYNTAX

### __AllParameterSets

```
Get-FabricKQLDatabaseDefinition [-WorkspaceId] <guid> [[-KQLDatabaseId] <guid>]
 [[-KQLDatabaseFormat] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function fetches the KQLDatabase's content or metadata from a workspace.
It supports retrieving KQLDatabase definitions in the Jupyter KQLDatabase (`ipynb`) format.
Handles both synchronous and asynchronous operations, with detailed logging and error handling.

## EXAMPLES

### EXAMPLE 1

Retrieves the definition of the KQLDatabase with ID `67890` from the workspace with ID `12345` in the `ipynb` format.

```powershell
Get-FabricKQLDatabaseDefinition -WorkspaceId "12345" -KQLDatabaseId "67890"
```

### EXAMPLE 2

Retrieves the definitions of all KQLDatabases in the workspace with ID `12345` in the `ipynb` format.

```powershell
Get-FabricKQLDatabaseDefinition -WorkspaceId "12345"
```

## PARAMETERS

### -KQLDatabaseFormat

Specifies the format of the KQLDatabase definition.
Currently, only 'ipynb' is supported.

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

### -KQLDatabaseId

(Optional)The unique identifier of the KQLDatabase whose definition needs to be retrieved.

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

(Mandatory) The unique identifier of the workspace from which the KQLDatabase definition is to be retrieved.

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

