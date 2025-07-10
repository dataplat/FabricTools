---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricMLExperiment

## SYNOPSIS
Retrieves ML Experiment details from a specified Microsoft Fabric workspace.

## SYNTAX

```
Get-FabricMLExperiment [-WorkspaceId] <Guid> [[-MLExperimentId] <Guid>] [[-MLExperimentName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves ML Experiment details from a specified workspace using either the provided MLExperimentId or MLExperimentName.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricMLExperiment -WorkspaceId "workspace-12345" -MLExperimentId "experiment-67890"
This example retrieves the ML Experiment details for the experiment with ID "experiment-67890" in the workspace with ID "workspace-12345".
```

### EXAMPLE 2
```
Get-FabricMLExperiment -WorkspaceId "workspace-12345" -MLExperimentName "My ML Experiment"
This example retrieves the ML Experiment details for the experiment named "My ML Experiment" in the workspace with ID "workspace-12345".
```

## PARAMETERS

### -MLExperimentId
The unique identifier of the ML Experiment to retrieve.
This parameter is optional.

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

### -MLExperimentName
The name of the ML Experiment to retrieve.
This parameter is optional.

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
The unique identifier of the workspace where the ML Experiment exists.
This parameter is mandatory.

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
