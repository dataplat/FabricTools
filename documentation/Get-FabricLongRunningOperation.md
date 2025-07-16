---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricLongRunningOperation

## SYNOPSIS
Monitors the status of a long-running operation in Microsoft Fabric.

## SYNTAX

```
Get-FabricLongRunningOperation [[-OperationId] <String>] [[-Location] <String>] [[-RetryAfter] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricLongRunningOperation function queries the Microsoft Fabric API to check the status of a
long-running operation.
It periodically polls the operation until it reaches a terminal state (Succeeded or Failed).

## EXAMPLES

### EXAMPLE 1
```
Get-FabricLongRunningOperation -operationId "12345-abcd-67890-efgh" -retryAfter 10
```

This command polls the status of the operation with the given operationId every 10 seconds until it completes.

## PARAMETERS

### -Location
The URL provided in the Location header of the initial request.
This is used to check the status of the operation.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OperationId
The unique identifier of the long-running operation to be monitored.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
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

### -RetryAfter
The interval (in seconds) to wait between polling the operation status.
The default is 5 seconds.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Tiago Balabuch

## RELATED LINKS
