---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 11/07/2026
PlatyPS schema version: 2024-05-01
title: Disconnect-FabricGit
---

# Disconnect-FabricGit

## SYNOPSIS

Disconnects a Fabric workspace from its Git repository.

## SYNTAX

### __AllParameterSets

```
Disconnect-FabricGit [-WorkspaceId] <guid> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Disconnects the specified workspace from the Git repository and branch it is connected to.
Workspace items are not deleted, but the link to source control is removed.
Because this
affects every user of the workspace, the cmdlet asks for confirmation by default; use
-Confirm:$false to skip the prompt.

## EXAMPLES

### EXAMPLE 1

Disconnect-FabricGit -WorkspaceId '11111111-1111-1111-1111-111111111111'

Disconnects the workspace from Git after confirmation.

### EXAMPLE 2

Get-FabricWorkspace -WorkspaceName 'Sales' | Disconnect-FabricGit -Confirm:$false

Disconnects the 'Sales' workspace from Git without prompting.

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

Runs the command in a mode that only reports what would happen without performing the actions.

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

### -WorkspaceId

The ID of the workspace to disconnect.
Accepts pipeline input by property name (alias Id).

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

### System.Guid

{{ Fill in the Description }}

## OUTPUTS

## NOTES

https://learn.microsoft.com/en-us/rest/api/fabric/core/git/disconnect

Requires the workspace Admin role.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

