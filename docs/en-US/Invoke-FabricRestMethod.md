---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 04/01/2026
PlatyPS schema version: 2024-05-01
title: Invoke-FabricRestMethod
---

# Invoke-FabricRestMethod

## SYNOPSIS

Sends an HTTP request to a Fabric or Power BI API endpoint and retrieve the response.

## SYNTAX

### __AllParameterSets

```
Invoke-FabricRestMethod [-Uri] <string> [[-Method] <string>] [[-Body] <Object>]
 [[-ExtractValue] <string>] [[-TypeName] <string>] [[-ObjectIdOrName] <string>]
 [[-SuccessMessage] <string>] [-TestTokenExpired] [-PowerBIApi] [-NoWait] [-HandleResponse]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Sends an HTTP request to a Fabric or Power BI API endpoint and retrieve the response.
Supports pagination by recognizing continuation tokens in the response.
Supports handling of long-running operations and throttling (error 429) responses.
Facilitates both synchronous and asynchronous operations.
Message logging is provided for debugging and informational purposes.

## EXAMPLES

### EXAMPLE 1

Invoke-FabricRestMethod -uri "workspaces" -method "GET"

This example sends a GET request to the "https://api.fabric.microsoft.com/v1/workspaces" endpoint of the Fabric API.

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

### -ExtractValue

A string parameter to specify whether to extract the 'value' property from the response.
Valid values are 'True', 'False', and 'Auto'.
The default is 'False'.
'Auto' will extract 'value' if it exists in the response.

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

### -HandleResponse

A switch parameter to indicate that the response should be handled after call API.
Default is False.
The operation will be processed based on the response status code and supports Throttling (429) and Long-Running Operations.

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

### -NoWait

A switch parameter to indicate that the function should not wait for the response.
This is useful for asynchronous operations.
Default is False.
If set to True, the function will return immediately without waiting for the operation to complete.

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

### -ObjectIdOrName

Optional.
The name or ID of the resource being operated on.
This is used for logging purposes.
Should be used when `HandleResponse` is set to True.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
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

### -SuccessMessage

Optional.
A message to log upon successful completion of the operation.
This is used for logging purposes.
Should be used when `HandleResponse` is set to True.
Overrides the default message based on Operation, TypeName, ObjectIdOrName.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 6
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
Default is False.
If set to True, the function will check the token state before making the request.

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

### -TypeName

Optional.
The type of resource being operated on.
This is used for logging purposes.
Default is 'Fabric Item'.
Should be used when `HandleResponse` is set to True.

```yaml
Type: System.String
DefaultValue: Fabric Item
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

### -Uri

The URI of the Fabric API endpoint to send the request to.
Can be a relative path (e.g., "workspaces") or a full URL (e.g., "https://api.fabric.microsoft.com/v1/workspaces").

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

