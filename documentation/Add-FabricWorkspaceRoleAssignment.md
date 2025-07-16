---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Add-FabricWorkspaceRoleAssignment

## SYNOPSIS
Assigns a role to a principal for a specified Fabric workspace.

## SYNTAX

```
Add-FabricWorkspaceRoleAssignment [-WorkspaceId] <Guid> [-PrincipalId] <Guid> [-PrincipalType] <String>
 [-WorkspaceRole] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Add-FabricWorkspaceRoleAssignments\` function assigns a role (e.g., Admin, Contributor, Member, Viewer) to a principal (e.g., User, Group, ServicePrincipal) in a Fabric workspace by making a POST request to the API.

## EXAMPLES

### EXAMPLE 1
```
Add-FabricWorkspaceRoleAssignment -WorkspaceId "workspace123" -PrincipalId "principal123" -PrincipalType "User" -WorkspaceRole "Admin"
```

Assigns the Admin role to the user with ID "principal123" in the workspace "workspace123".

## PARAMETERS

### -PrincipalId
The unique identifier of the principal (User, Group, etc.) to assign the role.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrincipalType
The type of the principal.
Allowed values: Group, ServicePrincipal, ServicePrincipalProfile, User.

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
The unique identifier of the workspace.

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

### -WorkspaceRole
The role to assign to the principal.
Allowed values: Admin, Contributor, Member, Viewer.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable
## NOTES
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
