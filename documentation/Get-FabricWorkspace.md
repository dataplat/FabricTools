# Get-FabricWorkspace

## SYNOPSIS
Retrieves all Fabric workspaces.

## SYNTAX

```
Get-FabricWorkspace [[-workspaceId] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricWorkspace function retrieves all Fabric workspaces.
It invokes the Fabric API to get the workspaces and outputs the result.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricWorkspace
```

This command retrieves all Fabric workspaces.

## PARAMETERS

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
{{ Fill workspaceId Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe inputs to this function.
## OUTPUTS

### Object. This function returns the Fabric workspaces.
## NOTES
This function was originally written by Rui Romano.
https://github.com/RuiRomano/fabricps-pbip

## RELATED LINKS
