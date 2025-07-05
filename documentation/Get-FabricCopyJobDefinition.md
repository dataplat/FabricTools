---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricCopyJobDefinition

## SYNOPSIS
Retrieves the definition of a Copy Job from a specific workspace in Microsoft Fabric.

## SYNTAX

```
Get-FabricCopyJobDefinition [-WorkspaceId] <Guid> [-CopyJobId] <Guid> [[-CopyJobFormat] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function fetches the Copy Job's content or metadata from a workspace.
It supports both synchronous and asynchronous operations, with detailed logging and error handling.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricCopyJobDefinition -WorkspaceId "12345" -CopyJobId "67890"
```

Retrieves the definition of the Copy Job with ID \`67890\` from the workspace with ID \`12345\`.

## PARAMETERS

### -CopyJobFormat
(Optional) Specifies the format of the Copy Job definition.
For example, 'json' or 'xml'.

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

### -CopyJobId
(Mandatory) The unique identifier of the Copy Job whose definition needs to be retrieved.

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
(Mandatory) The unique identifier of the workspace from which the Copy Job definition is to be retrieved.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.
- Handles long-running operations asynchronously.
- Logs detailed information for debugging purposes.

Author: Tiago Balabuch

## RELATED LINKS
