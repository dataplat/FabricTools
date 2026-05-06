---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 04/08/2026
PlatyPS schema version: 2024-05-01
title: Invoke-FabricDatasetRefresh
---

# Invoke-FabricDatasetRefresh

## SYNOPSIS

Triggers a refresh of a Power BI dataset.

## SYNTAX

### __AllParameterSets

```
Invoke-FabricDatasetRefresh [-DatasetId] <guid> [[-WorkspaceId] <guid>] [[-NotifyOption] <string>]
 [[-Type] <string>] [[-CommitMode] <string>] [[-MaxParallelism] <int>] [[-RetryCount] <int>]
 [[-Timeout] <string>] [[-EffectiveDate] <datetime>] [[-ApplyRefreshPolicy] <bool>]
 [[-Objects] <hashtable[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Calls the Power BI REST API to trigger an on-demand refresh for a specified dataset.
When `WorkspaceId` is supplied the request targets the dataset inside a specific workspace
(`groups/{groupId}/datasets/{datasetId}/refreshes`); otherwise it targets the dataset
in My Workspace (`datasets/{datasetId}/refreshes`).

Providing any parameter beyond `NotifyOption` triggers an enhanced refresh (requires
Premium or Fabric capacity).
Shared capacity supports only `NotifyOption` and is
limited to 8 refreshes per day.

## EXAMPLES

### EXAMPLE 1

Triggers a simple refresh of a dataset in My Workspace.

```powershell
Invoke-FabricDatasetRefresh -DatasetId "12345678-90ab-cdef-1234-567890abcdef"
```

### EXAMPLE 2

Triggers a full refresh of a dataset in a specific workspace with email notification on failure.

```powershell
Invoke-FabricDatasetRefresh `
    -DatasetId   "12345678-90ab-cdef-1234-567890abcdef" `
    -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890" `
    -Type        Full `
    -NotifyOption MailOnFailure
```

### EXAMPLE 3

Triggers an enhanced refresh targeting specific tables only.

```powershell
Invoke-FabricDatasetRefresh `
    -DatasetId  "12345678-90ab-cdef-1234-567890abcdef" `
    -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890" `
    -Objects    @(@{ table = 'Sales' }, @{ table = 'Date' }) `
    -CommitMode PartialBatch
```

## PARAMETERS

### -ApplyRefreshPolicy

(Optional) Whether to apply the configured incremental refresh policy.
Triggers an enhanced refresh when specified.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 9
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CommitMode

(Optional) Determines whether objects are committed in batches or only when complete.
Valid values: Transactional, PartialBatch.
Triggers an enhanced refresh when specified.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
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

### -DatasetId

(Mandatory) The unique identifier of the dataset to refresh.

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

### -EffectiveDate

(Optional) If an incremental refresh policy is applied, overrides the current date used
to determine the rolling window period.
Triggers an enhanced refresh when specified.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 8
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxParallelism

(Optional) The maximum number of threads on which to run parallel processing commands.
Triggers an enhanced refresh when specified.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NotifyOption

(Optional) Mail notification preference for the refresh.
Valid values: NoNotification, MailOnFailure, MailOnCompletion.
Defaults to NoNotification.
Not applicable to enhanced refreshes or service principal operations.

```yaml
Type: System.String
DefaultValue: NoNotification
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

### -Objects

(Optional) An array of hashtables specifying specific tables and/or partitions to process.
Each entry should contain 'table' and optionally 'partition' keys.
Triggers an enhanced refresh when specified.

Example: @(@{ table = 'Sales' }, @{ table = 'Date'; partition = 'Date-2024' })

```yaml
Type: System.Collections.Hashtable[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 10
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RetryCount

(Optional) The number of times the operation is retried before failing.
Triggers an enhanced refresh when specified.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 6
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Timeout

(Optional) The timeout per individual refresh attempt, in HH:MM:SS format (max 24 hours
total including retries).
Defaults to 5 hours.
Triggers an enhanced refresh when specified.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 7
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Type

(Optional) The type of processing to perform.
Valid values: Full, ClearValues, Calculate, DataOnly, Automatic, Defragment.
Triggers an enhanced refresh when specified.

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

(Optional) The unique identifier of the workspace that contains the dataset.
When omitted, the My Workspace endpoint is used.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- GroupId
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
- The API responds with 202 Accepted; the refresh runs asynchronously in the background.
- Use `Get-FabricDatasetRefreshHistory` to monitor refresh status.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

