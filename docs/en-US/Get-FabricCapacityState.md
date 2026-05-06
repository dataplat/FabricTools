---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 04/01/2026
PlatyPS schema version: 2024-05-01
title: Get-FabricCapacityState
---

# Get-FabricCapacityState

## SYNOPSIS

Retrieves the state of a specific capacity.

## SYNTAX

### __AllParameterSets

```
Get-FabricCapacityState [-SubscriptionID] <guid> [-ResourceGroup] <string> [-capacity] <string>
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Get-FabricCapacityState function retrieves the state of a specific capacity.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1

This example retrieves the state of a specific capacity given the subscription ID, resource group, and capacity.

```powershell
Get-FabricCapacityState -SubscriptionID "your-subscription-id" -ResourceGroup "your-resource-group" -Capacity "your-capacity"
```

## PARAMETERS

### -capacity

The capacity.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

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

### -ResourceGroup

The resource group.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

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

### -SubscriptionID

The ID of the subscription.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

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

The function checks if the Azure token is null.
If it is, it connects to the Azure account and retrieves the token.
It then defines the headers for the GET request and the URL for the GET request.
Finally, it makes the GET request and returns the response.

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

