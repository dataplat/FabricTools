---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-Sha256

## SYNOPSIS
Calculates the SHA256 hash of a string.

## SYNTAX

```
Get-Sha256 [[-string] <Object>]
```

## DESCRIPTION
The Get-Sha256 function calculates the SHA256 hash of a string.

## EXAMPLES

### EXAMPLE 1
```
Get-Sha256 -string "your-string"
```

This example calculates the SHA256 hash of a string.

## PARAMETERS

### -string
The string to hash.
This is a mandatory parameter.

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
The function creates a new SHA256CryptoServiceProvider object, converts the string to a byte array using UTF8 encoding, computes the SHA256 hash of the byte array, converts the hash to a string and removes any hyphens, and returns the resulting hash.

Author: Ioana Bouariu

## RELATED LINKS
