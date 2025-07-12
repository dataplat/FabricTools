---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricMirroredDatabaseStatus
---

# Get-FabricMirroredDatabaseStatus

## SYNOPSIS

Retrieves the status of a mirrored database in a specified workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricMirroredDatabaseStatus [-WorkspaceId] <guid> [[-MirroredDatabaseId] <guid>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves the status of a mirrored database in a specified workspace.
The function validates the authentication token, constructs the API endpoint URL, and makes a POST request to retrieve the mirroring status.
It handles errors and logs messages at various levels (Debug, Error).

## EXAMPLES

### EXAMPLE 1

Get-FabricMirroredDatabaseStatus -WorkspaceId "your-workspace-id" -MirroredDatabaseId "your-mirrored-database-id"
This example retrieves the status of a mirrored database with the specified ID in the specified workspace.

## PARAMETERS

### -MirroredDatabaseId

the ID of the mirrored database whose status is to be retrieved.

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

### -WorkspaceId

The ID of the workspace containing the mirrored database.

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

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

