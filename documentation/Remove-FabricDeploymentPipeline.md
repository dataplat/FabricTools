---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Remove-FabricDeploymentPipeline

## SYNOPSIS
Deletes a specified deployment pipeline.

## SYNTAX

```
Remove-FabricDeploymentPipeline [-DeploymentPipelineId] <Guid> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The \`Remove-FabricDeploymentPipeline\` function deletes a deployment pipeline by its ID.
This operation requires admin deployment pipelines role and will fail if there's an active deployment operation.

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricDeploymentPipeline -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824"
```

Deletes the specified deployment pipeline.

## PARAMETERS

### -DeploymentPipelineId
Required.
The ID of the deployment pipeline to delete.

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
- Operation will fail if there's an active deployment operation.

Author: Kamil Nowinski

## RELATED LINKS
