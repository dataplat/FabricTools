# New-FabricEventhouse

## SYNOPSIS
Creates a new Fabric Eventhouse

## SYNTAX

```
New-FabricEventhouse [-WorkspaceID] <String> [-EventhouseName] <String> [[-EventhouseDescription] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Fabric Eventhouse

## EXAMPLES

### EXAMPLE 1
```
New-FabricEventhouse `
    -WorkspaceID '12345678-1234-1234-1234-123456789012' `
    -EventhouseName 'MyEventhouse' `
    -EventhouseDescription 'This is my Eventhouse'
```

This example will create a new Eventhouse with the name 'MyEventhouse' and the description 'This is my Eventhouse'.

### EXAMPLE 2
```
New-FabricEventhouse `
    -WorkspaceID '12345678-1234-1234-1234-123456789012' `
    -EventhouseName 'MyEventhouse' `
    -EventhouseDescription 'This is my Eventhouse' `
    -Verbose
```

This example will create a new Eventhouse with the name 'MyEventhouse' and the description 'This is my Eventhouse'.
It will also give you verbose output which is useful for debugging.

## PARAMETERS

### -EventhouseDescription
The description of the Eventhouse to create.

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

### -EventhouseName
The name of the Eventhouse to create.

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
Id of the Fabric Workspace for which the Eventhouse should be created.
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
- 2024-11-09 - FGE: Added DisplaName as Alias for EventhouseName
- 2024-11-27 - FGE: Added Verbose Output

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP)

