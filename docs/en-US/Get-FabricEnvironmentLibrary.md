---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricEnvironmentLibrary
---

# Get-FabricEnvironmentLibrary

## SYNOPSIS

Retrieves the list of libraries associated with a specific environment in a Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricEnvironmentLibrary [-WorkspaceId] <guid> [-EnvironmentId] <guid> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Get-FabricEnvironmentLibrary function fetches library information for a given workspace and environment
using the Microsoft Fabric API.
It ensures the authentication token is valid and validates the response
to handle errors gracefully.

## EXAMPLES

### EXAMPLE 1

Retrieves the libraries associated with the specified environment in the given workspace.

```powershell
Get-FabricEnvironmentLibrary -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"
```

## PARAMETERS

### -EnvironmentId

The unique identifier of the environment whose libraries are being queried.

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

(Mandatory) The unique identifier of the workspace where the environment is located.

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

