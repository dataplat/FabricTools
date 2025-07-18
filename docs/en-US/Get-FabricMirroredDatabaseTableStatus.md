---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricMirroredDatabaseTableStatus
---

# Get-FabricMirroredDatabaseTableStatus

## SYNOPSIS

Retrieves the status of tables in a mirrored database.

## SYNTAX

### __AllParameterSets

```
Get-FabricMirroredDatabaseTableStatus [-WorkspaceId] <guid> [[-MirroredDatabaseId] <guid>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves the status of tables in a mirrored database.
The function validates the authentication token, constructs the API endpoint URL, and makes a POST request to retrieve the mirroring status of tables.
It handles errors and logs messages at various levels (Debug, Error).

## EXAMPLES

### EXAMPLE 1

This example retrieves the status of tables in a mirrored database with the specified ID in the specified workspace.

```powershell
Get-FabricMirroredDatabaseTableStatus -WorkspaceId "your-workspace-id" -MirroredDatabaseId "your-mirrored-database-id"
```

## PARAMETERS

### -MirroredDatabaseId

The ID of the mirrored database whose table status is to be retrieved.

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

### System.Object

{{ Fill in the Description }}

## NOTES

The function retrieves the PowerBI access token and makes a POST request to the PowerBI API to retrieve the status of tables in the specified mirrored database.
It then returns the 'value' property of the response, which contains the table statuses.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

