---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Add-FabricDomainWorkspaceAssignmentByPrincipal

## SYNOPSIS
Assigns workspaces to a domain based on principal IDs in Microsoft Fabric.

## SYNTAX

```
Add-FabricDomainWorkspaceAssignmentByPrincipal [-DomainId] <Guid> [-PrincipalIds] <Object>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Add-FabricDomainWorkspaceAssignmentByPrincipal\` function sends a request to assign workspaces to a specified domain using a JSON object of principal IDs and types.

## EXAMPLES

### EXAMPLE 1
```
$PrincipalIds = @(
    @{id = "813abb4a-414c-4ac0-9c2c-bd17036fd58c";  type = "User"},
    @{id = "b5b9495c-685a-447a-b4d3-2d8e963e6288"; type = "User"}
    )
```

Add-FabricDomainWorkspaceAssignmentByPrincipal -DomainId "12345" -PrincipalIds $principals

Assigns the workspaces based on the provided principal IDs and types.

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

### -PrincipalIds
An array representing the principals with their \`id\` and \`type\` properties.
Must contain a \`principals\` key with an array of objects.

```yaml
Type: System.Object
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
