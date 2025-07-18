---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricCapacitySkus

## SYNOPSIS
Retrieves the fabric capacity information.

## SYNTAX

```
Get-FabricCapacitySkus [-subscriptionID] <Guid> [-ResourceGroupName] <String> [-capacity] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function makes a GET request to the Fabric API to retrieve the tenant settings.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricCapacitySkus -capacity "exampleCapacity"
Retrieves the fabric capacity information for the specified capacity.
```

## PARAMETERS

### -capacity
Specifies the capacity to retrieve information for.
If not provided, all capacities will be retrieved.

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

### -ResourceGroupName
Specifies the name of the resource group in which the Fabric capacity is located.

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

### -subscriptionID
Specifies the subscription ID for the Azure subscription.

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
Author: Kamil Nowinski

## RELATED LINKS
