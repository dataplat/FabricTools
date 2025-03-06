# Get-FabricSQLDatabase

## SYNOPSIS
Retrieves Fabric SQLDatabases

## SYNTAX

```
Get-FabricSQLDatabase [-WorkspaceId] <String> [[-SQLDatabaseName] <String>] [[-SQLDatabaseId] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves Fabric SQLDatabases.
Without the SQLDatabaseName or SQLDatabaseID parameter,
all SQLDatabases are returned.
If you want to retrieve a specific SQLDatabase, you can
use the SQLDatabaseName or SQLDatabaseID parameter.
These parameters cannot be used together.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricSQLDatabase `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -SQLDatabaseName 'MySQLDatabase'
```

This example will retrieve the SQLDatabase with the name 'MySQLDatabase'.

### EXAMPLE 2
```
Get-FabricSQLDatabase
```

This example will retrieve all SQLDatabases in the workspace that is specified
by the WorkspaceId.

### EXAMPLE 3
```
Get-FabricSQLDatabase `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -SQLDatabaseId '12345678-1234-1234-1234-123456789012'
```

This example will retrieve the SQLDatabase with the ID '12345678-1234-1234-1234-123456789012'.

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
Type: System.String
Parameter Sets: (All)
Aliases: Id

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SQLDatabaseName
The name of the KQLDatabase to retrieve.
This parameter cannot be used together with SQLDatabaseID.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name, DisplayName

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
Id of the Fabric Workspace for which the SQLDatabases should be retrieved.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Revision History:
    - 2025-03-06 - KNO: Init version of the function

## RELATED LINKS
