---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Import-FabricEnvironmentStagingLibrary
---

# Import-FabricEnvironmentStagingLibrary

## SYNOPSIS

Uploads a library to the staging environment in a Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Import-FabricEnvironmentStagingLibrary [-WorkspaceId] <guid> [-EnvironmentId] <guid>
 [<CommonParameters>]
```

## ALIASES

Upload-FabricEnvironmentStagingLibrary

## DESCRIPTION

This function sends a POST request to the Microsoft Fabric API to upload a library to the specified
environment staging area for the given workspace.

## EXAMPLES

### EXAMPLE 1

```powershell
Import-FabricEnvironmentStagingLibrary -WorkspaceId "workspace-12345" -EnvironmentId "env-67890"
```

## PARAMETERS

### -EnvironmentId

The unique identifier of the environment where the library will be uploaded.

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

The unique identifier of the workspace where the environment exists.

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

- This is not working code.
It is a placeholder for future development.
Fabric documentation is missing some important details on how to upload libraries.
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

