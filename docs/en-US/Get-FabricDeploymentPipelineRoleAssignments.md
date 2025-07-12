---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricDeploymentPipelineRoleAssignments
---

# Get-FabricDeploymentPipelineRoleAssignments

## SYNOPSIS

Returns a list of deployment pipeline role assignments.

## SYNTAX

### __AllParameterSets

```
Get-FabricDeploymentPipelineRoleAssignments [-DeploymentPipelineId] <guid> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricDeploymentPipelineRoleAssignments` function retrieves a list of role assignments for a deployment pipeline.
The function automatically handles pagination and returns all available role assignments.

## EXAMPLES

### EXAMPLE 1

Returns all role assignments for the specified deployment pipeline.

```powershell
Get-FabricDeploymentPipelineRoleAssignments -DeploymentPipelineId "GUID-GUID-GUID-GUID"
```

## PARAMETERS

### -DeploymentPipelineId

Required.
The ID of the deployment pipeline to get role assignments for.

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
- This API is in preview.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

