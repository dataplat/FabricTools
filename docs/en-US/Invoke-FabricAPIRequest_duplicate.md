---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Invoke-FabricAPIRequest_duplicate
---

# Invoke-FabricAPIRequest_duplicate

## SYNOPSIS

Sends an HTTP request to a Fabric API endpoint and retrieves the response.
Takes care of: authentication, 429 throttling, Long-Running-Operation (LRO) response

## SYNTAX

### __AllParameterSets

```
Invoke-FabricAPIRequest_duplicate [-Headers] <hashtable> [-BaseURI] <string> [-Method] <string>
 [[-Body] <string>] [[-ContentType] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Invoke-RestMethod function is used to send an HTTP request to a Fabric API endpoint and retrieve the response.
It handles various aspects such as authentication, 429 throttling, and Long-Running-Operation (LRO) response.

## EXAMPLES

### EXAMPLE 1

Invoke-FabricAPIRequest_duplicate -uri "/api/resource" -method "Get"

This example sends a GET request to the "/api/resource" endpoint of the Fabric API.

### EXAMPLE 2

Invoke-FabricAPIRequest_duplicate -authToken "abc123" -uri "/api/resource" -method "Post" -body $requestBody

This example sends a POST request to the "/api/resource" endpoint of the Fabric API with a request body.

## PARAMETERS

### -BaseURI

{{ Fill BaseURI Description }}

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

### -Body

The body of the request, if applicable.

```yaml
Type: System.String
DefaultValue: ''
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

### -ContentType

The content type of the request.
The default value is 'application/json; charset=utf-8'.

```yaml
Type: System.String
DefaultValue: application/json; charset=utf-8
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Headers

{{ Fill Headers Description }}

```yaml
Type: System.Collections.Hashtable
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

### -Method

The HTTP method to be used for the request.
Valid values are 'Get', 'Post', 'Delete', 'Put', and 'Patch'.
The default value is 'Get'.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function requires the Get-FabricAuthToken function to be defined in the same script or module.

Author: Rui Romano.

## RELATED LINKS

{{ Fill in the related links here }}

