---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Start-FabricDeploymentPipelineStage
---

# Start-FabricDeploymentPipelineStage

## SYNOPSIS

Deploys items from one stage to another in a deployment pipeline.

## SYNTAX

### __AllParameterSets

```
Start-FabricDeploymentPipelineStage [-DeploymentPipelineId] <guid> [-SourceStageId] <guid>
 [-TargetStageId] <guid> [[-Items] <array>] [[-Note] <string>] [-NoWait] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Start-FabricDeploymentPipelineStage` function deploys items from the specified source stage to the target stage.
This API supports long running operations (LRO) and will return an operation ID that can be used to track the deployment status.

## EXAMPLES

### EXAMPLE 1

This example deploys items from the source stage to the target stage in the specified deployment pipeline.

```powershell
Start-FabricDeploymentPipelineStage -DeploymentPipelineId "12345678-1234-1234-1234-1234567890AB" -SourceStageId "23456789-2345-2345-2345-2345678901BC" -TargetStageId "34567890-3456-3456-3456-3456789012CD" -Items @(@{sourceItemId="45678901-4567-4567-4567-4567890123EF"; itemType="Report"})
```

### EXAMPLE 2

This example deploys all items from the source stage to the target stage in the specified deployment pipeline without waiting for completion.

```powershell
Start-FabricDeploymentPipelineStage -DeploymentPipelineId "12345678-1234-1234-1234-1234567890AB" -SourceStageId "23456789-2345-2345-2345-2345678901BC" -TargetStageId "34567890-3456-3456-3456-3456789012CD" -NoWait
```

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

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

### -Items

Optional.
A list of items to be deployed.
If not specified, all supported stage items are deployed.
Each item should be a hashtable with:
- sourceItemId: The ID of the item to deploy
- itemType: The type of the item (e.g., "Report", "Dashboard", "Datamart", "SemanticModel")

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Note

Optional.
A note describing the deployment.
Limited to 1024 characters.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoWait

Optional.
If specified, the function will not wait for the deployment to complete and will return immediately.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SourceStageId

Required.
The ID of the source stage to deploy from.

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

### -TargetStageId

Required.
The ID of the target stage to deploy to.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Tells PowerShell to run the command in a mode that only reports what would happen, but not actually let the command run or make changes.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
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
- Requires Pipeline.Deploy delegated scope.
- Requires admin deployment pipelines role.
- Requires contributor or higher role on both source and target workspaces.
- Maximum 300 deployed items per request.
- This API is in preview.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

