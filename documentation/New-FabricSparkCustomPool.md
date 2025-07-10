---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# New-FabricSparkCustomPool

## SYNOPSIS
Creates a new Spark custom pool in a specified Microsoft Fabric workspace.

## SYNTAX

```
New-FabricSparkCustomPool [-WorkspaceId] <Guid> [-SparkCustomPoolName] <String> [-NodeFamily] <String>
 [-NodeSize] <String> [-AutoScaleEnabled] <Boolean> [-AutoScaleMinNodeCount] <Int32>
 [-AutoScaleMaxNodeCount] <Int32> [-DynamicExecutorAllocationEnabled] <Boolean>
 [-DynamicExecutorAllocationMinExecutors] <Int32> [-DynamicExecutorAllocationMaxExecutors] <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function sends a POST request to the Microsoft Fabric API to create a new Spark custom pool
in the specified workspace.
It supports various parameters for Spark custom pool configuration.

## EXAMPLES

### EXAMPLE 1
```
New-FabricSparkCustomPool -WorkspaceId "workspace-12345" -SparkCustomPoolName "New Spark Pool" -NodeFamily "MemoryOptimized" -NodeSize "Large" -AutoScaleEnabled $true -AutoScaleMinNodeCount 1 -AutoScaleMaxNodeCount 10 -DynamicExecutorAllocationEnabled $true -DynamicExecutorAllocationMinExecutors 1 -DynamicExecutorAllocationMaxExecutors 10
This example creates a new Spark custom pool named "New Spark Pool" in the workspace with ID "workspace-12345" with the specified configuration.
```

## PARAMETERS

### -AutoScaleEnabled
Specifies whether auto-scaling is enabled for the Spark custom pool.
This parameter is mandatory.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoScaleMaxNodeCount
The maximum number of nodes for auto-scaling in the Spark custom pool.
This parameter is mandatory.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoScaleMinNodeCount
The minimum number of nodes for auto-scaling in the Spark custom pool.
This parameter is mandatory.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DynamicExecutorAllocationEnabled
Specifies whether dynamic executor allocation is enabled for the Spark custom pool.
This parameter is mandatory.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DynamicExecutorAllocationMaxExecutors
The maximum number of executors for dynamic executor allocation in the Spark custom pool.
This parameter is mandatory.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DynamicExecutorAllocationMinExecutors
The minimum number of executors for dynamic executor allocation in the Spark custom pool.
This parameter is mandatory.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -NodeFamily
The family of nodes to be used in the Spark custom pool.
This parameter is mandatory and must be 'MemoryOptimized'.

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

### -NodeSize
The size of the nodes to be used in the Spark custom pool.
This parameter is mandatory and must be one of 'Large', 'Medium', 'Small', 'XLarge', 'XXLarge'.

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

### -SparkCustomPoolName
The name of the Spark custom pool to be created.
This parameter is mandatory.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
The unique identifier of the workspace where the Spark custom pool will be created.
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

Author: Tiago Balabuch

## RELATED LINKS
