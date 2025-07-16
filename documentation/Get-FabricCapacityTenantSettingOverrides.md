---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricCapacityTenantSettingOverrides

## SYNOPSIS
Retrieves tenant setting overrides for a specific capacity or all capacities in the Fabric tenant.

## SYNTAX

```
Get-FabricCapacityTenantSettingOverrides [[-CapacityId] <Guid>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricCapacityTenantSettingOverrides\` function retrieves tenant setting overrides for a specific capacity or all capacities in the Fabric tenant by making a GET request to the appropriate API endpoint.
If a \`capacityId\` is provided, the function retrieves overrides for that specific capacity.
Otherwise, it retrieves overrides for all capacities.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricCapacityTenantSettingOverrides
```

Returns all capacities tenant setting overrides.

### EXAMPLE 2
```
Get-FabricCapacityTenantSettingOverrides -capacityId "12345"
```

Returns tenant setting overrides for the capacity with ID "12345".

## PARAMETERS

### -CapacityId
The ID of the capacity for which tenant setting overrides should be retrieved.
If not provided, overrides for all capacities will be retrieved.

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
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
