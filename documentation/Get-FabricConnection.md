---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricConnection

## SYNOPSIS
Retrieves Fabric connections.

## SYNTAX

```
Get-FabricConnection [[-connectionId] <Guid>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricConnection function retrieves Fabric connections.
It can retrieve all connections or the specified one only.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricConnection
```

This example retrieves all connections from Fabric

### EXAMPLE 2
```
Get-FabricConnection -connectionId "12345"
```

This example retrieves specific connection from Fabric with ID "12345".

## PARAMETERS

### -connectionId
The ID of the connection to retrieve.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
https://learn.microsoft.com/en-us/rest/api/fabric/core/connections/get-connection?tabs=HTTP
https://learn.microsoft.com/en-us/rest/api/fabric/core/connections/list-connections?tabs=HTTP

Author: Kamil Nowinski

## RELATED LINKS
