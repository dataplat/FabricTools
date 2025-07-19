---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricDeploymentPipeline
---

# Get-FabricDeploymentPipeline

## SYNOPSIS

Retrieves deployment pipeline(s) from Microsoft Fabric.

## SYNTAX

### __AllParameterSets

```
Get-FabricDeploymentPipeline [[-DeploymentPipelineId] <guid>] [[-DeploymentPipelineName] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricDeploymentPipeline` function fetches deployment pipeline(s) from the Fabric API.
It can either retrieve all pipelines or a specific pipeline by ID.
It automatically handles pagination when retrieving all pipelines.

## EXAMPLES

### EXAMPLE 1

Retrieves all deployment pipelines that the user can access.

```powershell
Get-FabricDeploymentPipeline
```

### EXAMPLE 2

Retrieves a specific deployment pipeline with detailed information including its stages.

```powershell
Get-FabricDeploymentPipeline -DeploymentPipelineId "GUID-GUID-GUID-GUID"
```

## PARAMETERS

### -DeploymentPipelineId

Optional.
The ID of a specific deployment pipeline to retrieve.
If not provided, all pipelines will be retrieved.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeploymentPipelineName

Optional.
The display name of a specific deployment pipeline to retrieve.
If provided, it will filter the results to match this name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Name
- DisplayName
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
- Returns a collection of deployment pipelines with their IDs, display names, and descriptions.
- When retrieving a specific pipeline, returns extended information including stages.
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scopes.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

