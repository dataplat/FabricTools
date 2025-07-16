---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricTenantSetting

## SYNOPSIS
Retrieves tenant settings from the Fabric environment.

## SYNTAX

```
Get-FabricTenantSetting [[-SettingTitle] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricTenantSetting\` function retrieves tenant settings for a Fabric environment by making a GET request to the appropriate API endpoint.
Optionally, it filters the results by the \`SettingTitle\` parameter.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricTenantSetting
```

Returns all tenant settings.

### EXAMPLE 2
```
Get-FabricTenantSetting -SettingTitle "SomeSetting"
```

Returns the tenant setting with the title "SomeSetting".

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

### -SettingTitle
(Optional) The title of a specific tenant setting to filter the results.

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
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Is-TokenExpired\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
