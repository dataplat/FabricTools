---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricDeploymentPipelineRoleAssignments

## SYNOPSIS
Returns a list of deployment pipeline role assignments.

## SYNTAX

```
Get-FabricDeploymentPipelineRoleAssignments [-DeploymentPipelineId] <Guid> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricDeploymentPipelineRoleAssignments\` function retrieves a list of role assignments for a deployment pipeline.
The function automatically handles pagination and returns all available role assignments.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDeploymentPipelineRoleAssignments -DeploymentPipelineId "8ce96c50-85a0-4db3-85c6-7ccc3ed46523"
```

Returns all role assignments for the specified deployment pipeline.

## PARAMETERS

### -DeploymentPipelineId
Required.
The ID of the deployment pipeline to get role assignments for.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scope.
- Requires admin deployment pipelines role.
- This API is in preview.

Author: Kamil Nowinski

## RELATED LINKS
