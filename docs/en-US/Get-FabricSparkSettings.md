---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricSparkSettings
---

# Get-FabricSparkSettings

## SYNOPSIS

Retrieves Spark settings from a specified Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricSparkSettings [-WorkspaceId] <guid> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function retrieves Spark settings from a specified workspace using the provided WorkspaceId.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1

Get-FabricSparkSettings -WorkspaceId "workspace-12345"
This example retrieves the Spark settings for the workspace with ID "workspace-12345".

## PARAMETERS

### -WorkspaceId

The unique identifier of the workspace from which to retrieve Spark settings.
This parameter is mandatory.

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

### System.Object

{{ Fill in the Description }}

## NOTES

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

