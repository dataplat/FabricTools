---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricDeploymentPipelineStageItem
---

# Get-FabricDeploymentPipelineStageItem

## SYNOPSIS

Retrieves the supported items from the workspace assigned to a specific stage of a deployment pipeline.

## SYNTAX

### __AllParameterSets

```
Get-FabricDeploymentPipelineStageItem [-DeploymentPipelineId] <guid> [-StageId] <guid>
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricDeploymentPipelineStageItem` function returns a list of supported items from the workspace
assigned to the specified stage of a deployment pipeline.
The function automatically handles pagination
and returns all available items.

## EXAMPLES

### EXAMPLE 1

Retrieves all items from the specified stage of the deployment pipeline.

```powershell
Get-FabricDeploymentPipelineStageItem -DeploymentPipelineId "GUID-GUID-GUID-GUID" -StageId "GUID-GUID-GUID-GUID"
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

Required.
The ID of the stage to retrieve items from.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
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

{{ Fill in the related links here }}

