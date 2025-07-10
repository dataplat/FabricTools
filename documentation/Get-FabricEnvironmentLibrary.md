---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricEnvironmentLibrary

## SYNOPSIS
Retrieves the list of libraries associated with a specific environment in a Microsoft Fabric workspace.

## SYNTAX

```
Get-FabricEnvironmentLibrary [-WorkspaceId] <Guid> [-EnvironmentId] <Guid> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricEnvironmentLibrary function fetches library information for a given workspace and environment
using the Microsoft Fabric API.
It ensures the authentication token is valid and validates the response
to handle errors gracefully.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricEnvironmentLibrary -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"
```

Retrieves the libraries associated with the specified environment in the given workspace.

## PARAMETERS

### -EnvironmentId
The unique identifier of the environment whose libraries are being queried.

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
(Mandatory) The unique identifier of the workspace where the environment is located.

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
