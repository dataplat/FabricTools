---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Update-FabricKQLDashboardDefinition
---

# Update-FabricKQLDashboardDefinition

## SYNOPSIS

Updates the definition of a KQLDashboard in a Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Update-FabricKQLDashboardDefinition [-WorkspaceId] <guid> [-KQLDashboardId] <guid>
 [-KQLDashboardPathDefinition] <string> [[-KQLDashboardPathPlatformDefinition] <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function allows updating the content or metadata of a KQLDashboard in a Microsoft Fabric workspace.
The KQLDashboard content can be provided as file paths, and metadata updates can optionally be enabled.

## EXAMPLES

### EXAMPLE 1

Updates the content of the KQLDashboard with ID `67890` in the workspace `12345` using the specified KQLDashboard file.

```powershell
Update-FabricKQLDashboardDefinition -WorkspaceId "12345" -KQLDashboardId "67890" -KQLDashboardPathDefinition "C:\KQLDashboards\KQLDashboard.ipynb"
```

### EXAMPLE 2

Updates both the content and metadata of the KQLDashboard with ID `67890` in the workspace `12345`.

```powershell
Update-FabricKQLDashboardDefinition -WorkspaceId "12345" -KQLDashboardId "67890" -KQLDashboardPathDefinition "C:\KQLDashboards\KQLDashboard.ipynb"
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

### -KQLDashboardId

(Mandatory) The unique identifier of the KQLDashboard to be updated.

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

### -KQLDashboardPathDefinition

(Mandatory) The file path to the KQLDashboard content definition file.
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

### -KQLDashboardPathPlatformDefinition

(Optional) The file path to the KQLDashboard's platform-specific definition file.
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

(Mandatory) The unique identifier of the workspace where the KQLDashboard resides.

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
- The KQLDashboard content is encoded as Base64 before being sent to the Fabric API.
- This function handles asynchronous operations and retrieves operation results if required.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

