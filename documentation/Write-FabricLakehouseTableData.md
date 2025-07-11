---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Write-FabricLakehouseTableData

## SYNOPSIS
Loads data into a specified table in a Lakehouse within a Fabric workspace.

## SYNTAX

```
Write-FabricLakehouseTableData [-WorkspaceId] <Guid> [-LakehouseId] <Guid> [-TableName] <String>
 [-PathType] <String> [-RelativePath] <String> [-FileFormat] <String> [[-CsvDelimiter] <String>]
 [[-CsvHeader] <Boolean>] [-Mode] <String> [[-Recursive] <Boolean>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Loads data into a specified table in a Lakehouse within a Fabric workspace.
The function supports loading data from files or folders, with options for file format and CSV settings.

## EXAMPLES

### EXAMPLE 1
```
Import-FabricLakehouseTableData -WorkspaceId "your-workspace-id" -LakehouseId "your-lakehouse-id" -TableName "your-table-name" -PathType "File" -RelativePath "path/to/your/file.csv" -FileFormat "CSV" -CsvDelimiter "," -CsvHeader $true -Mode "append" -Recursive $false
This example loads data from a CSV file into the specified table in the Lakehouse.
```

### EXAMPLE 2
```
Import-FabricLakehouseTableData -WorkspaceId "your-workspace-id" -LakehouseId "your-lakehouse-id" -TableName "your-table-name" -PathType "Folder" -RelativePath "path/to/your/folder" -FileFormat "Parquet" -Mode "overwrite" -Recursive $true
This example loads data from a folder into the specified table in the Lakehouse, overwriting any existing data.
```

## PARAMETERS

### -CsvDelimiter
The delimiter used in the CSV file (default is comma).

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: ,
Accept pipeline input: False
Accept wildcard characters: False
```

### -CsvHeader
Indicates whether the CSV file has a header row (default is false).

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileFormat
The format of the file to load data from (CSV or Parquet).

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LakehouseId
The ID of the Lakehouse where the table resides.

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

### -Mode
The mode for loading data (append or overwrite).

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: Append
Accept pipeline input: False
Accept wildcard characters: False
```

### -PathType
The type of path to load data from (File or Folder).

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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

### -Recursive
Indicates whether to load data recursively from subfolders (default is false).

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelativePath
The relative path to the file or folder to load data from.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TableName
The name of the table to load data into.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
The ID of the workspace containing the Lakehouse.

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
Author: Tiago Balabuch

## RELATED LINKS
