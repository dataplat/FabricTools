---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricSemanticModel
---

# Get-FabricSemanticModel

## SYNOPSIS

Retrieves SemanticModel details from a specified Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricSemanticModel [-WorkspaceId] <guid> [[-SemanticModelId] <guid>]
 [[-SemanticModelName] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function retrieves SemanticModel details from a specified workspace using either the provided SemanticModelId or SemanticModelName.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1

This example retrieves the SemanticModel details for the SemanticModel with ID "SemanticModel-67890" in the workspace with ID "workspace-12345".

```powershell
Get-FabricSemanticModel -WorkspaceId "workspace-12345" -SemanticModelId "SemanticModel-67890"
```

### EXAMPLE 2

This example retrieves the SemanticModel details for the SemanticModel named "My SemanticModel" in the workspace with ID "workspace-12345".

```powershell
Get-FabricSemanticModel -WorkspaceId "workspace-12345" -SemanticModelName "My SemanticModel"
```

## PARAMETERS

### -SemanticModelId

The unique identifier of the SemanticModel to retrieve.
This parameter is optional.

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

### -SemanticModelName

The name of the SemanticModel to retrieve.
This parameter is optional.

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

The unique identifier of the workspace where the SemanticModel exists.
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

## NOTES

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

