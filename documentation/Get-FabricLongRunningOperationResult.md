---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricLongRunningOperationResult

## SYNOPSIS
Retrieves the result of a completed long-running operation from the Microsoft Fabric API.

## SYNTAX

```
Get-FabricLongRunningOperationResult [-OperationId] <Guid> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricLongRunningOperationResult function queries the Microsoft Fabric API to fetch the result
of a specific long-running operation.
This is typically used after confirming the operation has completed successfully.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricLongRunningOperationResult -operationId "12345-abcd-67890-efgh"
```

This command fetches the result of the operation with the specified operationId.

## PARAMETERS

### -OperationId
The unique identifier of the completed long-running operation whose result you want to retrieve.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- This function does not handle polling. Ensure the operation is in a terminal state before calling this function.

Author: Tiago Balabuch

## RELATED LINKS
