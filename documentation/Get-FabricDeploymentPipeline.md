---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricDeploymentPipeline

## SYNOPSIS
Retrieves deployment pipeline(s) from Microsoft Fabric.

## SYNTAX

```
Get-FabricDeploymentPipeline [[-DeploymentPipelineId] <Guid>] [[-DeploymentPipelineName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricDeploymentPipeline\` function fetches deployment pipeline(s) from the Fabric API.
It can either retrieve all pipelines or a specific pipeline by ID.
It automatically handles pagination when retrieving all pipelines.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDeploymentPipeline
```

Retrieves all deployment pipelines that the user can access.

### EXAMPLE 2
```
Get-FabricDeploymentPipeline -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824"
```

Retrieves a specific deployment pipeline with detailed information including its stages.

## PARAMETERS

### -DeploymentPipelineId
Optional.
The ID of a specific deployment pipeline to retrieve.
If not provided, all pipelines will be retrieved.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeploymentPipelineName
Optional.
The display name of a specific deployment pipeline to retrieve.
If provided, it will filter the results to match this name.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name, DisplayName

Required: False
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
- Returns a collection of deployment pipelines with their IDs, display names, and descriptions.
- When retrieving a specific pipeline, returns extended information including stages.
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scopes.

Author: Kamil Nowinski

## RELATED LINKS
