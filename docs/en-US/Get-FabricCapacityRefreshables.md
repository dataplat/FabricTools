---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricCapacityRefreshables
---

# Get-FabricCapacityRefreshables

## SYNOPSIS

Retrieves the top refreshable capacities for the tenant.

## SYNTAX

### __AllParameterSets

```
Get-FabricCapacityRefreshables [[-top] <string>] [<CommonParameters>]
```

## ALIASES

Get-FabCapacityRefreshables

## DESCRIPTION

The Get-FabricCapacityRefreshables function retrieves the top refreshable capacities for the tenant.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1

This example retrieves the top 5 refreshable capacities for the tenant.

```powershell
Get-FabricCapacityRefreshables -top 5
```

## PARAMETERS

### -top

The number of top refreshable capacities to retrieve.
This is a mandatory parameter.

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

The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the top refreshable capacities.
It then returns the 'value' property of the response, which contains the capacities.

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

