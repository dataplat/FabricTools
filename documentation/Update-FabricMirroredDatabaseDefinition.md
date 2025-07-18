---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Update-FabricMirroredDatabaseDefinition

## SYNOPSIS
Updates the definition of a MirroredDatabase in a Microsoft Fabric workspace.

## SYNTAX

```
Update-FabricMirroredDatabaseDefinition [-WorkspaceId] <Guid> [-MirroredDatabaseId] <Guid>
 [-MirroredDatabasePathDefinition] <String> [[-MirroredDatabasePathPlatformDefinition] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function allows updating the content or metadata of a MirroredDatabase in a Microsoft Fabric workspace.
The MirroredDatabase content can be provided as file paths, and metadata updates can optionally be enabled.

## EXAMPLES

### EXAMPLE 1
```
Update-FabricMirroredDatabaseDefinition -WorkspaceId "12345" -MirroredDatabaseId "67890" -MirroredDatabasePathDefinition "C:\MirroredDatabases\MirroredDatabase.json"
```

Updates the content of the MirroredDatabase with ID \`67890\` in the workspace \`12345\` using the specified MirroredDatabase file.

### EXAMPLE 2
```
Update-FabricMirroredDatabaseDefinition -WorkspaceId "12345" -MirroredDatabaseId "67890" -MirroredDatabasePathDefinition "C:\MirroredDatabases\MirroredDatabase.json" -UpdateMetadata $true
```

Updates both the content and metadata of the MirroredDatabase with ID \`67890\` in the workspace \`12345\`.

## PARAMETERS

### -MirroredDatabaseId
(Mandatory) The unique identifier of the MirroredDatabase to be updated.

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

### -MirroredDatabasePathDefinition
(Mandatory) The file path to the MirroredDatabase content definition file.
The content will be encoded as Base64 and sent in the request.

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

### -MirroredDatabasePathPlatformDefinition
(Optional) The file path to the MirroredDatabase's platform-specific definition file.
The content will be encoded as Base64 and sent in the request.

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
- The MirroredDatabase content is encoded as Base64 before being sent to the Fabric API.
- This function handles asynchronous operations and retrieves operation results if required.

Author: Tiago Balabuch

## RELATED LINKS
