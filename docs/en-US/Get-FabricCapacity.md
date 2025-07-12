---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricCapacity
---

# Get-FabricCapacity

## SYNOPSIS

Retrieves capacity details from a specified Microsoft Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricCapacity [[-capacityId] <guid>] [[-capacityName] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function retrieves capacity details from a specified workspace using either the provided capacityId or capacityName.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1

Get-FabricCapacity -capacityId "capacity-12345"
This example retrieves the capacity details for the capacity with ID "capacity-12345".

### EXAMPLE 2

Get-FabricCapacity -capacityName "MyCapacity"
This example retrieves the capacity details for the capacity named "MyCapacity".

## PARAMETERS

### -capacityId

The unique identifier of the capacity to retrieve.
This parameter is optional.

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

### -capacityName

The name of the capacity to retrieve.
This parameter is optional.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
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

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

