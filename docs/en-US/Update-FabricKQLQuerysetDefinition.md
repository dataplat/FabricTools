---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Update-FabricKQLQuerysetDefinition
---

# Update-FabricKQLQuerysetDefinition

## SYNOPSIS

Updates the definition of a KQLQueryset in a Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Update-FabricKQLQuerysetDefinition [-WorkspaceId] <guid> [-KQLQuerysetId] <guid>
 [-KQLQuerysetPathDefinition] <string> [[-KQLQuerysetPathPlatformDefinition] <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function allows updating the content or metadata of a KQLQueryset in a Microsoft Fabric workspace.
The KQLQueryset content can be provided as file paths, and metadata updates can optionally be enabled.

## EXAMPLES

### EXAMPLE 1

Updates the content of the KQLQueryset with ID `67890` in the workspace `12345` using the specified KQLQueryset file.

```powershell
Update-FabricKQLQuerysetDefinition -WorkspaceId "12345" -KQLQuerysetId "67890" -KQLQuerysetPathDefinition "C:\KQLQuerysets\KQLQueryset.ipynb"
```

### EXAMPLE 2

Updates both the content and metadata of the KQLQueryset with ID `67890` in the workspace `12345`.

```powershell
Update-FabricKQLQuerysetDefinition -WorkspaceId "12345" -KQLQuerysetId "67890" -KQLQuerysetPathDefinition "C:\KQLQuerysets\KQLQueryset.ipynb"
```

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

### -KQLQuerysetId

(Mandatory) The unique identifier of the KQLQueryset to be updated.

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

### -KQLQuerysetPathDefinition

(Mandatory) The file path to the KQLQueryset content definition file.
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

### -KQLQuerysetPathPlatformDefinition

(Optional) The file path to the KQLQueryset's platform-specific definition file.
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

(Mandatory) The unique identifier of the workspace where the KQLQueryset resides.

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
- The KQLQueryset content is encoded as Base64 before being sent to the Fabric API.
- This function handles asynchronous operations and retrieves operation results if required.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

