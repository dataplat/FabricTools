---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Start-FabricLakehouseTableMaintenance
---

# Start-FabricLakehouseTableMaintenance

## SYNOPSIS

Initiates a table maintenance job for a specified Lakehouse in a Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Start-FabricLakehouseTableMaintenance [-WorkspaceId] <guid> [-LakehouseId] <guid>
 [[-JobType] <string>] [[-SchemaName] <string>] [[-TableName] <string>] [[-IsVOrder] <bool>]
 [[-ColumnsZOrderBy] <array>] [[-retentionPeriod] <string>] [[-waitForCompletion] <bool>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function sends a POST request to the Fabric API to start a table maintenance job for a specified Lakehouse.
It allows for optional parameters such as schema name, table name, and Z-ordering columns.
The function also handles asynchronous operations and can wait for completion if specified.

## EXAMPLES

### EXAMPLE 1

Initiates a table maintenance job for the specified Lakehouse and waits for its completion.

```powershell
Start-FabricLakehouseTableMaintenance -WorkspaceId "12345" -LakehouseId "67890" -JobType "TableMaintenance" -SchemaName "dbo" -TableName "MyTable" -IsVOrder $true -ColumnsZOrderBy @("Column1", "Column2") -retentionPeriod "7:00:00" -waitForCompletion $true
```

### EXAMPLE 2

Initiates a table maintenance job for the specified Lakehouse without waiting for its completion.

```powershell
Start-FabricLakehouseTableMaintenance -WorkspaceId "12345" -LakehouseId "67890" -JobType "TableMaintenance" -SchemaName "dbo" -TableName "MyTable" -IsVOrder $false -ColumnsZOrderBy @("Column1", "Column2") -retentionPeriod "7:00:00"
```

## PARAMETERS

### -ColumnsZOrderBy

An array of columns to be used for Z-ordering.
This parameter is optional.

```yaml
Type: System.Array
DefaultValue: ''
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

### -IsVOrder

A boolean flag indicating whether to apply V-ordering.
This parameter is optional.

```yaml
Type: System.Boolean
DefaultValue: False
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

### -JobType

The type of job to be initiated.
Default is "TableMaintenance".
This parameter is optional.

```yaml
Type: System.String
DefaultValue: TableMaintenance
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

### -LakehouseId

The unique identifier of the Lakehouse for which the table maintenance job is to be initiated.
This parameter is mandatory.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -retentionPeriod

The retention period for the table maintenance job.
This parameter is optional.

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

### -SchemaName

The name of the schema in the Lakehouse.
This parameter is optional.

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

### -TableName

The name of the table in the Lakehouse.
This parameter is optional.

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

### -waitForCompletion

A boolean flag indicating whether to wait for the job to complete.
Default is false.
This parameter is optional.

```yaml
Type: System.Boolean
DefaultValue: False
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

### -WhatIf

Tells PowerShell to run the command in a mode that only reports what would happen, but not actually let the command run or make changes.

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

The unique identifier of the workspace where the Lakehouse resides.
This parameter is mandatory.

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
- This function handles asynchronous operations and retrieves operation results if required.
- The function uses the `Write-Message` function for logging and debugging purposes.
- The function uses the `Get-FabricLakehouse` function to retrieve Lakehouse details.
- The function uses the `Get-FabricLongRunningOperation` function to check the status of long-running operations.
- The function uses the `Invoke-RestMethod` cmdlet to make API requests.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

