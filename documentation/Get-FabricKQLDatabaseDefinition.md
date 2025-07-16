---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricKQLDatabaseDefinition

## SYNOPSIS
Retrieves the definition of a KQLDatabase from a specific workspace in Microsoft Fabric.

## SYNTAX

```
Get-FabricKQLDatabaseDefinition [-WorkspaceId] <Guid> [[-KQLDatabaseId] <Guid>] [[-KQLDatabaseFormat] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function fetches the KQLDatabase's content or metadata from a workspace.
It supports retrieving KQLDatabase definitions in the Jupyter KQLDatabase (\`ipynb\`) format.
Handles both synchronous and asynchronous operations, with detailed logging and error handling.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricKQLDatabaseDefinition -WorkspaceId "12345" -KQLDatabaseId "67890"
```

Retrieves the definition of the KQLDatabase with ID \`67890\` from the workspace with ID \`12345\` in the \`ipynb\` format.

### EXAMPLE 2
```
Get-FabricKQLDatabaseDefinition -WorkspaceId "12345"
```

Retrieves the definitions of all KQLDatabases in the workspace with ID \`12345\` in the \`ipynb\` format.

## PARAMETERS

### -KQLDatabaseFormat
Specifies the format of the KQLDatabase definition.
Currently, only 'ipynb' is supported.

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

### -KQLDatabaseId
(Optional)The unique identifier of the KQLDatabase whose definition needs to be retrieved.

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
(Mandatory) The unique identifier of the workspace from which the KQLDatabase definition is to be retrieved.

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
- Handles long-running operations asynchronously.

Author: Tiago Balabuch

## RELATED LINKS
