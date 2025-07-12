---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Add-FabricDomainWorkspaceAssignmentByCapacity
---

# Add-FabricDomainWorkspaceAssignmentByCapacity

## SYNOPSIS

Assigns workspaces to a Fabric domain based on specified capacities.

## SYNTAX

### __AllParameterSets

```
Add-FabricDomainWorkspaceAssignmentByCapacity [-DomainId] <guid> [-CapacitiesIds] <guid[]>
 [<CommonParameters>]
```

## ALIASES

Assign-FabricDomainWorkspaceByCapacity

## DESCRIPTION

The `Add-FabricDomainWorkspaceAssignmentByCapacity` function assigns workspaces to a Fabric domain using a list of capacity IDs by making a POST request to the relevant API endpoint.

## EXAMPLES

### EXAMPLE 1

Assigns workspaces to the domain with ID "12345" based on the specified capacities.

```powershell
Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId "12345" -CapacitiesIds @("capacity1", "capacity2")
```

## PARAMETERS

### -CapacitiesIds

An array of capacity IDs used to assign workspaces to the domain.

```yaml
Type: System.Guid[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DomainId

The unique identifier of the Fabric domain to which the workspaces will be assigned.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

