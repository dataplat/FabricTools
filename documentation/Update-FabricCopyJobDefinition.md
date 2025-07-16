---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Update-FabricCopyJobDefinition

## SYNOPSIS
Updates the definition of a Copy Job in a Microsoft Fabric workspace.

## SYNTAX

```
Update-FabricCopyJobDefinition [-WorkspaceId] <Guid> [-CopyJobId] <Guid> [-CopyJobPathDefinition] <String>
 [[-CopyJobPathPlatformDefinition] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function updates the content or metadata of a Copy Job within a Microsoft Fabric workspace.
The Copy Job content and platform-specific definitions can be provided as file paths, which will be encoded as Base64 and sent in the request.

## EXAMPLES

### EXAMPLE 1
```
Update-FabricCopyJobDefinition -WorkspaceId "12345" -CopyJobId "67890" -CopyJobPathDefinition "C:\CopyJobs\CopyJob.ipynb"
```

Updates the content of the Copy Job with ID \`67890\` in the workspace \`12345\` using the specified Copy Job file.

### EXAMPLE 2
```
Update-FabricCopyJobDefinition -WorkspaceId "12345" -CopyJobId "67890" -CopyJobPathDefinition "C:\CopyJobs\CopyJob.ipynb" -CopyJobPathPlatformDefinition "C:\CopyJobs\Platform.json"
```

Updates both the content and platform-specific definition of the Copy Job with ID \`67890\` in the workspace \`12345\`.

## PARAMETERS

### -CopyJobId
(Mandatory) The unique identifier of the Copy Job to be updated.

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

### -CopyJobPathDefinition
(Mandatory) The file path to the Copy Job content definition file.
The file content will be encoded as Base64.

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

### -CopyJobPathPlatformDefinition
(Optional) The file path to the platform-specific definition file for the Copy Job.
The file content will be encoded as Base64.

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
(Mandatory) The unique identifier of the workspace containing the Copy Job.

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
- Requires the \`$FabricConfig\` global configuration, which must include \`BaseUrl\` and \`FabricHeaders\`.
- Validates token expiration using \`Confirm-TokenState\` before making the API request.
- Encodes file content as Base64 before sending it to the Fabric API.
- Logs detailed messages for debugging and error handling.

Author: Tiago Balabuch

## RELATED LINKS
