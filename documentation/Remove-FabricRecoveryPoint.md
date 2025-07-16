---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Remove-FabricRecoveryPoint

## SYNOPSIS
Remove a selected Fabric Recovery Point.

## SYNTAX

```
Remove-FabricRecoveryPoint [[-CreateTime] <String>] [[-WorkspaceGUID] <Guid>] [[-DataWarehouseGUID] <Guid>]
 [[-BaseUrl] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a selected Fabric Recovery Point.

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z'
```

Remove a specific restore point from a Fabric Data Warehouse that has been set using Set-FabricConfig.

### EXAMPLE 2
```
Remove-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z' -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'
```

Remove a specific restore point from a Fabric Data Warehouse, specifying the workspace and data warehouse GUIDs.

## PARAMETERS

### -BaseUrl
Defaults to api.powerbi.com

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Api.powerbi.com
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateTime
The specific unique time of the restore point to remove.
Get this from Get-FabricRecoveryPoint.

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

### -DataWarehouseGUID
The GUID for the data warehouse which we want to retrieve restore points for.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
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

### -WorkspaceGUID
This is the workspace GUID in which the data warehouse resides.

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
