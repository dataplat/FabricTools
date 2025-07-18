---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Register-FabricWorkspaceToCapacity

## SYNOPSIS
Sets a PowerBI workspace to a capacity.

## SYNTAX

### WorkspaceId
```
Register-FabricWorkspaceToCapacity [-WorkspaceId <Guid>] -CapacityId <Guid>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### WorkspaceObject
```
Register-FabricWorkspaceToCapacity [-Workspace <Object>] -CapacityId <Guid>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Register-FabricWorkspaceToCapacity function Sets a PowerBI workspace to a capacity.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1
```
Register-FabricWorkspaceToCapacity -WorkspaceId "Workspace-GUID" -CapacityId "Capacity-GUID"
```

This example Sets the workspace with ID "Workspace-GUID" to the capacity with ID "Capacity-GUID".

### EXAMPLE 2
```
$workspace | Register-FabricWorkspaceToCapacity -CapacityId "Capacity-GUID"
```

This example Sets the workspace object stored in the $workspace variable to the capacity with ID "Capacity-GUID".
The workspace object is piped into the function.

## PARAMETERS

### -CapacityId
The ID of the capacity to which the workspace will be Seted.
This is a mandatory parameter.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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

### -Workspace
The workspace object to be Seted.
This is a mandatory parameter and can be piped into the function.

```yaml
Type: System.Object
Parameter Sets: WorkspaceObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WorkspaceId
The ID of the workspace to be Seted.
This is a mandatory parameter.

```yaml
Type: System.Guid
Parameter Sets: WorkspaceId
Aliases:

Required: False
Position: Named
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
The function makes a POST request to the PowerBI API to Set the workspace to the capacity.
The PowerBI access token is retrieved using the Get-PowerBIAccessToken function.

Author: Ioana Bouariu

## RELATED LINKS
