---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Update-FabricEventstreamDefinition

## SYNOPSIS
Updates the definition of a Eventstream in a Microsoft Fabric workspace.

## SYNTAX

```
Update-FabricEventstreamDefinition [-WorkspaceId] <Guid> [-EventstreamId] <Guid>
 [-EventstreamPathDefinition] <String> [[-EventstreamPathPlatformDefinition] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function allows updating the content or metadata of a Eventstream in a Microsoft Fabric workspace.
The Eventstream content can be provided as file paths, and metadata updates can optionally be enabled.

## EXAMPLES

### EXAMPLE 1
```
Update-FabricEventstreamDefinition -WorkspaceId "12345" -EventstreamId "67890" -EventstreamPathDefinition "C:\Eventstreams\Eventstream.ipynb"
```

Updates the content of the Eventstream with ID \`67890\` in the workspace \`12345\` using the specified Eventstream file.

### EXAMPLE 2
```
Update-FabricEventstreamDefinition -WorkspaceId "12345" -EventstreamId "67890" -EventstreamPathDefinition "C:\Eventstreams\Eventstream.ipynb" -UpdateMetadata $true
```

Updates both the content and metadata of the Eventstream with ID \`67890\` in the workspace \`12345\`.

## PARAMETERS

### -EventstreamId
(Mandatory) The unique identifier of the Eventstream to be updated.

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

### -EventstreamPathDefinition
(Mandatory) The file path to the Eventstream content definition file.
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

### -EventstreamPathPlatformDefinition
(Optional) The file path to the Eventstream's platform-specific definition file.
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
(Mandatory) The unique identifier of the workspace where the Eventstream resides.

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
- The Eventstream content is encoded as Base64 before being sent to the Fabric API.
- This function handles asynchronous operations and retrieves operation results if required.

Author: Tiago Balabuch

## RELATED LINKS
