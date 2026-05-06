---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 04/08/2026
PlatyPS schema version: 2024-05-01
title: Get-FabricDataset
---

# Get-FabricDataset

## SYNOPSIS

Retrieves one or more Power BI datasets from My Workspace or a specific workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricDataset [[-WorkspaceId] <guid>] [[-DatasetId] <guid>] [[-DatasetName] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Calls the Power BI REST API to list datasets.
When `GroupId` is supplied the request targets a specific workspace
(`groups/{groupId}/datasets`); otherwise it targets My Workspace (`datasets`).

Optionally filter the results to a single dataset by `DatasetId` or `DatasetName`.

## EXAMPLES

### EXAMPLE 1

Retrieves all datasets from My Workspace.

```powershell
Get-FabricDataset
```

### EXAMPLE 2

Retrieves all datasets from a specific workspace.

```powershell
Get-FabricDataset -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890"
```

### EXAMPLE 3

Retrieves a specific dataset by name from a workspace.

```powershell
Get-FabricDataset -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890" -DatasetName "Sales Model"
```

### EXAMPLE 4

Retrieves a specific dataset by ID from My Workspace.

```powershell
Get-FabricDataset -DatasetId "12345678-90ab-cdef-1234-567890abcdef"
```

## PARAMETERS

### -DatasetId

(Optional) The unique identifier of a specific dataset to return.
Cannot be combined with `DatasetName`.

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

### -DatasetName

(Optional) The display name of a specific dataset to return.
Cannot be combined with `DatasetId`.

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

(Optional) The unique identifier of the workspace to query.
When omitted, datasets from My Workspace are returned.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- GroupId
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
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

- Requires a valid Power BI / Fabric token (call `Connect-FabricAccount` first).
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Callers with Read-only access to a workspace may receive a limited response
  (only `id` and `name` fields) from the in-group endpoint.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

