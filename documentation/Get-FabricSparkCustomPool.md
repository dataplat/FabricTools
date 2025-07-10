---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricSparkCustomPool

## SYNOPSIS
Retrieves Spark custom pools from a specified workspace.

## SYNTAX

```
Get-FabricSparkCustomPool [-WorkspaceId] <Guid> [[-SparkCustomPoolId] <Guid>] [[-SparkCustomPoolName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves all Spark custom pools from a specified workspace using the provided WorkspaceId.
It handles token validation, constructs the API URL, makes the API request, and processes the response.
The function supports filtering by SparkCustomPoolId or SparkCustomPoolName, but not both simultaneously.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricSparkCustomPool -WorkspaceId "12345"
This example retrieves all Spark custom pools from the workspace with ID "12345".
```

### EXAMPLE 2
```
Get-FabricSparkCustomPool -WorkspaceId "12345" -SparkCustomPoolId "pool1"
This example retrieves the Spark custom pool with ID "pool1" from the workspace with ID "12345".
```

### EXAMPLE 3
```
Get-FabricSparkCustomPool -WorkspaceId "12345" -SparkCustomPoolName "MyPool"
This example retrieves the Spark custom pool with name "MyPool" from the workspace with ID "12345".
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

### -SparkCustomPoolId
The ID of the specific Spark custom pool to retrieve.
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

### -SparkCustomPoolName
The name of the specific Spark custom pool to retrieve.
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
The ID of the workspace from which to retrieve Spark custom pools.
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
- Handles continuation tokens to retrieve all Spark custom pools if there are multiple pages of results.

Author: Tiago Balabuch

## RELATED LINKS
