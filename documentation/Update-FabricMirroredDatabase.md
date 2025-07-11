---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Update-FabricMirroredDatabase

## SYNOPSIS
Updates the properties of a Fabric MirroredDatabase.

## SYNTAX

```
Update-FabricMirroredDatabase [-WorkspaceId] <Guid> [-MirroredDatabaseId] <Guid>
 [-MirroredDatabaseName] <String> [[-MirroredDatabaseDescription] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The \`Update-FabricMirroredDatabase\` function updates the name and/or description of a specified Fabric MirroredDatabase by making a PATCH request to the API.

## EXAMPLES

### EXAMPLE 1
```
Update-FabricMirroredDatabase -MirroredDatabaseId "MirroredDatabase123" -MirroredDatabaseName "NewMirroredDatabaseName"
```

Updates the name of the MirroredDatabase with the ID "MirroredDatabase123" to "NewMirroredDatabaseName".

### EXAMPLE 2
```
Update-FabricMirroredDatabase -MirroredDatabaseId "MirroredDatabase123" -MirroredDatabaseName "NewName" -MirroredDatabaseDescription "Updated description"
```

Updates both the name and description of the MirroredDatabase "MirroredDatabase123".

## PARAMETERS

### -MirroredDatabaseDescription
(Optional) The new description for the MirroredDatabase.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MirroredDatabaseId
The unique identifier of the MirroredDatabase to be updated.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MirroredDatabaseName
The new name for the MirroredDatabase.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
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
(Mandatory) The unique identifier of the workspace where the MirroredDatabase resides.

```yaml
Type: System.Guid
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
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
