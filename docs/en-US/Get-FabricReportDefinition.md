---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricReportDefinition
---

# Get-FabricReportDefinition

## SYNOPSIS

Retrieves the definition of an Report from a specified Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricReportDefinition [-WorkspaceId] <guid> [[-ReportId] <guid>] [[-ReportFormat] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function retrieves the definition of an Report from a specified workspace using the provided ReportId.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1

This example retrieves the definition of the Report with ID "Report-67890" in the workspace with ID "workspace-12345".

```powershell
Get-FabricReportDefinition -WorkspaceId "workspace-12345" -ReportId "Report-67890"
```

### EXAMPLE 2

This example retrieves the definition of the Report with ID "Report-67890" in the workspace with ID "workspace-12345" in JSON format.

```powershell
Get-FabricReportDefinition -WorkspaceId "workspace-12345" -ReportId "Report-67890" -ReportFormat "json"
```

## PARAMETERS

### -ReportFormat

The format in which to retrieve the Report definition.
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

### -ReportId

The unique identifier of the Report to retrieve the definition for.
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

The unique identifier of the workspace where the Report exists.
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

