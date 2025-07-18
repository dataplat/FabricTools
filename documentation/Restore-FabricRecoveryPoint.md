---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Restore-FabricRecoveryPoint

## SYNOPSIS
Restore a Fabric data warehouse to a specified restore pont.

## SYNTAX

```
Restore-FabricRecoveryPoint [[-CreateTime] <String>] [[-WorkspaceGUID] <Guid>] [[-DataWarehouseGUID] <Guid>]
 [[-BaseUrl] <String>] [-Wait] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Restore a Fabric data warehouse to a specified restore pont.

## EXAMPLES

### EXAMPLE 1
```
Restore-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z'
```

Restore a Fabric Data Warehouse to a specific restore point that has been set using Set-FabricConfig.

### EXAMPLE 2
```
Restore-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z' -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'
```

Restore a Fabric Data Warehouse to a specific restore point, specifying the workspace and data warehouse GUIDs.

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

### -Wait
Wait for the restore to complete before returning.

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
