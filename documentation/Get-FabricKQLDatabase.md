---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricKQLDatabase

## SYNOPSIS
Retrieves an KQLDatabase or a list of KQLDatabases from a specified workspace in Microsoft Fabric.

## SYNTAX

```
Get-FabricKQLDatabase [-WorkspaceId] <Guid> [[-KQLDatabaseId] <Guid>] [[-KQLDatabaseName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricKQLDatabase\` function sends a GET request to the Fabric API to retrieve KQLDatabase details for a given workspace.
It can filter the results by \`KQLDatabaseName\`.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricKQLDatabase -WorkspaceId "12345" -KQLDatabaseName "Development"
```

Retrieves the "Development" KQLDatabase from workspace "12345".

### EXAMPLE 2
```
Get-FabricKQLDatabase -WorkspaceId "12345"
```

Retrieves all KQLDatabases in workspace "12345".

## PARAMETERS

### -KQLDatabaseId
(Optional) The ID of a specific KQLDatabase to retrieve.

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

### -KQLDatabaseName
(Optional) The name of the specific KQLDatabase to retrieve.

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
(Mandatory) The ID of the workspace to query KQLDatabases.

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
