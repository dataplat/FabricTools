---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Invoke-FabricRestMethod
---

# Invoke-FabricRestMethod

## SYNOPSIS

Sends an HTTP request to a Fabric API endpoint and retrieves the response.

## SYNTAX

### __AllParameterSets

```
Invoke-FabricRestMethod [-Uri] <string> [[-Method] <string>] [[-Body] <Object>] [-TestTokenExpired]
 [-PowerBIApi] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Invoke-FabricRestMethod function is used to send an HTTP request to a Fabric API endpoint and retrieve the response.

## EXAMPLES

### EXAMPLE 1

Invoke-FabricRestMethod -uri "/api/resource" -method "GET"

This example sends a GET request to the "/api/resource" endpoint of the Fabric API.

### EXAMPLE 2

Invoke-FabricRestMethod -uri "/api/resource" -method "POST" -body $requestBody

This example sends a POST request to the "/api/resource" endpoint of the Fabric API with a request body.

## PARAMETERS

### -Body

The body of the request, if applicable.
This can be a hashtable or a string.
If a hashtable is provided, it will be converted to JSON format.

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

### -PowerBIApi

A switch parameter to indicate that the request should be sent to the Power BI API instead of the Fabric API.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TestTokenExpired

A switch parameter to test if the Fabric token is expired before making the request.
If the token is expired, it will attempt to refresh it.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
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

- Requires `$FabricConfig` global configuration, including `BaseUrl`.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

