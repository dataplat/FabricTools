---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricDeploymentPipelineStage

## SYNOPSIS
Retrieves details of deployment pipeline stages.

## SYNTAX

```
Get-FabricDeploymentPipelineStage [-DeploymentPipelineId] <Guid> [[-StageId] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricDeploymentPipelineStage\` function fetches information about stages in a deployment pipeline.
When a StageId is provided, it returns details for that specific stage.
When no StageId is provided,
it returns a list of all stages in the pipeline.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDeploymentPipelineStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -StageId "2e6f0272-e809-410a-be63-50e1d97ba75a"
```

Retrieves details of a specific deployment pipeline stage, including its workspace assignment and settings.

### EXAMPLE 2
```
Get-FabricDeploymentPipelineStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824"
```

Retrieves a list of all stages in the specified deployment pipeline.

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
Optional.
The ID of the specific stage to retrieve.
If not provided, returns all stages in the pipeline.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
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
- Returns detailed stage information including:
  - Stage ID and display name
  - Description
  - Order in the pipeline
  - Workspace assignment (if any)
  - Public/private visibility setting
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scopes.

Author: Kamil Nowinski

## RELATED LINKS
