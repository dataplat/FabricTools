# Get-FabricItem

## SYNOPSIS
Retrieves fabric items from a workspace.

## SYNTAX

```
Get-FabricItem [-workspaceId] <String> [[-type] <String>] [[-itemID] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricItem function retrieves fabric items from a specified workspace.
It can retrieve all items or filter them by item type.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricItem -workspaceId "12345" -type "file"
```

This example retrieves all fabric items of type "file" from the workspace with ID "12345".

## PARAMETERS

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

### -type
(Optional) The type of the fabric items to retrieve.
If not specified, all items will be retrieved.

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

### -workspaceId
The ID of the workspace from which to retrieve the fabric items.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function was originally written by Rui Romano.
https://github.com/RuiRomano/fabricps-pbip

## RELATED LINKS
