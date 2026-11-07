---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 04/01/2026
PlatyPS schema version: 2024-05-01
title: Remove-FabricSQLDatabase
---

# Remove-FabricSQLDatabase

## SYNOPSIS

Deletes a SQL Database from a specified workspace in Microsoft Fabric by ID or exact name.

## SYNTAX

### ById

```
Remove-FabricSQLDatabase -WorkspaceId <guid> -SQLDatabaseId <guid> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByName

```
Remove-FabricSQLDatabase -WorkspaceId <guid> -SQLDatabaseName <string> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

- `SQLDatabaseName`: `Name`

## DESCRIPTION

When a name is provided, exactly one SQL Database in the workspace must match. If no database or multiple databases match, no deletion is performed.

## EXAMPLES

### EXAMPLE 1

Deletes the SQL Database with ID "67890" from workspace "12345".

```powershell
Remove-FabricSQLDatabase -WorkspaceId "12345" -SQLDatabaseId "67890"
```

### EXAMPLE 2

Deletes the SQL Database with the exact name "MyDatabase" from workspace "12345".

```powershell
Remove-FabricSQLDatabase -WorkspaceId "12345" -SQLDatabaseName "MyDatabase"
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

### -SQLDatabaseId

The ID of the SQL Database to be deleted.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ById
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SQLDatabaseName

The exact name of the SQL Database to be deleted. Supports the alias Name. Use SQLDatabaseId if the name is ambiguous.

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

The ID of the workspace containing the SQLDatabase to delete.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ById
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

- Validates token expiration before making the API request.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}
