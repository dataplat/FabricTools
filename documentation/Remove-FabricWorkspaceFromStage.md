---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Remove-FabricWorkspaceFromStage

## SYNOPSIS
Removes a workspace from a deployment pipeline stage.

## SYNTAX

```
Remove-FabricWorkspaceFromStage [-DeploymentPipelineId] <Guid> [-StageId] <Guid>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The \`Remove-FabricWorkspaceFromStage\` function removes the workspace from the specified stage in the specified deployment pipeline.
This operation will fail if there's an active deployment operation.

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricWorkspaceFromStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -StageId "db1577e0-0132-4d6d-92b9-952c359988f2"
```

Removes the workspace from the specified deployment pipeline stage.

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

### -StageId
Required.
The ID of the deployment pipeline stage.

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
- Requires Pipeline.ReadWrite.All delegated scope.
- Requires admin deployment pipelines role.
- This operation will fail if there's an active deployment operation.
- This API is in preview.

Author: Kamil Nowinski

## RELATED LINKS
