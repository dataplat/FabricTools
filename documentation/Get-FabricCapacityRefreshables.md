---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricCapacityRefreshables

## SYNOPSIS
Retrieves the top refreshable capacities for the tenant.

## SYNTAX

```
Get-FabricCapacityRefreshables [[-top] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricCapacityRefreshables function retrieves the top refreshable capacities for the tenant.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricCapacityRefreshables -top 5
```

This example retrieves the top 5 refreshable capacities for the tenant.

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

### -top
The number of top refreshable capacities to retrieve.
This is a mandatory parameter.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the top refreshable capacities.
It then returns the 'value' property of the response, which contains the capacities.

Author: Ioana Bouariu

## RELATED LINKS
