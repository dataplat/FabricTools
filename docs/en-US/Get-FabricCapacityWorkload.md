---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricCapacityWorkload
---

# Get-FabricCapacityWorkload

## SYNOPSIS

Retrieves the workloads for a specific capacity.

## SYNTAX

### __AllParameterSets

```
Get-FabricCapacityWorkload [-CapacityId] <guid> [<CommonParameters>]
```

## ALIASES

Get-FabCapacityWorkload

## DESCRIPTION

The Get-FabricCapacityWorkload function retrieves the workloads for a specific capacity.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1

This example retrieves the workloads for a specific capacity given the capacity ID and authentication token.

```powershell
Get-FabricCapacityWorkload -capacityID "your-capacity-id"
```

## PARAMETERS

### -CapacityId

The ID of the capacity.
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

The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the workloads for the specified capacity.
It then returns the 'value' property of the response, which contains the workloads.

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

