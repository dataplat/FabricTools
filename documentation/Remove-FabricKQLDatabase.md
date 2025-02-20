# Remove-FabricKQLDatabase

## SYNOPSIS
Removes an existing Fabric Eventhouse

## SYNTAX

```
Remove-FabricKQLDatabase [-WorkspaceId] <String> [-KQLDatabaseId] <String> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes an existing Fabric Eventhouse.
The Eventhouse is removed from the specified Workspace.

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricEventhouse `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -EventhouseId '12345678-1234-1234-1234-123456789012'
```

This example will remove the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.

## PARAMETERS

### -KQLDatabaseId
{{ Fill KQLDatabaseId Description }}

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
Id of the Fabric Workspace from which the Eventhouse should be removed.
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
TODO: Add functionality to remove Eventhouse by name.

Revsion History:

- 2024-12-08 - FGE: Added Verbose Output

## RELATED LINKS
