---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricCapacityTenantSettingOverrides
---

# Get-FabricCapacityTenantSettingOverrides

## SYNOPSIS

Retrieves tenant setting overrides for a specific capacity or all capacities in the Fabric tenant.

## SYNTAX

### __AllParameterSets

```
Get-FabricCapacityTenantSettingOverrides [[-CapacityId] <guid>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricCapacityTenantSettingOverrides` function retrieves tenant setting overrides for a specific capacity or all capacities in the Fabric tenant by making a GET request to the appropriate API endpoint.
If a `capacityId` is provided, the function retrieves overrides for that specific capacity.
Otherwise, it retrieves overrides for all capacities.

## EXAMPLES

### EXAMPLE 1

Returns all capacities tenant setting overrides.

```powershell
Get-FabricCapacityTenantSettingOverrides
```

### EXAMPLE 2

Returns tenant setting overrides for the capacity with ID "12345".

```powershell
Get-FabricCapacityTenantSettingOverrides -capacityId "12345"
```

## PARAMETERS

### -CapacityId

The ID of the capacity for which tenant setting overrides should be retrieved.
If not provided, overrides for all capacities will be retrieved.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

