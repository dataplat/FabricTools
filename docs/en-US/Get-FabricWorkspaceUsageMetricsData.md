---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricWorkspaceUsageMetricsData
---

# Get-FabricWorkspaceUsageMetricsData

## SYNOPSIS

Retrieves workspace usage metrics data.

## SYNTAX

### __AllParameterSets

```
Get-FabricWorkspaceUsageMetricsData [-WorkspaceId] <guid> [[-username] <string>]
 [<CommonParameters>]
```

## ALIASES

Get-FabWorkspaceUsageMetricsData

## DESCRIPTION

The Get-FabricWorkspaceUsageMetricsData function retrieves workspace usage metrics.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1

This example retrieves the workspace usage metrics for a specific workspace given the workspace ID and username.

```powershell
Get-FabricWorkspaceUsageMetricsData -workspaceId "your-workspace-id" -username "your-username"
```

## PARAMETERS

### -username

The username.
This is a mandatory parameter.

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

### -WorkspaceId

The ID of the workspace.
This is a mandatory parameter.

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

The function retrieves the PowerBI access token and creates a new usage metrics report.
It then defines the names of the reports to retrieve, initializes an empty hashtable to store the reports, and for each report name, retrieves the report and adds it to the hashtable.
It then returns the hashtable of reports.

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

