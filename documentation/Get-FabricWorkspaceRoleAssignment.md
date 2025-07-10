---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricWorkspaceRoleAssignment

## SYNOPSIS
Retrieves role assignments for a specified Fabric workspace.

## SYNTAX

```
Get-FabricWorkspaceRoleAssignment [-WorkspaceId] <Guid> [[-WorkspaceRoleAssignmentId] <Guid>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricWorkspaceRoleAssignments\` function fetches the role assignments associated with a Fabric workspace by making a GET request to the API.
If \`WorkspaceRoleAssignmentId\` is provided, it retrieves the specific role assignment.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricWorkspaceRoleAssignments -WorkspaceId "workspace123"
```

Fetches all role assignments for the workspace with the ID "workspace123".

### EXAMPLE 2
```
Get-FabricWorkspaceRoleAssignments -WorkspaceId "workspace123" -WorkspaceRoleAssignmentId "role123"
```

Fetches the role assignment with the ID "role123" for the workspace "workspace123".

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
The unique identifier of the workspace to fetch role assignments for.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceRoleAssignmentId
(Optional) The unique identifier of a specific role assignment to retrieve.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object[]
## NOTES
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
