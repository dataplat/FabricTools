---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Add-FabricDomainWorkspaceAssignmentById
---

# Add-FabricDomainWorkspaceAssignmentById

## SYNOPSIS

Assigns workspaces to a specified domain in Microsoft Fabric by their IDs.

## SYNTAX

### __AllParameterSets

```
Add-FabricDomainWorkspaceAssignmentById [-DomainId] <guid> [-WorkspaceIds] <guid[]>
 [<CommonParameters>]
```

## ALIASES

Assign-FabricDomainWorkspaceById

## DESCRIPTION

The `Add-FabricDomainWorkspaceAssignmentById` function sends a request to assign multiple workspaces to a specified domain using the provided domain ID and an array of workspace IDs.

## EXAMPLES

### EXAMPLE 1

Assigns the workspaces with IDs "ws1", "ws2", and "ws3" to the domain with ID "12345".

```powershell
Add-FabricDomainWorkspaceAssignmentById -DomainId "12345" -WorkspaceIds @("ws1", "ws2", "ws3")
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

### -WorkspaceIds

An array of workspace IDs to be assigned to the domain.
This parameter is mandatory.

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

