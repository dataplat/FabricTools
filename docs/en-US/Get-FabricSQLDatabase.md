---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricSQLDatabase
---

# Get-FabricSQLDatabase

## SYNOPSIS

Retrieves Fabric SQL Database details.

## SYNTAX

### WorkspaceId

```
Get-FabricSQLDatabase -WorkspaceId <guid> [-SQLDatabaseName <string>] [-SQLDatabaseId <guid>]
 [<CommonParameters>]
```

### WorkspaceObject

```
Get-FabricSQLDatabase -Workspace <Object> [-SQLDatabaseName <string>] [-SQLDatabaseId <guid>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves Fabric SQL Database details.
Without the SQLDatabaseName or SQLDatabaseID parameter,
all SQL Databases are returned.
If you want to retrieve a specific SQLDatabase, you can
use the SQLDatabaseName or SQLDatabaseID parameter.
These parameters cannot be used together.

## EXAMPLES

### EXAMPLE 1

Returns the details of the Fabric SQL Database with the name 'MySQLDatabase' in the workspace that is specified by the WorkspaceId.

```powershell
$FabricSQLDatabaseConfig = @{
    WorkspaceId = '12345678-1234-1234-1234-123456789012'
    SQLDatabaseName = 'MySQLDatabase'
}
Get-FabricSQLDatabase @FabricSQLDatabaseConfig
```

### EXAMPLE 2

Returns the details of the Fabric SQL Databases in the workspace that is specified by the WorkspaceId.

```powershell
Get-FabricSQLDatabase -WorkspaceId '12345678-1234-1234-1234-123456789012'
```

### EXAMPLE 3

Returns the details of the Fabric SQL Database with the ID '12345678-1234-1234-1234-123456789012' from the workspace with the ID '12345678-1234-1234-1234-123456789012'.

```powershell
Get-FabricSQLDatabase -WorkspaceId '12345678-1234-1234-1234-123456789012' -SQLDatabaseId '12345678-1234-1234-1234-123456789012'
```

### EXAMPLE 4

Returns the details of the Fabric SQL Databases in the MsLearn-dev workspace.

```powershell
Get-FabricWorkspace -WorkspaceName 'MsLearn-dev' | Get-FabricSQLDatabase
```

## PARAMETERS

### -SQLDatabaseId

The Id of the SQLDatabase to retrieve.
This parameter cannot be used together with SQLDatabaseName.
The value for SQLDatabaseID is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
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

### -SQLDatabaseName

The name of the SQLDatabase to retrieve.
This parameter cannot be used together with SQLDatabaseID.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Name
- DisplayName
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

The workspace object.
This is a mandatory parameter for the 'WorkspaceObject' parameter set and can be pipelined into the function.
The object can be easily retrieved by Get-FabricWorkspace function.

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

Id of the Fabric Workspace for which the SQL Databases should be retrieved.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

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

## NOTES

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

