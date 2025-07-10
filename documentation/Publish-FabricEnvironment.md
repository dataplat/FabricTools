---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Publish-FabricEnvironment

## SYNOPSIS
Publishes a staging environment in a specified Microsoft Fabric workspace.

## SYNTAX

```
Publish-FabricEnvironment [-WorkspaceId] <Guid> [-EnvironmentId] <Guid> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function interacts with the Microsoft Fabric API to initiate the publishing process for a staging environment.
It validates the authentication token, constructs the API request, and handles both immediate and long-running operations.

## EXAMPLES

### EXAMPLE 1
```
Publish-FabricEnvironment -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"
```

Initiates the publishing process for the specified staging environment.

## PARAMETERS

### -EnvironmentId
The unique identifier of the staging environment to be published.

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
The unique identifier of the workspace containing the staging environment.

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
