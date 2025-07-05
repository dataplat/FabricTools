---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricLakehouseTable

## SYNOPSIS
Retrieves tables from a specified Lakehouse in a Fabric workspace.

## SYNTAX

```
Get-FabricLakehouseTable [-WorkspaceId] <Guid> [[-LakehouseId] <Guid>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function retrieves tables from a specified Lakehouse in a Fabric workspace.
It handles pagination using a continuation token to ensure all data is retrieved.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricLakehouseTable -WorkspaceId "your-workspace-id" -LakehouseId "your-lakehouse-id"
This example retrieves all tables from the specified Lakehouse in the specified workspace.
```

## PARAMETERS

### -LakehouseId
The ID of the Lakehouse from which to retrieve tables.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object[]
## NOTES
Author: Tiago Balabuch

## RELATED LINKS
