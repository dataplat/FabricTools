---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Item
Locale: en-US
Module Name: FabricTools
ms.date: 11/08/2026
PlatyPS schema version: 2024-05-01
title: Remove-FabricItem
---

# Remove-FabricItem

## SYNOPSIS

Removes selected items from a Fabric workspace.

## SYNTAX

### __AllParameterSets

```
Remove-FabricItem [-WorkspaceId] <guid> [[-filter] <string>] [[-itemID] <guid>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Remove-FabricItem function removes items from a specified Fabric workspace.

Supply `ItemID` to remove a single item.
Otherwise the items in the workspace are listed and
removed; pass `Filter` to narrow that list to items whose DisplayName matches a wildcard
pattern.
Without a filter, every item in the workspace is removed.

Each item is confirmed individually, so `-WhatIf` lists precisely what would be removed and
`-Confirm` prompts per item rather than once for the whole batch.

## EXAMPLES

### EXAMPLE 1

Removes every item in the workspace whose DisplayName contains "test".

```powershell
Remove-FabricItem -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef" -Filter "*test*"
```

### EXAMPLE 2

Removes a single item by ID.

```powershell
Remove-FabricItem -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef" -ItemID "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
```

### EXAMPLE 3

Lists every item that would be removed from the workspace, without removing anything.

```powershell
Remove-FabricItem -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef" -WhatIf
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

### -filter

A wildcard pattern matched against each item's DisplayName.
Only matching items are removed.
If omitted, every item in the workspace is removed.

```yaml
Type: System.String
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

### -itemID

The ID of a single item to remove.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
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

The ID of the Fabric workspace.
This is a mandatory parameter.

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

### String. You can pipe a string that contains the workspace ID to Remove-FabricItem.

{{ Fill in the Description }}

## OUTPUTS

### None. This function does not return any output.

{{ Fill in the Description }}

## NOTES

Revision History:

- 2026-08-25 - PBO: Confirm each item individually so the prompt and -WhatIf name the item
  being removed, rather than confirming the whole batch once.

Author: Rui Romano
https://github.com/microsoft/Analysis-Services/tree/master/pbidevmode/fabricps-pbip

## RELATED LINKS

{{ Fill in the related links here }}

