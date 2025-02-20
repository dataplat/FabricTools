# Set-FabricEventstream

## SYNOPSIS
Updates Properties of an existing Fabric Eventstream

## SYNTAX

```
Set-FabricEventstream [-WorkspaceId] <String> [-EventstreamId] <String> [[-EventstreamNewName] <String>]
 [[-EventstreamDescription] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates Properties of an existing Fabric Eventstream

## EXAMPLES

### EXAMPLE 1
```
Set-FabricEventstream `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventstreamId '12345678-1234-1234-1234-123456789012' `
    -EventstreamNewName 'MyNewEventstream' `
    -EventstreamDescription 'This is my new Eventstream'
```

This example will update the Eventstream with the Id '12345678-1234-1234-1234-123456789012'.

## PARAMETERS

### -EventstreamDescription
The new description of the Eventstream.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Description, NewDescription, EventstreamNewDescription

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventstreamId
The Id of the Eventstream to update.
The value for EventstreamId is a GUID.
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

### -EventstreamNewName
The new name of the Eventstream.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: NewName, NewDisplayName

Required: False
Position: 3
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
Id of the Fabric Workspace for which the Eventstream should be updated.
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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
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
TODO: Add functionality to update Eventstream properties using EventstreamName instead of EventstreamId

Revsion History:

- 2024-11-07 - FGE: Implemented SupportShouldProcess
- 2024-11-09 - FGE: Added DisplaName as Alias for EventStreamNewName
- 2024-12-08 - FGE: Added Verbose Output
                    Added Aliases for EventstreamNewName and EventstreamDescription
                    Corrected typo in EventstreamNewName Variable

## RELATED LINKS
