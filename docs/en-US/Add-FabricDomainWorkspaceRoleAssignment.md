---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Add-FabricDomainWorkspaceRoleAssignment
---

# Add-FabricDomainWorkspaceRoleAssignment

## SYNOPSIS

Bulk assigns roles to principals for workspaces in a Fabric domain.

## SYNTAX

### __AllParameterSets

```
Add-FabricDomainWorkspaceRoleAssignment [-DomainId] <guid> [-DomainRole] <string>
 [-PrincipalIds] <array> [<CommonParameters>]
```

## ALIASES

Assign-FabricDomainWorkspaceRoleAssignment

## DESCRIPTION

The `AssignFabricDomainWorkspaceRoleAssignment` function performs bulk role assignments for principals in a specific Fabric domain.
It sends a POST request to the relevant API endpoint.

## EXAMPLES

### EXAMPLE 1

Assign the `Admins` role to the specified principals in the domain with ID "12345".

```powershell
Assign-FabricDomainWorkspaceRoleAssignment -DomainId "12345" -DomainRole "Admins" -PrincipalIds @(@{id="user1"; type="User"}, @{id="group1"; type="Group"})
```

## PARAMETERS

### -DomainId

The unique identifier of the Fabric domain where roles will be assigned.

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

### -DomainRole

The role to assign to the principals.
Must be one of the following:
- `Admins`
- `Contributors`

```yaml
Type: System.String
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

### -PrincipalIds

An array of principals to assign roles to.
Each principal must include:
- `id`: The identifier of the principal.
- `type`: The type of the principal (e.g., `User`, `Group`).

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
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

