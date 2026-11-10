---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Core
Locale: en-US
Module Name: FabricTools
ms.date: 11/08/2026
PlatyPS schema version: 2024-05-01
title: Get-FabricConnection
---

# Get-FabricConnection

## SYNOPSIS

Retrieves Fabric connections.

## SYNTAX

### __AllParameterSets

```
Get-FabricConnection [[-connectionId] <guid>] [-ConnectionName <string>] [<CommonParameters>]
```

### -ConnectionName

The exact display name of the connection to retrieve. An error is raised if
multiple connections have that name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Name
- DisplayName
ParameterSets:
- Name: (All)
  IsRequired: false
```

## ALIASES

## DESCRIPTION

The Get-FabricConnection function retrieves Fabric connections.
It can retrieve all connections, a connection by ID, or a connection by exact display name.

## EXAMPLES

### EXAMPLE 1

Get-FabricConnection

This example retrieves all connections from Fabric

### EXAMPLE 2

Get-FabricConnection -connectionId "12345"

This example retrieves specific connection from Fabric with ID "12345".

### EXAMPLE 3

```powershell
Get-FabricConnection -ConnectionName 'Finance API'
```

Retrieves the connection with the exact display name.

## PARAMETERS

### -connectionId

The ID of the connection to retrieve.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
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

https://learn.microsoft.com/en-us/rest/api/fabric/core/connections/get-connection?tabs=HTTP
https://learn.microsoft.com/en-us/rest/api/fabric/core/connections/list-connections?tabs=HTTP

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}
