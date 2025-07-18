---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Add-FabricDomainWorkspaceRoleAssignment

## SYNOPSIS
Bulk assigns roles to principals for workspaces in a Fabric domain.

## SYNTAX

```
Add-FabricDomainWorkspaceRoleAssignment [-DomainId] <Guid> [-DomainRole] <String> [-PrincipalIds] <Array>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`AssignFabricDomainWorkspaceRoleAssignment\` function performs bulk role assignments for principals in a specific Fabric domain.
It sends a POST request to the relevant API endpoint.

## EXAMPLES

### EXAMPLE 1
```
AssignFabricDomainWorkspaceRoleAssignment -DomainId "12345" -DomainRole "Admins" -PrincipalIds @(@{id="user1"; type="User"}, @{id="group1"; type="Group"})
```

Assigns the \`Admins\` role to the specified principals in the domain with ID "12345".

## PARAMETERS

### -DomainId
The unique identifier of the Fabric domain where roles will be assigned.

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

### -DomainRole
The role to assign to the principals.
Must be one of the following:
- \`Admins\`
- \`Contributors\`

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

### -PrincipalIds
An array of principals to assign roles to.
Each principal must include:
- \`id\`: The identifier of the principal.
- \`type\`: The type of the principal (e.g., \`User\`, \`Group\`).

```yaml
Type: System.Array
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
