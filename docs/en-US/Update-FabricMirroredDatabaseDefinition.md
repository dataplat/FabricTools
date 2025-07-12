---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Update-FabricMirroredDatabaseDefinition
---

# Update-FabricMirroredDatabaseDefinition

## SYNOPSIS

Updates the definition of a MirroredDatabase in a Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Update-FabricMirroredDatabaseDefinition [-WorkspaceId] <guid> [-MirroredDatabaseId] <guid>
 [-MirroredDatabasePathDefinition] <string> [[-MirroredDatabasePathPlatformDefinition] <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function allows updating the content or metadata of a MirroredDatabase in a Microsoft Fabric workspace.
The MirroredDatabase content can be provided as file paths, and metadata updates can optionally be enabled.

## EXAMPLES

### EXAMPLE 1

Update-FabricMirroredDatabaseDefinition -WorkspaceId "12345" -MirroredDatabaseId "67890" -MirroredDatabasePathDefinition "C:\MirroredDatabases\MirroredDatabase.json"

Updates the content of the MirroredDatabase with ID `67890` in the workspace `12345` using the specified MirroredDatabase file.

### EXAMPLE 2

Update-FabricMirroredDatabaseDefinition -WorkspaceId "12345" -MirroredDatabaseId "67890" -MirroredDatabasePathDefinition "C:\MirroredDatabases\MirroredDatabase.json" -UpdateMetadata $true

Updates both the content and metadata of the MirroredDatabase with ID `67890` in the workspace `12345`.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MirroredDatabaseId

(Mandatory) The unique identifier of the MirroredDatabase to be updated.

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

### -MirroredDatabasePathDefinition

(Mandatory) The file path to the MirroredDatabase content definition file.
The content will be encoded as Base64 and sent in the request.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MirroredDatabasePathPlatformDefinition

(Optional) The file path to the MirroredDatabase's platform-specific definition file.
The content will be encoded as Base64 and sent in the request.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Tells PowerShell to run the command in a mode that only reports what would happen, but not actually let the command run or make changes.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WorkspaceId

(Mandatory) The unique identifier of the workspace where the MirroredDatabase resides.

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
- The MirroredDatabase content is encoded as Base64 before being sent to the Fabric API.
- This function handles asynchronous operations and retrieves operation results if required.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

