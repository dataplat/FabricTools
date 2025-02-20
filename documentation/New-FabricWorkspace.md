# New-FabricWorkspace

## SYNOPSIS
Creates a new Fabric workspace.

## SYNTAX

```
New-FabricWorkspace [[-name] <String>] [-skipErrorIfExists] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-FabricWorkspace function creates a new Fabric workspace.
It uses the provided name to create the workspace.
If the workspace already exists and the skipErrorIfExists switch is provided, it does not throw an error.

## EXAMPLES

### EXAMPLE 1
```
New-FabricWorkspace -Name "NewWorkspace" -SkipErrorIfExists
```

This command creates a new Fabric workspace named "NewWorkspace".
If the workspace already exists, it does not throw an error.

## PARAMETERS

### -name
The name of the new Fabric workspace.
This is a mandatory parameter.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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

### -skipErrorIfExists
A switch that indicates whether to skip the error if the workspace already exists.
If provided, the function does not throw an error if the workspace already exists.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### String, Switch. You can pipe a string that contains the name and a switch that indicates whether to skip the error if the workspace already exists to New-FabricWorkspace.
## OUTPUTS

### String. This function returns the ID of the new Fabric workspace.
## NOTES
This function was originally written by Rui Romano.
https://github.com/RuiRomano/fabricps-pbip

## RELATED LINKS
