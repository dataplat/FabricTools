---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Import-FabricEnvironmentStagingLibrary

## SYNOPSIS
Uploads a library to the staging environment in a Microsoft Fabric workspace.

## SYNTAX

```
Import-FabricEnvironmentStagingLibrary [-WorkspaceId] <Guid> [-EnvironmentId] <Guid>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function sends a POST request to the Microsoft Fabric API to upload a library to the specified
environment staging area for the given workspace.

## EXAMPLES

### EXAMPLE 1
```
Import-FabricEnvironmentStagingLibrary -WorkspaceId "workspace-12345" -EnvironmentId "env-67890"
```

## PARAMETERS

### -EnvironmentId
The unique identifier of the environment where the library will be uploaded.

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
The unique identifier of the workspace where the environment exists.

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
- This is not working code. It is a placeholder for future development. Fabric documentation is missing some important details on how to upload libraries.
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
