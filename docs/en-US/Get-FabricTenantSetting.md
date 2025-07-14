---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricTenantSetting
---

# Get-FabricTenantSetting

## SYNOPSIS

Retrieves tenant settings from the Fabric environment.

## SYNTAX

### __AllParameterSets

```
Get-FabricTenantSetting [[-SettingTitle] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricTenantSetting` function retrieves tenant settings for a Fabric environment by making a GET request to the appropriate API endpoint.
Optionally, it filters the results by the `SettingTitle` parameter.

## EXAMPLES

### EXAMPLE 1

Returns all tenant settings.

```powershell
Get-FabricTenantSetting
```

### EXAMPLE 2

Returns the tenant setting with the title "SomeSetting".

```powershell
Get-FabricTenantSetting -SettingTitle "SomeSetting"
```

## PARAMETERS

### -SettingTitle

(Optional) The title of a specific tenant setting to filter the results.

```yaml
Type: System.String
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
- Calls `Is-TokenExpired` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

