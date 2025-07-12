---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Add-FabricWorkspaceIdentity
---

# Add-FabricWorkspaceIdentity

## SYNOPSIS

Provisions an identity for a Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Add-FabricWorkspaceIdentity [-WorkspaceId] <guid> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Add-FabricWorkspaceIdentity` function provisions an identity for a specified workspace by making an API call.

## EXAMPLES

### EXAMPLE 1

Add-FabricWorkspaceIdentity -WorkspaceId "workspace123"

Provisions a Managed Identity for the workspace with ID "workspace123".

## PARAMETERS

### -WorkspaceId

The unique identifier of the workspace for which the identity will be provisioned.

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

