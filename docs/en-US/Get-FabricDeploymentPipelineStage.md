---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricDeploymentPipelineStage
---

# Get-FabricDeploymentPipelineStage

## SYNOPSIS

Retrieves details of deployment pipeline stages.

## SYNTAX

### __AllParameterSets

```
Get-FabricDeploymentPipelineStage [-DeploymentPipelineId] <guid> [[-StageId] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricDeploymentPipelineStage` function fetches information about stages in a deployment pipeline.
When a StageId is provided, it returns details for that specific stage.
When no StageId is provided,
it returns a list of all stages in the pipeline.

## EXAMPLES

### EXAMPLE 1

Retrieves details of a specific deployment pipeline stage, including its workspace assignment and settings.

```powershell
Get-FabricDeploymentPipelineStage -DeploymentPipelineId "GUID-GUID-GUID-GUID" -StageId "GUID-GUID-GUID-GUID"
```

### EXAMPLE 2

Retrieves a list of all stages in the specified deployment pipeline.

```powershell
Get-FabricDeploymentPipelineStage -DeploymentPipelineId "GUID-GUID-GUID-GUID"
```

## PARAMETERS

### -DeploymentPipelineId

Required.
The ID of the deployment pipeline.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StageId

Optional.
The ID of the specific stage to retrieve.
If not provided, returns all stages in the pipeline.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Returns detailed stage information including:
  - Stage ID and display name
  - Description
  - Order in the pipeline
  - Workspace assignment (if any)
  - Public/private visibility setting
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scopes.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

