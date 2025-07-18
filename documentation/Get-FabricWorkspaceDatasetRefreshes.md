---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricWorkspaceDatasetRefreshes

## SYNOPSIS
Retrieves the refresh history of all datasets in a specified PowerBI workspace.

## SYNTAX

```
Get-FabricWorkspaceDatasetRefreshes [-WorkspaceID] <Guid> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricWorkspaceDatasetRefreshes function uses the PowerBI cmdlets to retrieve the refresh history of all datasets in a specified workspace.
It uses the workspace ID to get the workspace and its datasets, and then retrieves the refresh history for each dataset.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricWorkspaceDatasetRefreshes -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef"
```

This command retrieves the refresh history of all datasets in the workspace with the specified ID.

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

### -WorkspaceID
The ID of the PowerBI workspace.
This is a mandatory parameter.

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

### String. You can pipe a string that contains the workspace ID to Get-FabricWorkspaceDatasetRefreshes.
## OUTPUTS

### Array. Get-FabricWorkspaceDatasetRefreshes returns an array of refresh history objects.
## NOTES
Alias: Get-PowerBIWorkspaceDatasetRefreshes, Get-FabWorkspaceDatasetRefreshes

Author: Ioana Bouariu

## RELATED LINKS
