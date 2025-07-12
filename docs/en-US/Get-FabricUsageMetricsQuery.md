---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricUsageMetricsQuery
---

# Get-FabricUsageMetricsQuery

## SYNOPSIS

Retrieves usage metrics for a specific dataset.

## SYNTAX

### __AllParameterSets

```
Get-FabricUsageMetricsQuery [-DatasetID] <guid> [-groupId] <guid> [-reportname] <Object>
 [[-ImpersonatedUser] <string>] [<CommonParameters>]
```

## ALIASES

Get-FabUsageMetricsQuery

## DESCRIPTION

The Get-FabricUsageMetricsQuery function retrieves usage metrics for a specific dataset.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1

Get-FabricUsageMetricsQuery -DatasetID "your-dataset-id" -groupId "your-group-id" -reportname "your-report-name" -token "your-token"

This example retrieves the usage metrics for a specific dataset given the dataset ID, group ID, report name, and token.

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

### -groupId

The ID of the group.
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

### -ImpersonatedUser

The name of the impersonated user.
This is an optional parameter.

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

### -reportname

The name of the report.
This is a mandatory parameter.

```yaml
Type: System.Object
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

The function defines the headers and body for a POST request to the PowerBI API to retrieve the usage metrics for the specified dataset.
It then makes the POST request and returns the response.

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

