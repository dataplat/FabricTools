---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricEnvironmentSparkCompute

## SYNOPSIS
Retrieves the Spark compute details for a specific environment in a Microsoft Fabric workspace.

## SYNTAX

```
Get-FabricEnvironmentSparkCompute [-WorkspaceId] <Guid> [-EnvironmentId] <Guid>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricEnvironmentSparkCompute function communicates with the Microsoft Fabric API to fetch information
about Spark compute resources associated with a specified environment.
It ensures that the API token is valid
and gracefully handles errors during the API call.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricEnvironmentSparkCompute -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"
```

Retrieves Spark compute details for the specified environment in the given workspace.

## PARAMETERS

### -EnvironmentId
The unique identifier of the environment whose Spark compute details are being retrieved.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: True
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
The unique identifier of the workspace containing the target environment.

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
- Requires the \`$FabricConfig\` global object, including \`BaseUrl\` and \`FabricHeaders\`.
- Uses \`Confirm-TokenState\` to validate the token before making API calls.

Author: Tiago Balabuch

## RELATED LINKS
