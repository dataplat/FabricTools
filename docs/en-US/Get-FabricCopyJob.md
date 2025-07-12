---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricCopyJob
---

# Get-FabricCopyJob

## SYNOPSIS

Retrieves CopyJob details from a specified Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricCopyJob [-WorkspaceId] <guid> [[-CopyJobId] <guid>] [[-CopyJob] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function retrieves CopyJob details from a specified workspace using either the provided CopyJobId or CopyJob.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1

This example retrieves the CopyJob details for the CopyJob with ID "CopyJob-67890" in the workspace with ID "workspace-12345".

```powershell
Get-FabricCopyJob -WorkspaceId "workspace-12345" -CopyJobId "CopyJob-67890"
```

### EXAMPLE 2

This example retrieves the CopyJob details for the CopyJob named "My CopyJob" in the workspace with ID "workspace-12345".

```powershell
Get-FabricCopyJob -WorkspaceId "workspace-12345" -CopyJob "My CopyJob"
```

## PARAMETERS

### -CopyJob

The name of the CopyJob to retrieve.
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

### -CopyJobId

The unique identifier of the CopyJob to retrieve.
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

### -WorkspaceId

The unique identifier of the workspace where the CopyJob exists.
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

Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

