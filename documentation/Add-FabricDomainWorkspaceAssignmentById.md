---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Add-FabricDomainWorkspaceAssignmentById

## SYNOPSIS
Assigns workspaces to a specified domain in Microsoft Fabric by their IDs.

## SYNTAX

```
Add-FabricDomainWorkspaceAssignmentById [-DomainId] <Guid> [-WorkspaceIds] <Guid[]>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Add-FabricDomainWorkspaceAssignmentById\` function sends a request to assign multiple workspaces to a specified domain using the provided domain ID and an array of workspace IDs.

## EXAMPLES

### EXAMPLE 1
```
Add-FabricDomainWorkspaceAssignmentById -DomainId "12345" -WorkspaceIds @("ws1", "ws2", "ws3")
```

Assigns the workspaces with IDs "ws1", "ws2", and "ws3" to the domain with ID "12345".

## PARAMETERS

### -DomainId
The ID of the domain to which workspaces will be assigned.
This parameter is mandatory.

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
An array of workspace IDs to be assigned to the domain.
This parameter is mandatory.

```yaml
Type: System.Guid[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
