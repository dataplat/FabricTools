---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricDeploymentPipelineOperation
---

# Get-FabricDeploymentPipelineOperation

## SYNOPSIS

Retrieves details of a specific deployment pipeline operation.

## SYNTAX

### __AllParameterSets

```
Get-FabricDeploymentPipelineOperation [-DeploymentPipelineId] <guid> [-OperationId] <guid>
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricDeploymentPipelineOperation` function fetches detailed information about a specific deployment operation
performed on a deployment pipeline, including the deployment execution plan, status, and timing information.

## EXAMPLES

### EXAMPLE 1

Retrieves details of a specific deployment operation, including its execution plan and status.

```powershell
Get-FabricDeploymentPipelineOperation -DeploymentPipelineId "GUID-GUID-GUID-GUID" -OperationId "GUID-GUID-GUID-GUID"
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

### -OperationId

Required.
The ID of the operation to retrieve.

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

{{ Fill in the related links here }}

