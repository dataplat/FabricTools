---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricWorkspace

## SYNOPSIS
Retrieves details of a Microsoft Fabric workspace by its ID or name.

## SYNTAX

```
Get-FabricWorkspace [[-WorkspaceId] <Guid>] [[-WorkspaceName] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricWorkspace\` function fetches workspace details from the Fabric API.
It supports filtering by WorkspaceId or WorkspaceName.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricWorkspace -WorkspaceId "workspace123"
```

Fetches details of the workspace with ID "workspace123".

### EXAMPLE 2
```
Get-FabricWorkspace -WorkspaceName "MyWorkspace"
```

Fetches details of the workspace with the name "MyWorkspace".

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

### -WorkspaceId
The unique identifier of the workspace to retrieve.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceName
The display name of the workspace to retrieve.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
- Returns the matching workspace details or all workspaces if no filter is provided.

Author: Tiago Balabuch

## RELATED LINKS
