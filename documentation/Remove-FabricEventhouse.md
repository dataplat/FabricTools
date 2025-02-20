# Remove-FabricEventhouse

## SYNOPSIS
Removes an existing Fabric Eventhouse

## SYNTAX

```
Remove-FabricEventhouse [-WorkspaceId] <String> [[-EventhouseId] <String>] [[-EventhouseName] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes an existing Fabric Eventhouse

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricEventhouse `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventhouseId '12345678-1234-1234-1234-123456789012'
```

This example will delete the Eventhouse with the Id '12345678-1234-1234-1234-123456789012' from
the Workspace with the Id '12345678-1234-1234-1234-123456789012'.

### EXAMPLE 2
```
Remove-FabricEventhouse `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventhouseName 'MyEventhouse'
```

This example will delete the Eventhouse with the name 'MyEventhouse' from the Workspace with the
Id '12345678-1234-1234-1234-123456789012'.

## PARAMETERS

### -EventhouseId
The Id of the Eventhouse to delete.
The value for EventhouseId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.
EventhouseId and EventhouseName cannot be used together.

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

### -EventhouseName
The name of the Eventhouse to delete.
EventhouseId and EventhouseName cannot be used together.

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
Id of the Fabric Workspace for which the Eventhouse should be deleted.
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
- 2024-11-09 - FGE: Added DisplaName as Alias for EventhouseName
- 2024-11-27 - FGE: Added Verbose Output

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP)

