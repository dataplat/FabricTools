# Get-FabricWorkspaceRoleAssignment

## SYNOPSIS
Retrieves Fabric Workspace Role Assignments

## SYNTAX

```
Get-FabricWorkspaceRoleAssignment [[-WorkspaceId] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves Fabric Workspace Role Assignments.
Without the WorkspaceName or WorkspaceID parameter,

## EXAMPLES

### EXAMPLE 1
```
Get-FabricWorkspaceRoleAssignment `
    -WorkspaceId '12345678-1234-1234-1234-123456789012'
```

This example will retrieve all Role Assignments for the Workspace with the ID '12345678-1234-1234-1234-123456789012'.

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

### -WorkspaceId
Id of the Fabric Workspace for which the Role Assignments should be retrieved.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Id

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

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/core/workspaces/get-workspace-role-assignment?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/core/workspaces/get-workspace-role-assignment?tabs=HTTP)

[https://learn.microsoft.com/en-us/rest/api/fabric/core/workspaces/list-workspace-role-assignments?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/core/workspaces/list-workspace-role-assignments?tabs=HTTP)

