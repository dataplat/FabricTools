---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Unregister-FabricWorkspaceToCapacity
---

# Unregister-FabricWorkspaceToCapacity

## SYNOPSIS

Unregisters a workspace from a capacity.

## SYNTAX

### WorkspaceId

```
Unregister-FabricWorkspaceToCapacity -WorkspaceId <guid> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### WorkspaceObject

```
Unregister-FabricWorkspaceToCapacity -Workspace <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

Unregister-FabWorkspaceToCapacity

## DESCRIPTION

The Unregister-FabricWorkspaceToCapacity function unregisters a workspace from a capacity in PowerBI.
It can be used to remove a workspace from a capacity, allowing it to be assigned to a different capacity or remain unassigned.

## EXAMPLES

### EXAMPLE 1

Unregisters the workspace with ID "12345678" from the capacity.

```powershell
Unregister-FabricWorkspaceToCapacity -WorkspaceId "12345678"
```

### EXAMPLE 2

Unregisters the workspace objects piped from Get-FabricWorkspace from the capacity. .INPUTS System.Management.Automation.PSCustomObject

```powershell
Get-FabricWorkspace | Unregister-FabricWorkspaceToCapacity
```

## PARAMETERS

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

Specifies the workspace object to be unregistered from the capacity.
This parameter is mandatory when using the 'WorkspaceObject' parameter set.
The workspace object can be piped into the function.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WorkspaceObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WorkspaceId

Specifies the ID of the workspace to be unregistered from the capacity.
This parameter is mandatory when using the 'WorkspaceId' parameter set.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WorkspaceId
  Position: Named
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

### System.Object

{{ Fill in the Description }}

## OUTPUTS

### System.Object

{{ Fill in the Description }}

## NOTES

Author: Ioana Bouariu

## RELATED LINKS

{{ Fill in the related links here }}

