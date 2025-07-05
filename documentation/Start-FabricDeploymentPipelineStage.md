---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Start-FabricDeploymentPipelineStage

## SYNOPSIS
Deploys items from one stage to another in a deployment pipeline.

## SYNTAX

```
Start-FabricDeploymentPipelineStage [-DeploymentPipelineId] <Guid> [-SourceStageId] <Guid>
 [-TargetStageId] <Guid> [[-Items] <Array>] [[-Note] <String>] [-NoWait] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The \`Start-FabricDeploymentPipelineStage\` function deploys items from the specified source stage to the target stage.
This API supports long running operations (LRO) and will return an operation ID that can be used to track the deployment status.

## EXAMPLES

### EXAMPLE 1
```
Start-FabricDeploymentPipelineStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -SourceStageId "db1577e0-0132-4d6d-92b9-952c359988f2" -TargetStageId "f1c39546-6282-4590-8af3-847a6226ad16" -Note "Deploying business ready items"
```

Deploys all supported items from the source stage to the target stage.

### EXAMPLE 2
```
$items = @(
    @{
        sourceItemId = "6bfe235c-6d7b-41b7-98a6-2b8276b3e82b"
        itemType = "Datamart"
    },
    @{
        sourceItemId = "1a201f2a-d1d8-45c0-8c61-1676338517de"
        itemType = "SemanticModel"
    }
)
Start-FabricDeploymentPipelineStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -SourceStageId "db1577e0-0132-4d6d-92b9-952c359988f2" -TargetStageId "f1c39546-6282-4590-8af3-847a6226ad16" -Items $items -Note "Deploying specific items"
```

Deploys specific items from the source stage to the target stage.

## PARAMETERS

### -DeploymentPipelineId
Required.
The ID of the deployment pipeline.

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

### -Items
Optional.
A list of items to be deployed.
If not specified, all supported stage items are deployed.
Each item should be a hashtable with:
- sourceItemId: The ID of the item to deploy
- itemType: The type of the item (e.g., "Report", "Dashboard", "Datamart", "SemanticModel")

```yaml
Type: System.Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Note
Optional.
A note describing the deployment.
Limited to 1024 characters.

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

### -NoWait
Optional.
If specified, the function will not wait for the deployment to complete and will return immediately.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### -SourceStageId
Required.
The ID of the source stage to deploy from.

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

### -TargetStageId
Required.
The ID of the target stage to deploy to.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.
- Requires Pipeline.Deploy delegated scope.
- Requires admin deployment pipelines role.
- Requires contributor or higher role on both source and target workspaces.
- Maximum 300 deployed items per request.
- This API is in preview.

Author: Kamil Nowinski

## RELATED LINKS
