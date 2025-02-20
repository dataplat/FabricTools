# Remove-FabricItem

## SYNOPSIS
Removes selected items from a Fabric workspace.

## SYNTAX

```
Remove-FabricItem [-workspaceId] <String> [[-filter] <String>] [[-itemID] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-FabricItems function removes selected items from a specified Fabric workspace.
It uses the workspace ID and an optional filter to select the items to remove.
If a filter is provided, only items whose DisplayName matches the filter are removed.

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricItems -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef" -Filter "*test*"
```

This command removes all items from the workspace with the specified ID whose DisplayName includes "test".

## PARAMETERS

### -filter
An optional filter to select items to remove.
If provided, only items whose DisplayName matches the filter are removed.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -itemID
{{ Fill itemID Description }}

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

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

### -workspaceId
The ID of the Fabric workspace.
This is a mandatory parameter.

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

### String. You can pipe two strings that contain the workspace ID and filter to Remove-FabricItems.
## OUTPUTS

### None. This function does not return any output.
## NOTES
This function was written by Rui Romano.
https://github.com/RuiRomano/fabricps-pbip

## RELATED LINKS
