---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricEnvironmentStagingLibrary
---

# Get-FabricEnvironmentStagingLibrary

## SYNOPSIS

Retrieves the staging library details for a specific environment in a Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricEnvironmentStagingLibrary [-WorkspaceId] <guid> [-EnvironmentId] <guid>
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Get-FabricEnvironmentStagingLibrary function interacts with the Microsoft Fabric API to fetch information
about staging libraries associated with a specified environment.
It ensures token validity and handles API errors gracefully.

## EXAMPLES

### EXAMPLE 1

Get-FabricEnvironmentStagingLibrary -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"

Retrieves the staging libraries for the specified environment in the given workspace.

## PARAMETERS

### -EnvironmentId

The unique identifier of the environment for which staging library details are being retrieved.

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

