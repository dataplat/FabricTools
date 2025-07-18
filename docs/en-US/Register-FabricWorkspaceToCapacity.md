---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Register-FabricWorkspaceToCapacity
---

# Register-FabricWorkspaceToCapacity

## SYNOPSIS

Sets a PowerBI workspace to a capacity.

## SYNTAX

### WorkspaceId

```
Register-FabricWorkspaceToCapacity -CapacityId <guid> [-WorkspaceId <guid>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### WorkspaceObject

```
Register-FabricWorkspaceToCapacity -CapacityId <guid> [-Workspace <Object>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

Register-FabWorkspaceToCapacity

## DESCRIPTION

The Register-FabricWorkspaceToCapacity function Sets a PowerBI workspace to a capacity.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1

This example Sets the workspace with ID "Workspace-GUID" to the capacity with ID "Capacity-GUID".

```powershell
Register-FabricWorkspaceToCapacity -WorkspaceId "Workspace-GUID" -CapacityId "Capacity-GUID"
```

### EXAMPLE 2

This example Sets the workspace object stored in the $workspace variable to the capacity with ID "Capacity-GUID". The workspace object is piped into the function.

```powershell
$workspace | Register-FabricWorkspaceToCapacity -CapacityId "Capacity-GUID"
```

## PARAMETERS

### -CapacityId

The ID of the capacity to which the workspace will be Seted.
This is a mandatory parameter.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Tells PowerShell to run the command in a mode that only reports what would happen, but not actually let the command run or make changes.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Workspace

The workspace object to be Seted.
This is a mandatory parameter and can be piped into the function.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WorkspaceObject
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WorkspaceId

The ID of the workspace to be Seted.
This is a mandatory parameter.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WorkspaceId
  Position: Named
  IsRequired: false
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

### System.Object

{{ Fill in the Description }}

## OUTPUTS

## NOTES

The function makes a POST request to the PowerBI API to Set the workspace to the capacity.
The PowerBI access token is retrieved using the Get-PowerBIAccessToken function.

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

