---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricEventhouseDefinition

## SYNOPSIS
Retrieves the definition of an Eventhouse from a specified Microsoft Fabric workspace.

## SYNTAX

```
Get-FabricEventhouseDefinition [-WorkspaceId] <Guid> [[-EventhouseId] <Guid>] [[-EventhouseFormat] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the definition of an Eventhouse from a specified workspace using the provided EventhouseId.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricEventhouseDefinition -WorkspaceId "workspace-12345" -EventhouseId "eventhouse-67890"
This example retrieves the definition of the Eventhouse with ID "eventhouse-67890" in the workspace with ID "workspace-12345".
```

### EXAMPLE 2
```
Get-FabricEventhouseDefinition -WorkspaceId "workspace-12345" -EventhouseId "eventhouse-67890" -EventhouseFormat "json"
This example retrieves the definition of the Eventhouse with ID "eventhouse-67890" in the workspace with ID "workspace-12345" in JSON format.
```

## PARAMETERS

### -EventhouseFormat
The format in which to retrieve the Eventhouse definition.
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

### -EventhouseId
The unique identifier of the Eventhouse to retrieve the definition for.
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
The unique identifier of the workspace where the Eventhouse exists.
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
