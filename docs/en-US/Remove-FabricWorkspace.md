---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 04/01/2026
PlatyPS schema version: 2024-05-01
title: Remove-FabricWorkspace
---

# Remove-FabricWorkspace

## SYNOPSIS

Deletes an existing Fabric workspace by its workspace ID or name.

## SYNTAX

### ById (Default)

```
Remove-FabricWorkspace [-WorkspaceId] <guid> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByName

```
Remove-FabricWorkspace -WorkspaceName <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Remove-FabricWorkspace` function deletes a workspace in the Fabric platform by sending a DELETE request to the API.
When a name is provided, exactly one accessible workspace must match.
If no workspace or multiple workspaces match, no deletion is performed.

## EXAMPLES

### EXAMPLE 1

Deletes the workspace with the ID "workspace123".

```powershell
Remove-FabricWorkspace -WorkspaceId "workspace123"
```

### EXAMPLE 2

Deletes the workspace with the exact name "MyImportantFabricWorkspace".

```powershell
Remove-FabricWorkspace -Name "MyImportantFabricWorkspace"
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

The unique identifier of the workspace to be deleted.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: ById
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WorkspaceName

The exact display name of the workspace to be deleted. Supports the alias Name.
Use WorkspaceId if the name is ambiguous.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Name
ParameterSets:
- Name: ByName
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

## OUTPUTS

## NOTES

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}
