---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricCapacities
---

# Get-FabricCapacities

## SYNOPSIS

This function retrieves all resources of type "Microsoft.Fabric/capacities" from all resource groups in a given subscription or all subscriptions if no subscription ID is provided.

## SYNTAX

### __AllParameterSets

```
Get-FabricCapacities [[-subscriptionID] <guid>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Get-AllFabricCapacities function is used to retrieve all resources of type "Microsoft.Fabric/capacities" from all resource groups in a given subscription or all subscriptions if no subscription ID is provided.
It uses the Az module to interact with Azure.

## EXAMPLES

### EXAMPLE 1

Get-AllFabricCapacities -subscriptionID "12345678-1234-1234-1234-123456789012"

This command retrieves all resources of type "Microsoft.Fabric/capacities" from all resource groups in the subscription with the ID "12345678-1234-1234-1234-123456789012".

### EXAMPLE 2

Get-AllFabricCapacities

This command retrieves all resources of type "Microsoft.Fabric/capacities" from all resource groups in all subscriptions.

## PARAMETERS

### -subscriptionID

An optional parameter that specifies the subscription ID.
If this parameter is not provided, the function will retrieve resources from all subscriptions.

```yaml
Type: System.Guid
DefaultValue: ''
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
Imported into FabricTools April 2025
Alias: Get-AllFabCapacities

## RELATED LINKS

{{ Fill in the related links here }}

