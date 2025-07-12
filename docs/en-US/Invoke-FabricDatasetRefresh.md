---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Invoke-FabricDatasetRefresh
---

# Invoke-FabricDatasetRefresh

## SYNOPSIS

This function invokes a refresh of a PowerBI dataset

## SYNTAX

### DatasetId

```
Invoke-FabricDatasetRefresh -DatasetID <guid> [<CommonParameters>]
```

## ALIASES

Invoke-FabDatasetRefresh

## DESCRIPTION

The Invoke-FabricDatasetRefresh function is used to refresh a PowerBI dataset.
It first checks if the dataset is refreshable.
If it is not, it writes an error.
If it is, it invokes a PowerBI REST method to refresh the dataset.
The URL for the request is constructed using the provided  dataset ID.

## EXAMPLES

### EXAMPLE 1

Invoke-FabricDatasetRefresh  -DatasetID "12345678-1234-1234-1234-123456789012"

This command invokes a refresh of the dataset with the ID "12345678-1234-1234-1234-123456789012"

## PARAMETERS

### -DatasetID

A mandatory parameter that specifies the dataset ID.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatasetId
  Position: Named
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

Alias: Invoke-FabDatasetRefresh

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

