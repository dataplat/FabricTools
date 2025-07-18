---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricItem

## SYNOPSIS
Retrieves fabric items from a workspace.

## SYNTAX

### WorkspaceId
```
Get-FabricItem -WorkspaceId <Guid> [-type <String>] [-itemID <Guid>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### WorkspaceObject
```
Get-FabricItem -Workspace <Object> [-type <String>] [-itemID <Guid>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
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
The ID of the specific item to retrieve.
If not specified, all items will be retrieved.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Aliases: itemType

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Workspace
The workspace object from which to retrieve the fabric items.
This parameter can be piped into the function.

```yaml
Type: System.Object
Parameter Sets: WorkspaceObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WorkspaceId
The ID of the workspace from which to retrieve the fabric items.

```yaml
Type: System.Guid
Parameter Sets: WorkspaceId
Aliases:

Required: True
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
Author: Rui Romano

## RELATED LINKS
