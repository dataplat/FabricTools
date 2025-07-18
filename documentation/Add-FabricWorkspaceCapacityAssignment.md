---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Add-FabricWorkspaceCapacityAssignment

## SYNOPSIS
Assigns a Fabric workspace to a specified capacity.

## SYNTAX

```
Add-FabricWorkspaceCapacityAssignment [-WorkspaceId] <Guid> [-CapacityId] <Guid>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Add-FabricWorkspaceCapacityAssignment\` function sends a POST request to assign a workspace to a specific capacity.

## EXAMPLES

### EXAMPLE 1
```
Add-FabricWorkspaceCapacityAssignment -WorkspaceId "workspace123" -CapacityId "capacity456"
```

Assigns the workspace with ID "workspace123" to the capacity "capacity456".

## PARAMETERS

### -CapacityId
The unique identifier of the capacity to which the workspace should be assigned.

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
The unique identifier of the workspace to be assigned.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
