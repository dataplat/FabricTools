---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Invoke-FabricAPIRequest_duplicate

## SYNOPSIS
Sends an HTTP request to a Fabric API endpoint and retrieves the response.
Takes care of: authentication, 429 throttling, Long-Running-Operation (LRO) response

## SYNTAX

```
Invoke-FabricAPIRequest_duplicate [-Headers] <Hashtable> [-BaseURI] <String> [-Method] <String>
 [[-Body] <String>] [[-ContentType] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-RestMethod function is used to send an HTTP request to a Fabric API endpoint and retrieve the response.
It handles various aspects such as authentication, 429 throttling, and Long-Running-Operation (LRO) response.

## EXAMPLES

### EXAMPLE 1
```
Invoke-FabricAPIRequest_duplicate -uri "/api/resource" -method "Get"
```

This example sends a GET request to the "/api/resource" endpoint of the Fabric API.

### EXAMPLE 2
```
Invoke-FabricAPIRequest_duplicate -authToken "abc123" -uri "/api/resource" -method "Post" -body $requestBody
```

This example sends a POST request to the "/api/resource" endpoint of the Fabric API with a request body.

## PARAMETERS

### -BaseURI
{{ Fill BaseURI Description }}

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
The body of the request, if applicable.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContentType
The content type of the request.
The default value is 'application/json; charset=utf-8'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Application/json; charset=utf-8
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headers
{{ Fill Headers Description }}

```yaml
Type: System.Collections.Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
The HTTP method to be used for the request.
Valid values are 'Get', 'Post', 'Delete', 'Put', and 'Patch'.
The default value is 'Get'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: System.Management.Automation.ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function requires the Get-FabricAuthToken function to be defined in the same script or module.

Author: Rui Romano.

## RELATED LINKS
