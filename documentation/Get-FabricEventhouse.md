# Get-FabricEventhouse

## SYNOPSIS
Retrieves Fabric Eventhouses

## SYNTAX

```
Get-FabricEventhouse [-WorkspaceId] <String> [[-EventhouseName] <String>] [[-EventhouseId] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves Fabric Eventhouses.
Without the EventhouseName or EventhouseID parameter, all Eventhouses are returned.
If you want to retrieve a specific Eventhouse, you can use the EventhouseName or EventhouseID parameter.
These
parameters cannot be used together.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricEventhouse `
    -WorkspaceId '12345678-1234-1234-1234-123456789012'
```

This example will give you all Eventhouses in the Workspace.

### EXAMPLE 2
```
Get-FabricEventhouse `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventhouseName 'MyEventhouse'
```

This example will give you all Information about the Eventhouse with the name 'MyEventhouse'.

### EXAMPLE 3
```
Get-FabricEventhouse `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventhouseId '12345678-1234-1234-1234-123456789012'
```

This example will give you all Information about the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.

### EXAMPLE 4
```
Get-FabricEventhouse `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventhouseId '12345678-1234-1234-1234-123456789012' `
    -Verbose
```

This example will give you all Information about the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.
It will also give you verbose output which is useful for debugging.

## PARAMETERS

### -EventhouseId
The Id of the Eventhouse to retrieve.
This parameter cannot be used together with EventhouseName.
The value for WorkspaceId is a GUID.
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

### -EventhouseName
The name of the Eventhouse to retrieve.
This parameter cannot be used together with EventhouseID.

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
Id of the Fabric Workspace for which the Eventhouses should be retrieved.
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
TODO: Add functionality to list all Eventhouses in the subscription.
To do so fetch all workspaces
and then all eventhouses in each workspace.

Revsion History:

- 2024-11-09 - FGE: Added DisplaName as Alias for EventhouseName
- 2024-11-16 - FGE: Added Verbose Output
- 2024-11-27 - FGE: Added more Verbose Output

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP)

