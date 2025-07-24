---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricAPIclusterURI
---

# Get-FabricAPIclusterURI

## SYNOPSIS

Retrieves the cluster URI for the tenant.

## SYNTAX

### __AllParameterSets

```
Get-FabricAPIclusterURI [<CommonParameters>]
```

## ALIASES

Get-FabAPIClusterURI

## DESCRIPTION

The Get-FabricAPIclusterURI function retrieves the cluster URI for the tenant.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1

Get-FabricAPIclusterURI

This example retrieves the cluster URI for the tenant.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

{{ Fill in the Description }}

## NOTES

The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the datasets.
It then extracts the '@odata.context' property from the response, splits it on the '/' character, and selects the third element.
This element is used to construct the cluster URI, which is then returned by the function.

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

