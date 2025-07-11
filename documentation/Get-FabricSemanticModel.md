---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricSemanticModel

## SYNOPSIS
Retrieves SemanticModel details from a specified Microsoft Fabric workspace.

## SYNTAX

```
Get-FabricSemanticModel [-WorkspaceId] <Guid> [[-SemanticModelId] <Guid>] [[-SemanticModelName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves SemanticModel details from a specified workspace using either the provided SemanticModelId or SemanticModelName.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricSemanticModel -WorkspaceId "workspace-12345" -SemanticModelId "SemanticModel-67890"
This example retrieves the SemanticModel details for the SemanticModel with ID "SemanticModel-67890" in the workspace with ID "workspace-12345".
```

### EXAMPLE 2
```
Get-FabricSemanticModel -WorkspaceId "workspace-12345" -SemanticModelName "My SemanticModel"
This example retrieves the SemanticModel details for the SemanticModel named "My SemanticModel" in the workspace with ID "workspace-12345".
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

### -SemanticModelId
The unique identifier of the SemanticModel to retrieve.
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

### -SemanticModelName
The name of the SemanticModel to retrieve.
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
