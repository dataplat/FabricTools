---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricDeploymentPipelineOperation

## SYNOPSIS
Retrieves details of a specific deployment pipeline operation.

## SYNTAX

```
Get-FabricDeploymentPipelineOperation [-DeploymentPipelineId] <Guid> [-OperationId] <Guid>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricDeploymentPipelineOperation\` function fetches detailed information about a specific deployment operation
performed on a deployment pipeline, including the deployment execution plan, status, and timing information.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDeploymentPipelineOperation -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -OperationId "1065e6a3-a020-4c0c-ada7-92b5fe99eec5"
```

Retrieves details of a specific deployment operation, including its execution plan and status.

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

### -OperationId
Required.
The ID of the operation to retrieve.

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
- Returns detailed operation information including:
  - Operation status and type
  - Execution timing
  - Source and target stage information
  - Deployment execution plan with steps
  - Pre-deployment diff information
  - Performed by information
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scopes.

Author: Kamil Nowinski

## RELATED LINKS
