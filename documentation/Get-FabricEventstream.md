# Get-FabricEventstream

## SYNOPSIS
Retrieves Fabric Eventstreams

## SYNTAX

```
Get-FabricEventstream [-WorkspaceId] <String> [[-EventstreamName] <String>] [[-EventstreamId] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves Fabric Eventstreams.
Without the EventstreamName or EventstreamID parameter, all Eventstreams are returned.
If you want to retrieve a specific Eventstream, you can use the EventstreamName or EventstreamID parameter.
These
parameters cannot be used together.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricEventstream `
    -WorkspaceId '12345678-1234-1234-1234-123456789012'
```

This example will give you all Eventstreams in the Workspace.

### EXAMPLE 2
```
Get-FabricEventstream `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventstreamName 'MyEventstream'
```

This example will give you all Information about the Eventstream with the name 'MyEventstream'.

### EXAMPLE 3
```
Get-FabricEventstream `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventstreamId '12345678-1234-1234-1234-123456789012'
```

This example will give you all Information about the Eventstream with the Id '12345678-1234-1234-1234-123456789012'.

## PARAMETERS

### -EventstreamId
The Id of the Eventstream to retrieve.
This parameter cannot be used together with EventstreamName.
The value for EventstreamId is a GUID.
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

### -EventstreamName
The name of the Eventstream to retrieve.
This parameter cannot be used together with EventstreamID.

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
Id of the Fabric Workspace for which the Eventstreams should be retrieved.
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
TODO: Add functionality to list all Eventhouses.
To do so fetch all workspaces and
      then all eventhouses in each workspace.

Revision History:
    - 2024-11-09 - FGE: Added DisplaName as Alias for EventStreamName
    - 2024-11-27 - FGE: Added Verbose Output

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/eventstream/items/get-eventstream?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/eventstream/items/get-eventstream?tabs=HTTP)

