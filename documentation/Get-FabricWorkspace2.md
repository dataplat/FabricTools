# Get-FabricWorkspace2

## SYNOPSIS
Retrieves Fabric Workspaces

## SYNTAX

```
Get-FabricWorkspace2 [[-WorkspaceId] <String>] [[-WorkspaceName] <String>] [[-WorkspaceCapacityId] <String>]
 [[-WorkspaceType] <String>] [[-WorkspaceState] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves Fabric Workspaces.
Without the WorkspaceName or WorkspaceID parameter,
all Workspaces are returned.
If you want to retrieve a specific Workspace, you can
use the WorkspaceName, an CapacityID, a WorkspaceType, a WorkspaceState or the WorkspaceID
parameter.
The WorkspaceId parameter has precedence over all other parameters because it
is most specific.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricWorkspace
```

This example will retrieve all Workspaces.

### EXAMPLE 2
```
Get-FabricWorkspace `
    -WorkspaceId '12345678-1234-1234-1234-123456789012'
```

This example will retrieve the Workspace with the ID '12345678-1234-1234-1234-123456789012'.

### EXAMPLE 3
```
Get-FabricWorkspace `
    -WorkspaceName 'MyWorkspace'
```

This example will retrieve the Workspace with the name 'MyWorkspace'.

### EXAMPLE 4
```
Get-FabricWorkspace `
    -WorkspaceCapacityId '12345678-1234-1234-1234-123456789012'
```

This example will retrieve the Workspaces with the Capacity ID '12345678-1234-1234-1234-123456789012'.

### EXAMPLE 5
```
Get-FabricWorkspace `
    -WorkspaceType 'Personal'
```

This example will retrieve the Workspaces with the type 'Personal'.

### EXAMPLE 6
```
Get-FabricWorkspace `
    -WorkspaceState 'active'
```

This example will retrieve the Workspaces with the state 'active'.

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

### -WorkspaceCapacityId
The Id of the Capacity to retrieve.
This parameter cannot be used together with WorkspaceID.
The value for WorkspaceCapacityId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: CapacityId

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
Id of the Fabric Workspace to retrieve.
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

### -WorkspaceName
The name of the Workspace to retrieve.
This parameter cannot be used together with WorkspaceID.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceState
The state of the Workspace to retrieve.
This parameter cannot be used together with WorkspaceID.
The value for WorkspaceState is a string.
An example of a string is 'active'.
The values that
can be used are 'active' and 'deleted'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: State

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceType
The type of the Workspace to retrieve.
This parameter cannot be used together with WorkspaceID.
The value for WorkspaceType is a string.
An example of a string is 'Personal'.
The values that
can be used are 'Personal', 'Workspace' and 'Adminworkspace'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Type

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Revsion History:

- 2024-12-22 - FGE: Added Verbose Output

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/admin/workspaces/get-workspace?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/admin/workspaces/get-workspace?tabs=HTTP)

[https://learn.microsoft.com/en-us/rest/api/fabric/admin/workspaces/list-workspaces?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/admin/workspaces/list-workspaces?tabs=HTTP)

