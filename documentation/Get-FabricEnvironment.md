---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricEnvironment

## SYNOPSIS
Retrieves an environment or a list of environments from a specified workspace in Microsoft Fabric.

## SYNTAX

```
Get-FabricEnvironment [-WorkspaceId] <Guid> [[-EnvironmentId] <Guid>] [[-EnvironmentName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricEnvironment\` function sends a GET request to the Fabric API to retrieve environment details for a given workspace.
It can filter the results by \`EnvironmentName\`.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricEnvironment -WorkspaceId "12345" -EnvironmentName "Development"
```

Retrieves the "Development" environment from workspace "12345".

### EXAMPLE 2
```
Get-FabricEnvironment -WorkspaceId "12345"
```

Retrieves all environments in workspace "12345".

## PARAMETERS

### -EnvironmentId
(Optional) The ID of a specific environment to retrieve.

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

### -EnvironmentName
(Optional) The name of the specific environment to retrieve.

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
(Mandatory) The ID of the workspace to query environments.

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
- Returns the matching environment details or all environments if no filter is provided.

Author: Tiago Balabuch

## RELATED LINKS
