---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricConfig
---

# Get-FabricConfig

## SYNOPSIS

Gets the configuration for use with all functions in the PSFabricTools module.

## SYNTAX

### __AllParameterSets

```
Get-FabricConfig [[-ConfigName] <string>]
```

## ALIASES

## DESCRIPTION

Gets the configuration for use with all functions in the PSFabricTools module.

## EXAMPLES

### EXAMPLE 1

Get-FabricConfig

Gets all the configuration values for the PSFabricTools module and outputs them.

### EXAMPLE 2

Get-FabricConfig -ConfigName BaseUrl

Gets the BaseUrl configuration value for the PSFabricTools module.

## PARAMETERS

### -ConfigName

The name of the configuration to be retrieved.

```yaml
Type: System.String
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

## INPUTS

## OUTPUTS

## NOTES

Author: Jess Pomfret

## RELATED LINKS

{{ Fill in the related links here }}

