---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricDataPipeline

## SYNOPSIS
Retrieves data pipelines from a specified Microsoft Fabric workspace.

## SYNTAX

```
Get-FabricDataPipeline [-WorkspaceId] <Guid> [[-DataPipelineId] <Guid>] [[-DataPipelineName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves all data pipelines from a specified workspace using either the provided Data PipelineId or Data PipelineName.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDataPipeline -WorkspaceId "workspace-12345" -Data PipelineId "Data Pipeline-67890"
This example retrieves the Data Pipeline details for the Data Pipeline with ID "Data Pipeline-67890" in the workspace with ID "workspace-12345".
```

### EXAMPLE 2
```
Get-FabricDataPipeline -WorkspaceId "workspace-12345" -Data PipelineName "My Data Pipeline"
This example retrieves the Data Pipeline details for the Data Pipeline named "My Data Pipeline" in the workspace with ID "workspace-12345".
```

## PARAMETERS

### -DataPipelineId
The unique identifier of the Data Pipeline to retrieve.
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

### -DataPipelineName
The name of the Data Pipeline to retrieve.
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
The unique identifier of the workspace where the Data Pipeline exists.
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
