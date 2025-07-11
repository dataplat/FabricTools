---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Start-FabricSparkJobDefinitionOnDemand

## SYNOPSIS
Starts a Fabric Spark Job Definition on demand.

## SYNTAX

```
Start-FabricSparkJobDefinitionOnDemand [-WorkspaceId] <Guid> [-SparkJobDefinitionId] <Guid>
 [[-JobType] <String>] [[-waitForCompletion] <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function initiates a Spark Job Definition on demand within a specified workspace.
It constructs the appropriate API endpoint URL and makes a POST request to start the job.
The function can optionally wait for the job to complete based on the 'waitForCompletion' parameter.

## EXAMPLES

### EXAMPLE 1
```
Start-FabricSparkJobDefinitionOnDemand -WorkspaceId "workspace123" -SparkJobDefinitionId "jobdef456" -waitForCompletion $true
```

## PARAMETERS

### -JobType
The type of job to be started.
The default value is 'sparkjob'.
This parameter is optional.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Sparkjob
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

### -SparkJobDefinitionId
The ID of the Spark Job Definition to be started.
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

### -waitForCompletion
A boolean flag indicating whether to wait for the job to complete.
The default value is $false.
This parameter is optional.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
The ID of the workspace where the Spark Job Definition is located.
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
Ensure that the necessary authentication tokens are valid before running this function.
The function logs detailed messages for debugging and informational purposes.

Author: Tiago Balabuch

## RELATED LINKS
