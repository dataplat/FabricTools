---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricDebugInfo
---

# Get-FabricDebugInfo

## SYNOPSIS

Shows internal debug information about the current Azure & Fabric sessions & Fabric config.

## SYNTAX

### __AllParameterSets

```
Get-FabricDebugInfo [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Shows internal debug information about the current session.
It is useful for troubleshooting purposes.
It will show you the current session object.
This includes the bearer token.
This can be useful
for connecting to the REST API directly via Postman.

## EXAMPLES

### EXAMPLE 1

Get-FabricDebugInfo

This example shows the current session object.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable

{{ Fill in the Description }}

## NOTES

Author: Frank Geisler, Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

