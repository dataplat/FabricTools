---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Invoke-FabricRestMethodExtended

## SYNOPSIS
Sends an HTTP request to a Fabric API endpoint and retrieves the response.
Takes care of: authentication, 429 throttling, Long-Running-Operation (LRO) response

## SYNTAX

```
Invoke-FabricRestMethodExtended [-Uri] <String> [[-Method] <String>] [[-Body] <Object>] [[-RetryCount] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-FabricRestMethodExtended function is used to send an HTTP request to a Fabric API endpoint and retrieve the response.
It handles various aspects such as authentication, 429 throttling, and Long-Running-Operation (LRO) response.

## EXAMPLES

### EXAMPLE 1
```
Invoke-FabricRestMethodExtended -Uri "/api/resource" -Method "GET"
```

This example sends a GET request to the "/api/resource" endpoint of the Fabric API.

### EXAMPLE 2
```
Invoke-FabricRestMethodExtended -Uri "/api/resource" -method "POST" -Body $requestBody
```

This example sends a POST request to the "/api/resource" endpoint of the Fabric API with a request body.

## PARAMETERS

### -Body
The body of the request, if applicable.

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
The HTTP method to be used for the request.
Valid values are 'GET', 'POST', 'DELETE', 'PUT', and 'PATCH'.
The default value is 'GET'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: GET
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

### -RetryCount
The number of times to retry the request in case of a 429 (Too Many Requests) error.
The default value is 0.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri
The URI of the Fabric API endpoint to send the request to.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function based on code that was originally written by Rui Romano (Invoke-FabricAPIRequest) and replaces it.
It's extended version of simple Invoke-FabricRestMethod function.
Requires \`$FabricConfig\` global configuration, including \`BaseUrl\`.

Author: Kamil Nowinski

## RELATED LINKS
