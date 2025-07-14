---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Invoke-FabricRestMethodExtended
---

# Invoke-FabricRestMethodExtended

## SYNOPSIS

Sends an HTTP request to a Fabric API endpoint and retrieves the response.
Takes care of: authentication, 429 throttling, Long-Running-Operation (LRO) response

## SYNTAX

### __AllParameterSets

```
Invoke-FabricRestMethodExtended [-Uri] <string> [[-Method] <string>] [[-Body] <Object>]
 [[-RetryCount] <int>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Invoke-FabricRestMethodExtended function is used to send an HTTP request to a Fabric API endpoint and retrieve the response.
It handles various aspects such as authentication, 429 throttling, and Long-Running-Operation (LRO) response.

## EXAMPLES

### EXAMPLE 1

Invoke-FabricRestMethodExtended -Uri "/api/resource" -Method "GET"

This example sends a GET request to the "/api/resource" endpoint of the Fabric API.

### EXAMPLE 2

Invoke-FabricRestMethodExtended -Uri "/api/resource" -method "POST" -Body $requestBody

This example sends a POST request to the "/api/resource" endpoint of the Fabric API with a request body.

## PARAMETERS

### -Body

The body of the request, if applicable.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Method

The HTTP method to be used for the request.
Valid values are 'GET', 'POST', 'DELETE', 'PUT', and 'PATCH'.
The default value is 'GET'.

```yaml
Type: System.String
DefaultValue: GET
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

### -RetryCount

The number of times to retry the request in case of a 429 (Too Many Requests) error.
The default value is 0.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Uri

The URI of the Fabric API endpoint to send the request to.

```yaml
Type: System.String
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

This function based on code that was originally written by Rui Romano (Invoke-FabricAPIRequest) and replaces it.
It's extended version of simple Invoke-FabricRestMethod function.
Requires `$FabricConfig` global configuration, including `BaseUrl`.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

