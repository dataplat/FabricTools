---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricNotebook

## SYNOPSIS
Retrieves an Notebook or a list of Notebooks from a specified workspace in Microsoft Fabric.

## SYNTAX

```
Get-FabricNotebook [-WorkspaceId] <Guid> [[-NotebookId] <Guid>] [[-NotebookName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricNotebook\` function sends a GET request to the Fabric API to retrieve Notebook details for a given workspace.
It can filter the results by \`NotebookName\`.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricNotebook -WorkspaceId "12345" -NotebookName "Development"
```

Retrieves the "Development" Notebook from workspace "12345".

### EXAMPLE 2
```
Get-FabricNotebook -WorkspaceId "12345"
```

Retrieves all Notebooks in workspace "12345".

## PARAMETERS

### -NotebookId
(Optional) The ID of a specific Notebook to retrieve.

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

### -NotebookName
(Optional) The name of the specific Notebook to retrieve.

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

### -WorkspaceId
(Mandatory) The ID of the workspace to query Notebooks.

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

Author: Tiago Balabuch

## RELATED LINKS
