---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricCapacityWorkload

## SYNOPSIS
Retrieves the workloads for a specific capacity.

## SYNTAX

```
Get-FabricCapacityWorkload [-CapacityId] <Guid> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricCapacityWorkload function retrieves the workloads for a specific capacity.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricCapacityWorkload -capacityID "your-capacity-id"
```

This example retrieves the workloads for a specific capacity given the capacity ID and authentication token.

## PARAMETERS

### -CapacityId
The ID of the capacity.
This is a mandatory parameter.

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
The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the workloads for the specified capacity.
It then returns the 'value' property of the response, which contains the workloads.

Author: Ioana Bouariu

## RELATED LINKS
