---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/16/2025
PlatyPS schema version: 2024-05-01
title: Import-FabricItem
---

# Import-FabricItem

## SYNOPSIS

Imports items using the Power BI Project format (PBIP) into a Fabric workspace from a specified file system source.

## SYNTAX

### __AllParameterSets

```
Import-FabricItem [[-path] <string>] [[-workspaceId] <guid>] [[-filter] <string>]
 [[-fileOverrides] <hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The `Import-FabricItem` function imports items using the Power BI Project format (PBIP) into a Fabric workspace from a specified file system source.
It supports multiple aliases for flexibility.
The function handles the import of datasets and reports, ensuring that the correct item type is used and that the items are created or updated as necessary.

## EXAMPLES

### EXAMPLE 1

This example imports PBIP files from the 'C:\PBIPFiles' folder into the Fabric workspace with ID '12345'. It only searches for PBIP files in the 'C:\PBIPFiles\Reports' folder.

```powershell
Import-FabricItem -path 'C:\PBIPFiles' -workspaceId '12345' -filter 'C:\PBIPFiles\Reports'
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

### -fileOverrides

This parameter let's you override a PBIP file without altering the local file.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -filter

A filter to limit the search for PBIP files to specific folders.

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

### -path

The path to the PBIP files.
Default value is '.\pbipOutput'.

```yaml
Type: System.String
DefaultValue: .\pbipOutput
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
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

### -workspaceId

The ID of the Fabric workspace.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function requires the Invoke-FabricRestMethod function to be available in the current session.

Author: Rui Romano


## RELATED LINKS

{{ Fill in the related links here }}
