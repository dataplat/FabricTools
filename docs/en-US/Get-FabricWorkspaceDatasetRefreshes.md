---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricWorkspaceDatasetRefreshes
---

# Get-FabricWorkspaceDatasetRefreshes

## SYNOPSIS

Retrieves the refresh history of all datasets in a specified PowerBI workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricWorkspaceDatasetRefreshes [-WorkspaceID] <guid> [<CommonParameters>]
```

## ALIASES

Get-FabWorkspaceDatasetRefreshes

## DESCRIPTION

The Get-FabricWorkspaceDatasetRefreshes function uses the PowerBI cmdlets to retrieve the refresh history of all datasets in a specified workspace.
It uses the workspace ID to get the workspace and its datasets, and then retrieves the refresh history for each dataset.

## EXAMPLES

### EXAMPLE 1

This command retrieves the refresh history of all datasets in the workspace with the specified ID. .INPUTS String. You can pipe a string that contains the workspace ID to Get-FabricWorkspaceDatasetRefreshes.

```powershell
Get-FabricWorkspaceDatasetRefreshes -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef"
```

## PARAMETERS

### -WorkspaceID

The ID of the PowerBI workspace.
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

### Array. Get-FabricWorkspaceDatasetRefreshes returns an array of refresh history objects.

{{ Fill in the Description }}

## NOTES

Alias: Get-PowerBIWorkspaceDatasetRefreshes, Get-FabWorkspaceDatasetRefreshes

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

