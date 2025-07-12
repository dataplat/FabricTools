---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: New-FabricWorkspaceUsageMetricsReport
---

# New-FabricWorkspaceUsageMetricsReport

## SYNOPSIS

Retrieves the workspace usage metrics dataset ID.

## SYNTAX

### __AllParameterSets

```
New-FabricWorkspaceUsageMetricsReport [-WorkspaceId] <guid> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

New-FabWorkspaceUsageMetricsReport

## DESCRIPTION

The New-FabricWorkspaceUsageMetricsReport function retrieves the workspace usage metrics dataset ID.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1

This example retrieves the workspace usage metrics dataset ID for a specific workspace given the workspace ID.

```powershell
New-FabricWorkspaceUsageMetricsReport -workspaceId "your-workspace-id"
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

The function retrieves the PowerBI access token and the Fabric API cluster URI.
It then makes a GET request to the Fabric API to retrieve the workspace usage metrics dataset ID, parses the response and replaces certain keys to match the expected format, and returns the 'dbName' property of the first model in the response, which is the dataset ID.

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

