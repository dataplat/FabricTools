---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricDeploymentPipelineStageItem

## SYNOPSIS
Retrieves the supported items from the workspace assigned to a specific stage of a deployment pipeline.

## SYNTAX

```
Get-FabricDeploymentPipelineStageItem [-DeploymentPipelineId] <Guid> [-StageId] <Guid>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricDeploymentPipelineStageItem\` function returns a list of supported items from the workspace
assigned to the specified stage of a deployment pipeline.
The function automatically handles pagination
and returns all available items.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDeploymentPipelineStageItem -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -StageId "48d2f500-6375-4f17-9199-2e1d73c18486"
```

Retrieves all items from the specified stage of the deployment pipeline.

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
The ID of the stage to retrieve items from.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scope.
- Requires admin deployment pipelines role.
- The user must be at least a workspace contributor assigned to the specified stage.
- Returns items with their metadata including:
  - Item ID and display name
  - Item type (Report, Dashboard, SemanticModel, etc.)
  - Source and target item IDs (if applicable)
  - Last deployment time (if applicable)

Author: Kamil Nowinski

## RELATED LINKS
