---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Publish-FabricEnvironment
---

# Publish-FabricEnvironment

## SYNOPSIS

Publishes a staging environment in a specified Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Publish-FabricEnvironment [-WorkspaceId] <guid> [-EnvironmentId] <guid> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function interacts with the Microsoft Fabric API to initiate the publishing process for a staging environment.
It validates the authentication token, constructs the API request, and handles both immediate and long-running operations.

## EXAMPLES

### EXAMPLE 1

Publish-FabricEnvironment -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"

Initiates the publishing process for the specified staging environment.

## PARAMETERS

### -EnvironmentId

The unique identifier of the staging environment to be published.

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

The unique identifier of the workspace containing the staging environment.

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

