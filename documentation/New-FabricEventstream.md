# New-FabricEventstream

## SYNOPSIS
Creates a new Fabric Eventstream

## SYNTAX

```
New-FabricEventstream [-WorkspaceID] <String> [-EventstreamName] <String> [[-EventstreamDescription] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Fabric Eventstream

## EXAMPLES

### EXAMPLE 1
```
New-FabricEventstream
    -WorkspaceID '12345678-1234-1234-1234-123456789012'
    -EventstreamName 'MyEventstream'
    -EventstreamDescription 'This is my Eventstream'
```

This example will create a new Eventstream with the name 'MyEventstream' and the description 'This is my Eventstream'.

## PARAMETERS

### -EventstreamDescription
The description of the Eventstream to create.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Description

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventstreamName
The name of the Eventstream to create.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name, DisplayName

Required: True
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

### -WorkspaceID
Id of the Fabric Workspace for which the Eventstream should be created.
The value for WorkspaceID is a GUID.
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
- 2024-11-30 - FGE: Added Verbose Output

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/eventstream/items/create-eventstream?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/eventstream/items/create-eventstream?tabs=HTTP)

