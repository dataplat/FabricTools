---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Update-FabricCopyJobDefinition
---

# Update-FabricCopyJobDefinition

## SYNOPSIS

Updates the definition of a Copy Job in a Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Update-FabricCopyJobDefinition [-WorkspaceId] <guid> [-CopyJobId] <guid>
 [-CopyJobPathDefinition] <string> [[-CopyJobPathPlatformDefinition] <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function updates the content or metadata of a Copy Job within a Microsoft Fabric workspace.
The Copy Job content and platform-specific definitions can be provided as file paths, which will be encoded as Base64 and sent in the request.

## EXAMPLES

### EXAMPLE 1

Update-FabricCopyJobDefinition -WorkspaceId "12345" -CopyJobId "67890" -CopyJobPathDefinition "C:\CopyJobs\CopyJob.ipynb"

Updates the content of the Copy Job with ID `67890` in the workspace `12345` using the specified Copy Job file.

### EXAMPLE 2

Update-FabricCopyJobDefinition -WorkspaceId "12345" -CopyJobId "67890" -CopyJobPathDefinition "C:\CopyJobs\CopyJob.ipynb" -CopyJobPathPlatformDefinition "C:\CopyJobs\Platform.json"

Updates both the content and platform-specific definition of the Copy Job with ID `67890` in the workspace `12345`.

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

### -CopyJobId

(Mandatory) The unique identifier of the Copy Job to be updated.

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

### -CopyJobPathDefinition

(Mandatory) The file path to the Copy Job content definition file.
The file content will be encoded as Base64.

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

### -CopyJobPathPlatformDefinition

(Optional) The file path to the platform-specific definition file for the Copy Job.
The file content will be encoded as Base64.

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

(Mandatory) The unique identifier of the workspace containing the Copy Job.

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

- Requires the `$FabricConfig` global configuration, which must include `BaseUrl` and `FabricHeaders`.
- Validates token expiration using `Confirm-TokenState` before making the API request.
- Encodes file content as Base64 before sending it to the Fabric API.
- Logs detailed messages for debugging and error handling.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

