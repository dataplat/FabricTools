---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricMirroredDatabaseTableStatus

## SYNOPSIS
Retrieves the status of tables in a mirrored database.

## SYNTAX

```
Get-FabricMirroredDatabaseTableStatus [-WorkspaceId] <Guid> [[-MirroredDatabaseId] <Guid>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the status of tables in a mirrored database.
The function validates the authentication token, constructs the API endpoint URL, and makes a POST request to retrieve the mirroring status of tables.
It handles errors and logs messages at various levels (Debug, Error).

## EXAMPLES

### EXAMPLE 1
```
Get-FabricMirroredDatabaseTableStatus -WorkspaceId "your-workspace-id" -MirroredDatabaseId "your-mirrored-database-id"
This example retrieves the status of tables in a mirrored database with the specified ID in the specified workspace.
```

## PARAMETERS

### -MirroredDatabaseId
The ID of the mirrored database whose table status is to be retrieved.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

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
The ID of the workspace containing the mirrored database.

```yaml
Type: System.Guid
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

### System.Object[]
## NOTES
The function retrieves the PowerBI access token and makes a POST request to the PowerBI API to retrieve the status of tables in the specified mirrored database.
It then returns the 'value' property of the response, which contains the table statuses.

Author: Tiago Balabuch

## RELATED LINKS
