---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Invoke-FabricRestMethod

## SYNOPSIS
Sends an HTTP request to a Fabric API endpoint and retrieves the response.

## SYNTAX

```
Invoke-FabricRestMethod [-Uri] <String> [[-Method] <String>] [[-Body] <Object>] [-TestTokenExpired]
 [-PowerBIApi] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-FabricRestMethod function is used to send an HTTP request to a Fabric API endpoint and retrieve the response.

## EXAMPLES

### EXAMPLE 1
```
Invoke-FabricRestMethod -uri "/api/resource" -method "GET"
```

This example sends a GET request to the "/api/resource" endpoint of the Fabric API.

### EXAMPLE 2
```
Invoke-FabricRestMethod -uri "/api/resource" -method "POST" -body $requestBody
```

This example sends a POST request to the "/api/resource" endpoint of the Fabric API with a request body.

## PARAMETERS

### -Body
The body of the request, if applicable.
This can be a hashtable or a string.
If a hashtable is provided, it will be converted to JSON format.

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

### -PowerBIApi
A switch parameter to indicate that the request should be sent to the Power BI API instead of the Fabric API.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### -TestTokenExpired
A switch parameter to test if the Fabric token is expired before making the request.
If the token is expired, it will attempt to refresh it.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\`.

Author: Kamil Nowinski

## RELATED LINKS
