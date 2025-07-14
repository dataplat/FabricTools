---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricDomainTenantSettingOverrides
---

# Get-FabricDomainTenantSettingOverrides

## SYNOPSIS

Retrieves tenant setting overrides for a specific domain or all capacities in the Fabric tenant.

## SYNTAX

### __AllParameterSets

```
Get-FabricDomainTenantSettingOverrides [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricDomainTenantSettingOverrides` function retrieves tenant setting overrides for all domains in the Fabric tenant by making a GET request to the designated API endpoint.
The function ensures token validity before making the request and handles the response appropriately.

## EXAMPLES

### EXAMPLE 1

Fetches tenant setting overrides for all domains in the Fabric tenant.

```powershell
Get-FabricDomainTenantSettingOverrides
```

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

- Requires the `$FabricConfig` global configuration, which must include `BaseUrl` and `FabricHeaders`.
- Ensures token validity by invoking `Confirm-TokenState` before making the API request.
- Logs detailed messages for debugging and error handling.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

