---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Add-FabricDomainWorkspaceAssignmentByCapacity

## SYNOPSIS
Assigns workspaces to a Fabric domain based on specified capacities.

## SYNTAX

```
Add-FabricDomainWorkspaceAssignmentByCapacity [-DomainId] <Guid> [-CapacitiesIds] <Guid[]>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Add-FabricDomainWorkspaceAssignmentByCapacity\` function assigns workspaces to a Fabric domain using a list of capacity IDs by making a POST request to the relevant API endpoint.

## EXAMPLES

### EXAMPLE 1
```
Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId "12345" -CapacitiesIds @("capacity1", "capacity2")
```

Assigns workspaces to the domain with ID "12345" based on the specified capacities.

## PARAMETERS

### -CapacitiesIds
An array of capacity IDs used to assign workspaces to the domain.

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

### -DomainId
The unique identifier of the Fabric domain to which the workspaces will be assigned.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
