---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricSQLDatabase

## SYNOPSIS
Retrieves Fabric SQL Database details.

## SYNTAX

### WorkspaceId
```
Get-FabricSQLDatabase -WorkspaceId <Guid> [-SQLDatabaseName <String>] [-SQLDatabaseId <Guid>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### WorkspaceObject
```
Get-FabricSQLDatabase -Workspace <Object> [-SQLDatabaseName <String>] [-SQLDatabaseId <Guid>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves Fabric SQL Database details.
Without the SQLDatabaseName or SQLDatabaseID parameter,
all SQL Databases are returned.
If you want to retrieve a specific SQLDatabase, you can
use the SQLDatabaseName or SQLDatabaseID parameter.
These parameters cannot be used together.

## EXAMPLES

### EXAMPLE 1
```
$FabricSQLDatabaseConfig = @{
    WorkspaceId = '12345678-1234-1234-1234-123456789012'
    SQLDatabaseName = 'MySQLDatabase'
}
Get-FabricSQLDatabase @FabricSQLDatabaseConfig
```

Returns the details of the Fabric SQL Database with the name 'MySQLDatabase' in the workspace that is specified by the WorkspaceId.

### EXAMPLE 2
```
Get-FabricSQLDatabase -WorkspaceId '12345678-1234-1234-1234-123456789012'
```

Returns the details of the Fabric SQL Databases in the workspace that is specified by the WorkspaceId.

### EXAMPLE 3
```
$FabricSQLDatabaseConfig = @{
    WorkspaceId = '12345678-1234-1234-1234-123456789012'
    -SQLDatabaseId = '12345678-1234-1234-1234-123456789012'
}
Get-FabricSQLDatabase @FabricSQLDatabaseConfig
```

Returns the details of the Fabric SQL Database with the ID '12345678-1234-1234-1234-123456789012' from the workspace with the ID '12345678-1234-1234-1234-123456789012'.

### EXAMPLE 4
```
Get-FabricWorkspace -WorkspaceName 'MsLearn-dev' | Get-FabricSQLDatabase
```

Returns the details of the Fabric SQL Databases in the MsLearn-dev workspace.

## PARAMETERS

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: System.Management.Automation.ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SQLDatabaseId
The Id of the SQLDatabase to retrieve.
This parameter cannot be used together with SQLDatabaseName.
The value for SQLDatabaseID is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases: Id

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SQLDatabaseName
The name of the SQLDatabase to retrieve.
This parameter cannot be used together with SQLDatabaseID.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name, DisplayName

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Workspace
The workspace object.
This is a mandatory parameter for the 'WorkspaceObject' parameter set and can be pipelined into the function.
The object can be easily retrieved by Get-FabricWorkspace function.

```yaml
Type: System.Object
Parameter Sets: WorkspaceObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WorkspaceId
Id of the Fabric Workspace for which the SQL Databases should be retrieved.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.Guid
Parameter Sets: WorkspaceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Kamil Nowinski

## RELATED LINKS
