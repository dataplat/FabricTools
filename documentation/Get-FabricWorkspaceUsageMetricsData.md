---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricWorkspaceUsageMetricsData

## SYNOPSIS
Retrieves workspace usage metrics data.

## SYNTAX

```
Get-FabricWorkspaceUsageMetricsData [-WorkspaceId] <Guid> [[-username] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricWorkspaceUsageMetricsData function retrieves workspace usage metrics.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricWorkspaceUsageMetricsData -workspaceId "your-workspace-id" -username "your-username"
```

This example retrieves the workspace usage metrics for a specific workspace given the workspace ID and username.

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

### -username
The username.
This is a mandatory parameter.

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

### -WorkspaceId
The ID of the workspace.
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

## OUTPUTS

## NOTES
The function retrieves the PowerBI access token and creates a new usage metrics report.
It then defines the names of the reports to retrieve, initializes an empty hashtable to store the reports, and for each report name, retrieves the report and adds it to the hashtable.
It then returns the hashtable of reports.

Author: Ioana Bouariu

## RELATED LINKS
