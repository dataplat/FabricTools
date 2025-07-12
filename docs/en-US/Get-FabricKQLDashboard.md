---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricKQLDashboard
---

# Get-FabricKQLDashboard

## SYNOPSIS

Retrieves an KQLDashboard or a list of KQLDashboards from a specified workspace in Microsoft Fabric.

## SYNTAX

### __AllParameterSets

```
Get-FabricKQLDashboard [-WorkspaceId] <guid> [[-KQLDashboardId] <guid>]
 [[-KQLDashboardName] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricKQLDashboard` function sends a GET request to the Fabric API to retrieve KQLDashboard details for a given workspace.
It can filter the results by `KQLDashboardName`.

## EXAMPLES

### EXAMPLE 1

Retrieves the "Development" KQLDashboard from workspace "12345". .PARAMETER KQLDashboardID The Id of the KQLDashboard to retrieve. This parameter cannot be used together with KQLDashboardName. The value for KQLDashboardID is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```powershell
Get-FabricKQLDashboard -WorkspaceId "12345" -KQLDashboardName "Development"
```

### EXAMPLE 2

Retrieves all KQLDashboards in workspace "12345".

```powershell
Get-FabricKQLDashboard -WorkspaceId "12345"
```

## PARAMETERS

### -KQLDashboardId

{{ Fill KQLDashboardId Description }}

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -KQLDashboardName

(Optional) The name of the specific KQLDashboard to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WorkspaceId

(Mandatory) The ID of the workspace to query KQLDashboards.

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

