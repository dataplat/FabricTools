# Remove-FabricSQLDatabase

## SYNOPSIS
Removes an existing Fabric SQL Database

## SYNTAX

```
Remove-FabricSQLDatabase [-WorkspaceId] <String> [-SQLDatabaseId] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Removes an existing Fabric SQL Database.
The SQL Database is removed from the specified Workspace.

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricSQLDatabase `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -SQLDatabaseId '12345678-1234-1234-1234-123456789012'
```

This example will remove the SQL Database with the Id '12345678-1234-1234-1234-123456789012'.

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
The Id of the SQL Database to remove.
The value for EventhouseId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
Id of the Fabric Workspace from which the SQL Database should be removed.
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
TODO: Add functionality to remove SQLDatabase by name.

Revsion History:
- 2025-03-06 - KNO: Init version

## RELATED LINKS
