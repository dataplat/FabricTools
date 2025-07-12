---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricEnvironmentSparkCompute
---

# Get-FabricEnvironmentSparkCompute

## SYNOPSIS

Retrieves the Spark compute details for a specific environment in a Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricEnvironmentSparkCompute [-WorkspaceId] <guid> [-EnvironmentId] <guid> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Get-FabricEnvironmentSparkCompute function communicates with the Microsoft Fabric API to fetch information
about Spark compute resources associated with a specified environment.
It ensures that the API token is valid
and gracefully handles errors during the API call.

## EXAMPLES

### EXAMPLE 1

Get-FabricEnvironmentSparkCompute -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"

Retrieves Spark compute details for the specified environment in the given workspace.

## PARAMETERS

### -EnvironmentId

The unique identifier of the environment whose Spark compute details are being retrieved.

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

The unique identifier of the workspace containing the target environment.

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

- Requires the `$FabricConfig` global object, including `BaseUrl` and `FabricHeaders`.
- Uses `Confirm-TokenState` to validate the token before making API calls.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

