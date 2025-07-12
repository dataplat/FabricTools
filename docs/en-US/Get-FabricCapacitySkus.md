---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricCapacitySkus
---

# Get-FabricCapacitySkus

## SYNOPSIS

Retrieves the fabric capacity information.

## SYNTAX

### __AllParameterSets

```
Get-FabricCapacitySkus [-subscriptionID] <guid> [-ResourceGroupName] <string> [-capacity] <string>
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function makes a GET request to the Fabric API to retrieve the tenant settings.

## EXAMPLES

### EXAMPLE 1

Retrieves the fabric capacity information for the specified capacity.

```powershell
Get-FabricCapacitySkus -capacity "exampleCapacity"
```

## PARAMETERS

### -capacity

Specifies the capacity to retrieve information for.
If not provided, all capacities will be retrieved.

```yaml
Type: System.String
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

### -ResourceGroupName

Specifies the name of the resource group in which the Fabric capacity is located.

```yaml
Type: System.String
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

### -subscriptionID

Specifies the subscription ID for the Azure subscription.

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

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

