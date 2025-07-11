---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Set-FabricConfig

## SYNOPSIS
Register the configuration for use with all functions in the PSFabricTools module.

## SYNTAX

```
Set-FabricConfig [[-WorkspaceGUID] <Guid>] [[-DataWarehouseGUID] <Guid>] [[-BaseUrl] <Object>] [-SkipPersist]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Register the configuration for use with all functions in the PSFabricTools module.

## EXAMPLES

### EXAMPLE 1
```
Set-FabricConfig -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'
```

Registers the specified Fabric Data Warehouse configuration for use with all functions in the PSFabricTools module.

### EXAMPLE 2
```
Set-FabricConfig -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID' -SkipPersist
```

Registers the specified Fabric Data Warehouse configuration for use with all functions in the PSFabricTools module - but it does not persist the values, only uses them for the current session.

## PARAMETERS

### -BaseUrl
Defaults to api.powerbi.com

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Api.powerbi.com
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataWarehouseGUID
The GUID for the Data Warehouse which we want to retrieve restore points for.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

### -SkipPersist
If set, the configuration will not be persisted to the registry.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceGUID
This is the workspace GUID in which the Data Warehouse resides.

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
Author: Jess Pomfret

## RELATED LINKS
