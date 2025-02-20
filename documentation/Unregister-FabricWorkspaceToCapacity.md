# Unregister-FabricWorkspaceToCapacity

## SYNOPSIS
Unregisters a workspace from a capacity.

## SYNTAX

### WorkspaceId
```
Unregister-FabricWorkspaceToCapacity -WorkspaceId <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### WorkspaceObject
```
Unregister-FabricWorkspaceToCapacity -Workspace <Object> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Unregister-FabricWorkspaceToCapacity function unregisters a workspace from a capacity in PowerBI.
It can be used to remove a workspace from a capacity, allowing it to be assigned to a different capacity or remain unassigned.

## EXAMPLES

### EXAMPLE 1
```
Unregister-FabricWorkspaceToCapacity -WorkspaceId "12345678"
Unregisters the workspace with ID "12345678" from the capacity.
```

### EXAMPLE 2
```
Get-FabricWorkspace | Unregister-FabricWorkspaceToCapacity
Unregisters the workspace objects piped from Get-FabricWorkspace from the capacity.
```

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

### -Workspace
Specifies the workspace object to be unregistered from the capacity.
This parameter is mandatory when using the 'WorkspaceObject' parameter set.
The workspace object can be piped into the function.

```yaml
Type: System.Object
Parameter Sets: WorkspaceObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WorkspaceId
Specifies the ID of the workspace to be unregistered from the capacity.
This parameter is mandatory when using the 'WorkspaceId' parameter set.

```yaml
Type: System.String
Parameter Sets: WorkspaceId
Aliases:

Required: True
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

### System.Management.Automation.PSCustomObject
## OUTPUTS

### System.Object
## NOTES
Author: Your Name
Date: Today's Date

## RELATED LINKS
