---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricDomainWorkspace
---

# Get-FabricDomainWorkspace

## SYNOPSIS

Retrieves the workspaces associated with a specific domain in Microsoft Fabric.

## SYNTAX

### __AllParameterSets

```
Get-FabricDomainWorkspace [-DomainId] <guid> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricDomainWorkspace` function fetches the workspaces for the given domain ID.

## EXAMPLES

### EXAMPLE 1

Fetches workspaces for the domain with ID "12345".

```powershell
Get-FabricDomainWorkspace -DomainId "12345"
```

## PARAMETERS

### -DomainId

The ID of the domain for which to retrieve workspaces.

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

