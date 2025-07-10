---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricSemanticModelDefinition

## SYNOPSIS
Retrieves the definition of an SemanticModel from a specified Microsoft Fabric workspace.

## SYNTAX

```
Get-FabricSemanticModelDefinition [-WorkspaceId] <Guid> [[-SemanticModelId] <Guid>]
 [[-SemanticModelFormat] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the definition of an SemanticModel from a specified workspace using the provided SemanticModelId.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricSemanticModelDefinition -WorkspaceId "workspace-12345" -SemanticModelId "SemanticModel-67890"
This example retrieves the definition of the SemanticModel with ID "SemanticModel-67890" in the workspace with ID "workspace-12345".
```

### EXAMPLE 2
```
Get-FabricSemanticModelDefinition -WorkspaceId "workspace-12345" -SemanticModelId "SemanticModel-67890" -SemanticModelFormat "json"
This example retrieves the definition of the SemanticModel with ID "SemanticModel-67890" in the workspace with ID "workspace-12345" in JSON format.
```

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

### -SemanticModelFormat
The format in which to retrieve the SemanticModel definition.
This parameter is optional.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: TMDL
Accept pipeline input: False
Accept wildcard characters: False
```

### -SemanticModelId
The unique identifier of the SemanticModel to retrieve the definition for.
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

### -WorkspaceId
The unique identifier of the workspace where the SemanticModel exists.
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
