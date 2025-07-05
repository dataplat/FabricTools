---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Remove-FabricEventstream

## SYNOPSIS
Deletes an Eventstream from a specified workspace in Microsoft Fabric.

## SYNTAX

```
Remove-FabricEventstream [-WorkspaceId] <Guid> [-EventstreamId] <Guid> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The \`Remove-FabricEventstream\` function sends a DELETE request to the Fabric API to remove a specified Eventstream from a given workspace.

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricEventstream -WorkspaceId "12345" -EventstreamId "67890"
```

Deletes the Eventstream with ID "67890" from workspace "12345".

## PARAMETERS

### -EventstreamId
(Mandatory) The ID of the Eventstream to be deleted.

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
(Mandatory) The ID of the workspace containing the Eventstream to delete.

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
- Validates token expiration before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
