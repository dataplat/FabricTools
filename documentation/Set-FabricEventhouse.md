# Set-FabricEventhouse

## SYNOPSIS
Updates Properties of an existing Fabric Eventhouse

## SYNTAX

```
Set-FabricEventhouse [-WorkspaceId] <String> [-EventhouseId] <String> [[-EventhouseNewName] <String>]
 [[-EventhouseDescription] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates Properties of an existing Fabric Eventhouse

## EXAMPLES

### EXAMPLE 1
```
Set-FabricEventhouse `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventhouseId '12345678-1234-1234-1234-123456789012' `
    -EventhouseNewName 'MyNewEventhouse' `
    -EventhouseDescription 'This is my new Eventhouse'
```

This example will update the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'
in the Workspace with the Id '12345678-1234-1234-1234-123456789012' to
have the name 'MyNewEventhouse' and the description
'This is my new Eventhouse'.

### EXAMPLE 2
```
Set-FabricEventhouse `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventhouseId '12345678-1234-1234-1234-123456789012' `
    -EventhouseNewName 'MyNewEventhouse' `
    -EventhouseDescription 'This is my new Eventhouse' `
    -Verbose
```

This example will update the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'
in the Workspace with the Id '12345678-1234-1234-1234-123456789012' to
have the name 'MyNewEventhouse' and the description 'This is my new Eventhouse'.
It will also give you verbose output which is useful for debugging.

## PARAMETERS

### -EventhouseDescription
The new description of the Eventhouse.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Description

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventhouseId
The Id of the Eventhouse to update.
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

### -EventhouseNewName
The new name of the Eventhouse.

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
Id of the Fabric Workspace for which the Eventhouse should be updated.
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
TODO: Add functionality to update Eventhouse properties using EventhouseName instead of EventhouseId

Revsion History:

- 2024-11-07 - FGE: Implemented SupportShouldProcess
- 2024-11-09 - FGE: Added NewDisplaName as Alias for EventhouseName
- 2024-11-27 - FGE: Added Verbose Output

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP)

