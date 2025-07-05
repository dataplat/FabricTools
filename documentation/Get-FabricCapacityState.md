---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricCapacityState

## SYNOPSIS
Retrieves the state of a specific capacity.

## SYNTAX

```
Get-FabricCapacityState [-subscriptionID] <Guid> [-resourcegroup] <String> [-capacity] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricCapacityState function retrieves the state of a specific capacity.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricCapacityState -subscriptionID "your-subscription-id" -resourcegroupID "your-resource-group" -capacityID "your-capacity"
```

This example retrieves the state of a specific capacity given the subscription ID, resource group, and capacity.

## PARAMETERS

### -capacity
The capacity.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

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

### -resourcegroup
The resource group.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

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
The ID of the subscription.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

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
The function checks if the Azure token is null.
If it is, it connects to the Azure account and retrieves the token.
It then defines the headers for the GET request and the URL for the GET request.
Finally, it makes the GET request and returns the response.

Author: Ioana Bouariu

## RELATED LINKS
