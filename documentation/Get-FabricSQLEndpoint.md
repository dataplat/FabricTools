---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricSQLEndpoint

## SYNOPSIS
Retrieves SQL Endpoints from a specified workspace in Fabric.

## SYNTAX

```
Get-FabricSQLEndpoint [-WorkspaceId] <Guid> [[-SQLEndpointId] <Guid>] [[-SQLEndpointName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricSQLEndpoint function retrieves SQL Endpoints from a specified workspace in Fabric.
It supports filtering by SQL Endpoint ID or SQL Endpoint Name.
If both filters are provided,
an error message is returned.
The function handles token validation, API requests with continuation
tokens, and processes the response to return the desired SQL Endpoint(s).

## EXAMPLES

### EXAMPLE 1
```
Get-FabricSQLEndpoint -WorkspaceId "workspace123" -SQLEndpointId "endpoint456"
```

### EXAMPLE 2
```
Get-FabricSQLEndpoint -WorkspaceId "workspace123" -SQLEndpointName "MySQLEndpoint"
```

## PARAMETERS

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

### -SQLEndpointId
The ID of the SQL Endpoint to retrieve.
This parameter is optional but cannot be used together with SQLEndpointName.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SQLEndpointName
The name of the SQL Endpoint to retrieve.
This parameter is optional but cannot be used together with SQLEndpointId.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
The ID of the workspace from which to retrieve SQL Endpoints.
This parameter is mandatory.

```yaml
Type: System.Guid
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
- This function requires the FabricConfig object to be properly configured with BaseUrl and FabricHeaders.
- The function uses continuation tokens to handle paginated API responses.
- If no filter parameters are provided, all SQL Endpoints in the specified workspace are returned.

Author: Tiago Balabuch

## RELATED LINKS
