---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Remove-FabricDomainWorkspaceAssignment

## SYNOPSIS
Unassign workspaces from a specified Fabric domain.

## SYNTAX

```
Remove-FabricDomainWorkspaceAssignment [-DomainId] <Guid> [[-WorkspaceIds] <Guid[]>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The \`Unassign -FabricDomainWorkspace\` function allows you to Unassign  specific workspaces from a given Fabric domain or unassign all workspaces if no workspace IDs are specified.
It makes a POST request to the relevant API endpoint for this operation.

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricDomainWorkspaceAssignment -DomainId "12345"
```

Unassigns all workspaces from the domain with ID "12345".

### EXAMPLE 2
```
Remove-FabricDomainWorkspaceAssignment -DomainId "12345" -WorkspaceIds @("workspace1", "workspace2")
```

Unassigns the specified workspaces from the domain with ID "12345".

## PARAMETERS

### -DomainId
The unique identifier of the Fabric domain.

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

### -WorkspaceIds
(Optional) An array of workspace IDs to unassign.
If not provided, all workspaces will be unassigned.

```yaml
Type: System.Guid[]
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
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.


Author: Tiago Balabuch

## RELATED LINKS
