# Remove-FabricEventstream

## SYNOPSIS
Removes an existing Fabric Eventstream

## SYNTAX

```
Remove-FabricEventstream [-WorkspaceId] <String> [[-EventstreamId] <String>] [[-EventstreamName] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes an existing Fabric Eventstream

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricEventstream `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventstreamId '12345678-1234-1234-1234-123456789012'
```

This example will delete the Eventstream with the Id '12345678-1234-1234-1234-123456789012' from
the Workspace.

### EXAMPLE 2
```
Remove-FabricEventstream `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventstreamName 'MyEventstream'
```

This example will delete the Eventstream with the name 'MyEventstream' from the Workspace.

## PARAMETERS

### -EventstreamId
The Id of the Eventstream to delete.
The value for Eventstream is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Id

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventstreamName
{{ Fill EventstreamName Description }}

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name, DisplayName

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
Id of the Fabric Workspace for which the Eventstream should be deleted.
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
Revsion History:

- 2024-11-07 - FGE: Implemented SupportShouldProcess
- 2024-11-09 - FGE: Added DisplaName as Alias for EventStreamName
- 2024-12-08 - FGE: Added Verbose Output

## RELATED LINKS
