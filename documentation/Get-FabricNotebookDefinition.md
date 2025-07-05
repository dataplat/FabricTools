---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricNotebookDefinition

## SYNOPSIS
Retrieves the definition of a notebook from a specific workspace in Microsoft Fabric.

## SYNTAX

```
Get-FabricNotebookDefinition [-WorkspaceId] <Guid> [[-NotebookId] <Guid>] [[-NotebookFormat] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function fetches the notebook's content or metadata from a workspace.
It supports retrieving notebook definitions in the Jupyter Notebook (\`ipynb\`) format.
Handles both synchronous and asynchronous operations, with detailed logging and error handling.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricNotebookDefinition -WorkspaceId "12345" -NotebookId "67890"
```

Retrieves the definition of the notebook with ID \`67890\` from the workspace with ID \`12345\` in the \`ipynb\` format.

### EXAMPLE 2
```
Get-FabricNotebookDefinition -WorkspaceId "12345"
```

Retrieves the definitions of all notebooks in the workspace with ID \`12345\` in the \`ipynb\` format.

## PARAMETERS

### -NotebookFormat
Specifies the format of the notebook definition.
Currently, only 'ipynb' is supported.
Default: 'ipynb'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Ipynb
Accept pipeline input: False
Accept wildcard characters: False
```

### -NotebookId
(Optional)The unique identifier of the notebook whose definition needs to be retrieved.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
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
(Mandatory) The unique identifier of the workspace from which the notebook definition is to be retrieved.

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

Author: Tiago Balabuch

## RELATED LINKS
