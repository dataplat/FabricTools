---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-Sha256
---

# Get-Sha256

## SYNOPSIS

Calculates the SHA256 hash of a string.

## SYNTAX

### __AllParameterSets

```
Get-Sha256 [[-string] <Object>]
```

## ALIASES

## DESCRIPTION

The Get-Sha256 function calculates the SHA256 hash of a string.

## EXAMPLES

### EXAMPLE 1

Get-Sha256 -string "your-string"

This example calculates the SHA256 hash of a string.

## PARAMETERS

### -string

The string to hash.
This is a mandatory parameter.

```yaml
Type: System.Object
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

The function creates a new SHA256CryptoServiceProvider object, converts the string to a byte array using UTF8 encoding, computes the SHA256 hash of the byte array, converts the hash to a string and removes any hyphens, and returns the resulting hash.

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

