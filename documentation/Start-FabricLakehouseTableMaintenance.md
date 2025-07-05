---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Start-FabricLakehouseTableMaintenance

## SYNOPSIS
Initiates a table maintenance job for a specified Lakehouse in a Fabric workspace.

## SYNTAX

```
Start-FabricLakehouseTableMaintenance [-WorkspaceId] <Guid> [-LakehouseId] <Guid> [[-JobType] <String>]
 [[-SchemaName] <String>] [[-TableName] <String>] [[-IsVOrder] <Boolean>] [[-ColumnsZOrderBy] <Array>]
 [[-retentionPeriod] <String>] [[-waitForCompletion] <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function sends a POST request to the Fabric API to start a table maintenance job for a specified Lakehouse.
It allows for optional parameters such as schema name, table name, and Z-ordering columns.
The function also handles asynchronous operations and can wait for completion if specified.

## EXAMPLES

### EXAMPLE 1
```
Start-FabricLakehouseTableMaintenance -WorkspaceId "12345" -LakehouseId "67890" -JobType "TableMaintenance" -SchemaName "dbo" -TableName "MyTable" -IsVOrder $true -ColumnsZOrderBy @("Column1", "Column2") -retentionPeriod "7:00:00" -waitForCompletion $true
Initiates a table maintenance job for the specified Lakehouse and waits for its completion.
```

### EXAMPLE 2
```
Start-FabricLakehouseTableMaintenance -WorkspaceId "12345" -LakehouseId "67890" -JobType "TableMaintenance" -SchemaName "dbo" -TableName "MyTable" -IsVOrder $false -ColumnsZOrderBy @("Column1", "Column2") -retentionPeriod "7:00:00"
Initiates a table maintenance job for the specified Lakehouse without waiting for its completion.
```

## PARAMETERS

### -ColumnsZOrderBy
An array of columns to be used for Z-ordering.
This parameter is optional.

```yaml
Type: System.Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsVOrder
A boolean flag indicating whether to apply V-ordering.
This parameter is optional.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobType
The type of job to be initiated.
Default is "TableMaintenance".
This parameter is optional.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: TableMaintenance
Accept pipeline input: False
Accept wildcard characters: False
```

### -LakehouseId
The unique identifier of the Lakehouse for which the table maintenance job is to be initiated.
This parameter is mandatory.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: System.Management.Automation.ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -retentionPeriod
The retention period for the table maintenance job.
This parameter is optional.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SchemaName
The name of the schema in the Lakehouse.
This parameter is optional.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TableName
The name of the table in the Lakehouse.
This parameter is optional.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -waitForCompletion
A boolean flag indicating whether to wait for the job to complete.
Default is false.
This parameter is optional.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
The unique identifier of the workspace where the Lakehouse resides.
This parameter is mandatory.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.
- This function handles asynchronous operations and retrieves operation results if required.
- The function uses the \`Write-Message\` function for logging and debugging purposes.
- The function uses the \`Get-FabricLakehouse\` function to retrieve Lakehouse details.
- The function uses the \`Get-FabricLongRunningOperation\` function to check the status of long-running operations.
- The function uses the \`Invoke-RestMethod\` cmdlet to make API requests.

Author: Tiago Balabuch

## RELATED LINKS
