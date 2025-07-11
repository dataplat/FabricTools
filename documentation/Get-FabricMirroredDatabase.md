---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricMirroredDatabase

## SYNOPSIS
Retrieves an MirroredDatabase or a list of MirroredDatabases from a specified workspace in Microsoft Fabric.

## SYNTAX

```
Get-FabricMirroredDatabase [-WorkspaceId] <Guid> [[-MirroredDatabaseId] <Guid>]
 [[-MirroredDatabaseName] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricMirroredDatabase\` function sends a GET request to the Fabric API to retrieve MirroredDatabase details for a given workspace.
It can filter the results by \`MirroredDatabaseName\`.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricMirroredDatabase -WorkspaceId "12345" -MirroredDatabaseName "Development"
```

Retrieves the "Development" MirroredDatabase from workspace "12345".

### EXAMPLE 2
```
Get-FabricMirroredDatabase -WorkspaceId "12345"
```

Retrieves all MirroredDatabases in workspace "12345".

## PARAMETERS

### -MirroredDatabaseId
(Optional) The ID of a specific MirroredDatabase to retrieve.

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

### -MirroredDatabaseName
(Optional) The name of the specific MirroredDatabase to retrieve.

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
(Mandatory) The ID of the workspace to query MirroredDatabases.

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
