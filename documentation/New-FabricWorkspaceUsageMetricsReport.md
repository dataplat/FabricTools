---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# New-FabricWorkspaceUsageMetricsReport

## SYNOPSIS
Retrieves the workspace usage metrics dataset ID.

## SYNTAX

```
New-FabricWorkspaceUsageMetricsReport [-WorkspaceId] <Guid> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-FabricWorkspaceUsageMetricsReport function retrieves the workspace usage metrics dataset ID.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1
```
New-FabricWorkspaceUsageMetricsReport -workspaceId "your-workspace-id"
```

This example retrieves the workspace usage metrics dataset ID for a specific workspace given the workspace ID.

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
The function retrieves the PowerBI access token and the Fabric API cluster URI.
It then makes a GET request to the Fabric API to retrieve the workspace usage metrics dataset ID, parses the response and replaces certain keys to match the expected format, and returns the 'dbName' property of the first model in the response, which is the dataset ID.

Author: Ioana Bouariu

## RELATED LINKS
