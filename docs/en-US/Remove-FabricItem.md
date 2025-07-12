---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
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

The Remove-FabricItems function removes selected items from a specified Fabric workspace.
It uses the workspace ID and an optional filter to select the items to remove.
If a filter is provided, only items whose DisplayName matches the filter are removed.

## EXAMPLES

### EXAMPLE 1

Remove-FabricItems -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef" -Filter "*test*"

This command removes all items from the workspace with the specified ID whose DisplayName includes "test".

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

An optional filter to select items to remove.
If provided, only items whose DisplayName matches the filter are removed.

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

The ID of a specific item to remove.
If provided, this item is removed regardless of the filter

```yaml
Type: System.Guid
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

### String. You can pipe two strings that contain the workspace ID and filter to Remove-FabricItems.

{{ Fill in the Description }}

## OUTPUTS

### None. This function does not return any output.

{{ Fill in the Description }}

## NOTES

Author: Rui Romano
https://github.com/microsoft/Analysis-Services/tree/master/pbidevmode/fabricps-pbip

## RELATED LINKS

{{ Fill in the related links here }}

