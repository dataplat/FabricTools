---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Update-FabricEnvironmentStagingSparkCompute

## SYNOPSIS
Updates the Spark compute configuration in the staging environment for a given workspace.

## SYNTAX

```
Update-FabricEnvironmentStagingSparkCompute [-WorkspaceId] <Guid> [-EnvironmentId] <Guid>
 [-InstancePoolName] <String> [-InstancePoolType] <String> [-DriverCores] <Int32> [-DriverMemory] <String>
 [-ExecutorCores] <Int32> [-ExecutorMemory] <String> [-DynamicExecutorAllocationEnabled] <Boolean>
 [-DynamicExecutorAllocationMinExecutors] <Int32> [-DynamicExecutorAllocationMaxExecutors] <Int32>
 [-RuntimeVersion] <String> [-SparkProperties] <Object> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function sends a PATCH request to the Microsoft Fabric API to update the Spark compute settings
for a specified environment, including instance pool, driver and executor configurations, and dynamic allocation settings.

## EXAMPLES

### EXAMPLE 1
```
Update-FabricEnvironmentStagingSparkCompute -WorkspaceId "workspace-12345" -EnvironmentId "env-67890" -InstancePoolName "pool1" -InstancePoolType "Workspace" -DriverCores 4 -DriverMemory "16GB" -ExecutorCores 8 -ExecutorMemory "32GB" -DynamicExecutorAllocationEnabled $true -DynamicExecutorAllocationMinExecutors 2 -DynamicExecutorAllocationMaxExecutors 10 -RuntimeVersion "3.1" -SparkProperties @{ "spark.executor.memoryOverhead"="4GB" }
```

## PARAMETERS

### -DriverCores
The number of cores to allocate to the driver.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DriverMemory
The amount of memory to allocate to the driver.

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

### -DynamicExecutorAllocationEnabled
Boolean flag to enable or disable dynamic executor allocation.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DynamicExecutorAllocationMaxExecutors
The maximum number of executors when dynamic allocation is enabled.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 11
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DynamicExecutorAllocationMinExecutors
The minimum number of executors when dynamic allocation is enabled.

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

### -EnvironmentId
The unique identifier of the environment where the Spark compute settings will be updated.

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

### -ExecutorCores
The number of cores to allocate to each executor.

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

### -ExecutorMemory
The amount of memory to allocate to each executor.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstancePoolName
The name of the instance pool to be used for Spark compute.

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

### -InstancePoolType
The type of instance pool (either 'Workspace' or 'Capacity').

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

### -RuntimeVersion
The Spark runtime version to use.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SparkProperties
A hashtable of additional Spark properties to configure.

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
The unique identifier of the workspace where the environment exists.

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
