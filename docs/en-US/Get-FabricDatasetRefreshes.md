---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricDatasetRefreshes
---

# Get-FabricDatasetRefreshes

## SYNOPSIS

Retrieves the refresh history of a specified dataset in a PowerBI workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricDatasetRefreshes [-DatasetID] <guid> [-workspaceId] <guid> [<CommonParameters>]
```

## ALIASES

Get-FabDatasetRefreshes

## DESCRIPTION

The Get-FabricDatasetRefreshes function uses the PowerBI cmdlets to retrieve the refresh history of a specified dataset in a workspace.
It uses the dataset ID and workspace ID to get the dataset and checks if it is refreshable.
If it is, the function retrieves the refresh history.

## EXAMPLES

### EXAMPLE 1

This command retrieves the refresh history of the specified dataset in the specified workspace.

```powershell
Get-FabricDatasetRefreshes -DatasetID "12345678-90ab-cdef-1234-567890abcdef" -workspaceId "abcdef12-3456-7890-abcd-ef1234567890"
```

## PARAMETERS

### -DatasetID

The ID of the dataset.
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

### -workspaceId

The ID of the workspace.
This is a mandatory parameter.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String. You can pipe two strings that contain the dataset ID and workspace ID to Get-FabricDatasetRefreshes.

{{ Fill in the Description }}

## OUTPUTS

### Object. Get-FabricDatasetRefreshes returns an object that contains the refresh history.

{{ Fill in the Description }}

## NOTES

Alias: Get-PowerBIDatasetRefreshes, Get-FabDatasetRefreshes

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}
