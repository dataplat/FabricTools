---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricWorkspace
---

# Get-FabricWorkspace

## SYNOPSIS

Retrieves details of a Microsoft Fabric workspace by its ID or name.

## SYNTAX

### __AllParameterSets

```
Get-FabricWorkspace [[-WorkspaceId] <guid>] [[-WorkspaceName] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricWorkspace` function fetches workspace details from the Fabric API.
It supports filtering by WorkspaceId or WorkspaceName.

## EXAMPLES

### EXAMPLE 1

Fetches details of the workspace with ID "workspace123".

```powershell
Get-FabricWorkspace -WorkspaceId "workspace123"
```

### EXAMPLE 2

Fetches details of the workspace with the name "MyWorkspace".

```powershell
Get-FabricWorkspace -WorkspaceName "MyWorkspace"
```

## PARAMETERS

### -WorkspaceId

The unique identifier of the workspace to retrieve.

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

### -WorkspaceName

The display name of the workspace to retrieve.

```yaml
Type: System.String
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
- Returns the matching workspace details or all workspaces if no filter is provided.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

