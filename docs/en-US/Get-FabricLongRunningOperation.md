---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricLongRunningOperation
---

# Get-FabricLongRunningOperation

## SYNOPSIS

Monitors the status of a long-running operation in Microsoft Fabric.

## SYNTAX

### __AllParameterSets

```
Get-FabricLongRunningOperation [[-OperationId] <string>] [[-Location] <string>]
 [[-RetryAfter] <int>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Get-FabricLongRunningOperation function queries the Microsoft Fabric API to check the status of a
long-running operation.
It periodically polls the operation until it reaches a terminal state (Succeeded or Failed).

## EXAMPLES

### EXAMPLE 1

This command polls the status of the operation with the given operationId every 10 seconds until it completes. ```powershell ```

```powershell
Get-FabricLongRunningOperation -operationId "12345-abcd-67890-efgh" -retryAfter 10
```

## PARAMETERS

### -Location

The URL provided in the Location header of the initial request.
This is used to check the status of the operation.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OperationId

The unique identifier of the long-running operation to be monitored.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RetryAfter

The interval (in seconds) to wait between polling the operation status.
The default is 5 seconds.

```yaml
Type: System.Int32
DefaultValue: 5
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

