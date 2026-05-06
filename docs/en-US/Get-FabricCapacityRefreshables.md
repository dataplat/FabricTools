---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 04/08/2026
PlatyPS schema version: 2024-05-01
title: Get-FabricCapacityRefreshables
---

# Get-FabricCapacityRefreshables

## SYNOPSIS

Returns a list of refreshables for all capacities that the user has access to.

## SYNTAX

### __AllParameterSets

```
Get-FabricCapacityRefreshables [[-top] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Get-FabricCapacityRefreshables function returns refreshables (datasets with refresh activity)
for all capacities the user has access to.
Power BI retains a seven-day refresh history for each
dataset, up to a maximum of 60 refreshes.

Requires scope: Capacity.Read.All or Capacity.ReadWrite.All

## EXAMPLES

### EXAMPLE 1

Retrieves the top 10 refreshables across all capacities.

```powershell
Get-FabricCapacityRefreshables -top 10
```

### EXAMPLE 2

Retrieves the top 5 refreshables with capacity details expanded.

```powershell
Get-FabricCapacityRefreshables -top 5 -expand 'capacity'
```

## PARAMETERS

### -top

Required.
Returns only the first n results.
Must be a positive integer (minimum: 1).

```yaml
Type: System.String
DefaultValue: 5
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
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

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

