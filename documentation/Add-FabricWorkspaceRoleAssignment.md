# Add-FabricWorkspaceRoleAssignment

## SYNOPSIS
Adds a role assignment to a user in a workspace.

## SYNTAX

```
Add-FabricWorkspaceRoleAssignment [-WorkspaceId] <String> [-principalId] <String> [-Role] <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds a role assignment to a user in a workspace.
The User is identified by the principalId and the role is
identified by the Role parameter.
The Workspace is identified by the WorkspaceId.

## EXAMPLES

### EXAMPLE 1
```
Add-RtiWorkspaceRoleAssignment `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -PrincipalId '12345678-1234-1234-1234-123456789012' `
    -Role 'Admin'
```

## PARAMETERS

### -principalId
Id of the principal for which the role assignment should be added.
The value for PrincipalId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.
This parameter is mandatory.
At the
moment only principal type 'User' is supported.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
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

### -Role
The role to assign to the principal.
The value for Role is a string.
An example of a string is 'Admin'.
The values that can be used are 'Admin', 'Contributor', 'Member' and 'Viewer'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
Id of the Fabric Workspace for which the role assignment should be added.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.
This parameter is mandatory.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Id

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
TODO: Add functionallity to add role assignments to groups.
TODO: Add functionallity to add a user by SPN.

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/core/workspaces/add-workspace-role-assignment?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/core/workspaces/add-workspace-role-assignment?tabs=HTTP)

