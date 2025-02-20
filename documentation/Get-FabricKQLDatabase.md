# Get-FabricKQLDatabase

## SYNOPSIS
Retrieves Fabric KQLDatabases

## SYNTAX

```
Get-FabricKQLDatabase [-WorkspaceId] <String> [[-KQLDatabaseName] <String>] [[-KQLDatabaseId] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves Fabric KQLDatabases.
Without the KQLDatabaseName or KQLDatabaseID parameter,
all KQLDatabases are returned.
If you want to retrieve a specific KQLDatabase, you can
use the KQLDatabaseName or KQLDatabaseID parameter.
These parameters cannot be used together.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricKQLDatabase `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -KQLDatabaseName 'MyKQLDatabase'
```

This example will retrieve the KQLDatabase with the name 'MyKQLDatabase'.

### EXAMPLE 2
```
Get-FabricKQLDatabase
```

This example will retrieve all KQLDatabases in the workspace that is specified
by the WorkspaceId.

### EXAMPLE 3
```
Get-FabricKQLDatabase `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -KQLDatabaseId '12345678-1234-1234-1234-123456789012'
```

This example will retrieve the KQLDatabase with the ID '12345678-1234-1234-1234-123456789012'.

## PARAMETERS

### -KQLDatabaseId
The Id of the KQLDatabase to retrieve.
This parameter cannot be used together with KQLDatabaseName.
The value for KQLDatabaseID is a GUID.
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

### -KQLDatabaseName
The name of the KQLDatabase to retrieve.
This parameter cannot be used together with KQLDatabaseID.

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

### -WorkspaceId
Id of the Fabric Workspace for which the KQLDatabases should be retrieved.
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
TODO: Add functionality to list all KQLDatabases.
To do so fetch all workspaces and
      then all KQLDatabases in each workspace.

Revision History:
    - 2024-11-09 - FGE: Added DisplaName as Alias for KQLDatabaseName
    - 2024-12-08 - FGE: Added Verbose Output

## RELATED LINKS
