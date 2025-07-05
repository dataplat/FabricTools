---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Add-FabricWorkspaceToStage

## SYNOPSIS
Assigns a workspace to a deployment pipeline stage.

## SYNTAX

```
Add-FabricWorkspaceToStage [-DeploymentPipelineId] <Guid> [-StageId] <Guid> [-WorkspaceId] <Guid>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Add-FabricWorkspaceToStage\` function assigns the specified workspace to the specified deployment pipeline stage.
This operation will fail if there's an active deployment operation.

## EXAMPLES

### EXAMPLE 1
```
Add-FabricWorkspaceToStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -StageId "db1577e0-0132-4d6d-92b9-952c359988f2" -WorkspaceId "4de5bcc4-2c88-4efe-b827-4ee7b289b496"
```

Assigns the specified workspace to the deployment pipeline stage.

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

### -WorkspaceId
Required.
The ID of the workspace to assign to the stage.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.
- Requires Pipeline.ReadWrite.All and Workspace.ReadWrite.All delegated scopes.
- Requires admin deployment pipelines role and admin workspace role.
- This operation will fail if:
  * There's an active deployment operation
  * The specified stage is already assigned to another workspace
  * The specified workspace is already assigned to another stage
  * The caller is not a workspace admin
- This API is in preview.

Author: Kamil Nowinski

## RELATED LINKS
