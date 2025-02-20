# Get-AllFabricCapacities

## SYNOPSIS
This function retrieves all resources of type "Microsoft.Fabric/capacities" from all resource groups in a given subscription or all subscriptions if no subscription ID is provided.

## SYNTAX

```
Get-AllFabricCapacities [[-subscriptionID] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-AllFabricCapacities function is used to retrieve all resources of type "Microsoft.Fabric/capacities" from all resource groups in a given subscription or all subscriptions if no subscription ID is provided.
It uses the Az module to interact with Azure.

## EXAMPLES

### EXAMPLE 1
```
Get-AllFabricCapacities -subscriptionID "12345678-1234-1234-1234-123456789012"
```

This command retrieves all resources of type "Microsoft.Fabric/capacities" from all resource groups in the subscription with the ID "12345678-1234-1234-1234-123456789012".

### EXAMPLE 2
```
Get-AllFabricCapacities
```

This command retrieves all resources of type "Microsoft.Fabric/capacities" from all resource groups in all subscriptions.

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

### -subscriptionID
An optional parameter that specifies the subscription ID.
If this parameter is not provided, the function will retrieve resources from all subscriptions.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
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
Alias: Get-AllFabCapacities

## RELATED LINKS
