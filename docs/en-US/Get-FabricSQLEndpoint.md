---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricSQLEndpoint
---

# Get-FabricSQLEndpoint

## SYNOPSIS

Retrieves SQL Endpoints from a specified workspace in Fabric.

## SYNTAX

### __AllParameterSets

```
Get-FabricSQLEndpoint [-WorkspaceId] <guid> [[-SQLEndpointId] <guid>] [[-SQLEndpointName] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricSQLEndpoint` function retrieves SQL Endpoints from a specified workspace in Fabric.
It supports filtering by SQL Endpoint ID or SQL Endpoint Name.
If both filters are provided,
an error message is returned.
The function handles token validation, API requests with continuation
tokens, and processes the response to return the desired SQL Endpoint(s).

## EXAMPLES

### EXAMPLE 1

```powershell
Get-FabricSQLEndpoint -WorkspaceId "workspace123" -SQLEndpointId "endpoint456"
```

### EXAMPLE 2

```powershell
Get-FabricSQLEndpoint -WorkspaceId "workspace123" -SQLEndpointName "MySQLEndpoint"
```

## PARAMETERS

### -SQLEndpointId

The ID of the SQL Endpoint to retrieve.
This parameter is optional but cannot be used together with SQLEndpointName.

```yaml
Type: System.Guid
DefaultValue: ''
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

### -SQLEndpointName

The name of the SQL Endpoint to retrieve.
This parameter is optional but cannot be used together with SQLEndpointId.

```yaml
Type: System.String
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

### -WorkspaceId

The ID of the workspace from which to retrieve SQL Endpoints.
This parameter is mandatory.

```yaml
Type: System.Guid
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

- This function requires the FabricConfig object to be properly configured with BaseUrl and FabricHeaders.
- The function uses continuation tokens to handle paginated API responses.
- If no filter parameters are provided, all SQL Endpoints in the specified workspace are returned.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

