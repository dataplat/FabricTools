---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Update-FabricReflexDefinition

## SYNOPSIS
Updates the definition of an existing Reflex in a specified Microsoft Fabric workspace.

## SYNTAX

```
Update-FabricReflexDefinition [-WorkspaceId] <Guid> [-ReflexId] <Guid> [-ReflexPathDefinition] <String>
 [[-ReflexPathPlatformDefinition] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function sends a PATCH request to the Microsoft Fabric API to update the definition of an existing Reflex
in the specified workspace.
It supports optional parameters for Reflex definition and platform-specific definition.

## EXAMPLES

### EXAMPLE 1
```
Update-FabricReflexDefinition -WorkspaceId "workspace-12345" -ReflexId "Reflex-67890" -ReflexPathDefinition "C:\Path\To\ReflexDefinition.json"
This example updates the definition of the Reflex with ID "Reflex-67890" in the workspace with ID "workspace-12345" using the provided definition file.
```

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

### -ReflexId
The unique identifier of the Reflex to be updated.
This parameter is mandatory.

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

### -ReflexPathDefinition
An optional path to the Reflex definition file to upload.

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

### -ReflexPathPlatformDefinition
An optional path to the platform-specific definition file to upload.

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

### -WorkspaceId
The unique identifier of the workspace where the Reflex exists.
This parameter is mandatory.

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
