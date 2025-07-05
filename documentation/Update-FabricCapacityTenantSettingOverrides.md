---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Update-FabricCapacityTenantSettingOverrides

## SYNOPSIS
Updates tenant setting overrides for a specified capacity ID.

## SYNTAX

```
Update-FabricCapacityTenantSettingOverrides [-TenantSettingName] <String> [-EnableTenantSetting] <Boolean>
 [[-DelegateToCapacity] <Boolean>] [[-DelegateToDomain] <Boolean>] [[-DelegateToWorkspace] <Boolean>]
 [[-EnabledSecurityGroups] <Object>] [[-ExcludedSecurityGroups] <Object>] [[-Properties] <Object>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The \`Update-FabricCapacityTenantSettingOverrides\` function updates tenant setting overrides in a Fabric environment by making a POST request to the appropriate API endpoint.
It allows specifying settings such as enabling tenant settings, delegating to a workspace, and including or excluding security groups.

## EXAMPLES

### EXAMPLE 1
```
Update-FabricCapacityTenantSettingOverrides -CapacityId "12345" -SettingTitle "SomeSetting" -EnableTenantSetting "true"
```

Updates the tenant setting "SomeSetting" for the capacity with ID "12345" and enables it.

### EXAMPLE 2
```
Update-FabricCapacityTenantSettingOverrides -CapacityId "12345" -SettingTitle "SomeSetting" -EnableTenantSetting "true" -EnabledSecurityGroups @(@{graphId="1";name="Group1"},@{graphId="2";name="Group2"})
```

Updates the tenant setting "SomeSetting" for the capacity with ID "12345", enables it, and specifies security groups to include.

## PARAMETERS

### -DelegateToCapacity
{{ Fill DelegateToCapacity Description }}

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DelegateToDomain
{{ Fill DelegateToDomain Description }}

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DelegateToWorkspace
(Optional) Specifies the workspace to which the setting should be delegated.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnabledSecurityGroups
(Optional) A JSON array of security groups to be enabled, each containing \`graphId\` and \`name\` properties.

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableTenantSetting
(Mandatory) Indicates whether the tenant setting should be enabled.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludedSecurityGroups
(Optional) A JSON array of security groups to be excluded, each containing \`graphId\` and \`name\` properties.

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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

### -Properties
{{ Fill Properties Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantSettingName
{{ Fill TenantSettingName Description }}

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi

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
