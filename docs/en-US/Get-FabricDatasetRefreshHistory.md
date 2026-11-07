---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 04/08/2026
PlatyPS schema version: 2024-05-01
title: Get-FabricDatasetRefreshHistory
---

# Get-FabricDatasetRefreshHistory

## SYNOPSIS

Retrieves refresh history for a Power BI dataset or all datasets in a workspace.

## SYNTAX

### DatasetInMyWorkspace

```
Get-FabricDatasetRefreshHistory [-DatasetId] <guid> [-Top <int>] [<CommonParameters>]
```

### DatasetInWorkspace

```
Get-FabricDatasetRefreshHistory [-DatasetId] <guid> [-WorkspaceId] <guid> [-Top <int>] [<CommonParameters>]
```

### Workspace

```
Get-FabricDatasetRefreshHistory -WorkspaceId <guid> [-Top <int>] [<CommonParameters>]
```

## ALIASES

`WorkspaceId`: `GroupId`

## DESCRIPTION

Calls the Power BI REST API to retrieve refresh history for a dataset or all datasets in a
workspace. When `GroupId` is supplied the request targets the dataset inside a specific
workspace (`groups/{groupId}/datasets/{datasetId}/refreshes`); otherwise it targets the
dataset in My Workspace (`datasets/{datasetId}/refreshes`).

## EXAMPLES

### EXAMPLE 1

Retrieves the refresh history for a dataset in My Workspace.

```powershell
Get-FabricDatasetRefreshHistory -DatasetId "12345678-90ab-cdef-1234-567890abcdef"
```

### EXAMPLE 2

Retrieves the last 10 refresh history entries for a dataset in a specific workspace.

```powershell
Get-FabricDatasetRefreshHistory `
    -DatasetId "12345678-90ab-cdef-1234-567890abcdef" `
    -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890" `
    -Top 10
```

### EXAMPLE 3

Retrieves the latest refresh for every dataset in a workspace.

```powershell
Get-FabricDatasetRefreshHistory -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890" -Top 1
```

## PARAMETERS

### -DatasetId

The unique identifier of the dataset whose refresh history to retrieve. Omit this parameter
with `WorkspaceId` to retrieve refresh history for every dataset in the workspace.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatasetInMyWorkspace
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
  DontShow: false
  AcceptedValues: []
  HelpMessage: ''
- Name: DatasetInWorkspace
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Top

(Optional) The number of refresh history entries to return.
Must be at least 1.
When omitted, the Power BI API default of up to 60 entries is returned.

```yaml
Type: System.Int32
DefaultValue: 0
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

The unique identifier of the workspace that contains the dataset(s). Required when
`DatasetId` is omitted; when `DatasetId` is also supplied, it targets that dataset in the
workspace. When omitted, the My Workspace endpoint is used.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- GroupId
ParameterSets:
- Name: DatasetInWorkspace
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
  DontShow: false
  AcceptedValues: []
  HelpMessage: ''
- Name: Workspace
  Position: 1
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

- Requires a valid Power BI / Fabric token (call `Connect-FabricAccount` first).
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- OneDrive refresh history is not returned by the Power BI API.
- The API retains at most 60 entries; entries older than 3 days are pruned once more
  than 20 exist.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}
