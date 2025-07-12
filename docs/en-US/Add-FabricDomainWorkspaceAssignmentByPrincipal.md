---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Add-FabricDomainWorkspaceAssignmentByPrincipal
---

# Add-FabricDomainWorkspaceAssignmentByPrincipal

## SYNOPSIS

Assigns workspaces to a domain based on principal IDs in Microsoft Fabric.

## SYNTAX

### __AllParameterSets

```
Add-FabricDomainWorkspaceAssignmentByPrincipal [-DomainId] <guid> [-PrincipalIds] <Object>
 [<CommonParameters>]
```

## ALIASES

Assign-FabricDomainWorkspaceByPrincipal

## DESCRIPTION

The `Add-FabricDomainWorkspaceAssignmentByPrincipal` function sends a request to assign workspaces to a specified domain using a JSON object of principal IDs and types.

## EXAMPLES

### EXAMPLE 1

@{id = "813abb4a-414c-4ac0-9c2c-bd17036fd58c";  type = "User"}, @{id = "b5b9495c-685a-447a-b4d3-2d8e963e6288"; type = "User"} ) Add-FabricDomainWorkspaceAssignmentByPrincipal -DomainId "12345" -PrincipalIds $principals Assigns the workspaces based on the provided principal IDs and types.

```powershell
$PrincipalIds = @(
```

## PARAMETERS

### -DomainId

The ID of the domain to which workspaces will be assigned.
This parameter is mandatory.

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

### -PrincipalIds

An array representing the principals with their `id` and `type` properties.
Must contain a `principals` key with an array of objects.

```yaml
Type: System.Object
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

