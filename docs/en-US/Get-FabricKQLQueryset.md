---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricKQLQueryset
---

# Get-FabricKQLQueryset

## SYNOPSIS

Retrieves an KQLQueryset or a list of KQLQuerysets from a specified workspace in Microsoft Fabric.

## SYNTAX

### __AllParameterSets

```
Get-FabricKQLQueryset [-WorkspaceId] <guid> [[-KQLQuerysetId] <guid>] [[-KQLQuerysetName] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricKQLQueryset` function sends a GET request to the Fabric API to retrieve KQLQueryset details for a given workspace.
It can filter the results by `KQLQuerysetName`.

## EXAMPLES

### EXAMPLE 1

Get-FabricKQLQueryset -WorkspaceId "12345" -KQLQuerysetName "Development"

Retrieves the "Development" KQLQueryset from workspace "12345".

### EXAMPLE 2

Get-FabricKQLQueryset -WorkspaceId "12345"

Retrieves all KQLQuerysets in workspace "12345".

## PARAMETERS

### -KQLQuerysetId

(Optional) The ID of a specific KQLQueryset to retrieve.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -KQLQuerysetName

(Optional) The name of the specific KQLQueryset to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WorkspaceId

(Mandatory) The ID of the workspace to query KQLQuerysets.

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

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

