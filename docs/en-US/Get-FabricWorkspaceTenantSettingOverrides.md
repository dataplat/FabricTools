---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricWorkspaceTenantSettingOverrides
---

# Get-FabricWorkspaceTenantSettingOverrides

## SYNOPSIS

Retrieves tenant setting overrides for all workspaces in the Fabric tenant.

## SYNTAX

### __AllParameterSets

```
Get-FabricWorkspaceTenantSettingOverrides [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricWorkspaceTenantSettingOverrides` function retrieves tenant setting overrides for all workspaces in the Fabric tenant by making a GET request to the appropriate API endpoint.
The function validates the authentication token before making the request and handles the response accordingly.

## EXAMPLES

### EXAMPLE 1

Returns all workspaces tenant setting overrides.

```powershell
Get-FabricWorkspaceTenantSettingOverrides
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

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

