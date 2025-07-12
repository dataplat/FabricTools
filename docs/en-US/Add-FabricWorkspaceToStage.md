---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Add-FabricWorkspaceToStage
---

# Add-FabricWorkspaceToStage

## SYNOPSIS

Assigns a workspace to a deployment pipeline stage.

## SYNTAX

### __AllParameterSets

```
Add-FabricWorkspaceToStage [-DeploymentPipelineId] <guid> [-StageId] <guid> [-WorkspaceId] <guid>
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Add-FabricWorkspaceToStage` function assigns the specified workspace to the specified deployment pipeline stage.
This operation will fail if there's an active deployment operation.

## EXAMPLES

### EXAMPLE 1

Add-FabricWorkspaceToStage -DeploymentPipelineId "GUID-GUID-GUID-GUID" -StageId "GUID-GUID-GUID-GUID" -WorkspaceId "GUID-GUID-GUID-GUID"

Assigns the specified workspace to the deployment pipeline stage.

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
The ID of the deployment pipeline stage.

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

### -WorkspaceId

Required.
The ID of the workspace to assign to the stage.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

- Calls `Confirm-TokenState` to ensure token validity before making the API request.
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

{{ Fill in the related links here }}

