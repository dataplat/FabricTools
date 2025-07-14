---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricLongRunningOperationResult
---

# Get-FabricLongRunningOperationResult

## SYNOPSIS

Retrieves the result of a completed long-running operation from the Microsoft Fabric API.

## SYNTAX

### __AllParameterSets

```
Get-FabricLongRunningOperationResult [-OperationId] <guid> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Get-FabricLongRunningOperationResult function queries the Microsoft Fabric API to fetch the result
of a specific long-running operation.
This is typically used after confirming the operation has completed successfully.

## EXAMPLES

### EXAMPLE 1

This command fetches the result of the operation with the specified operationId. ```powershell ```

```powershell
Get-FabricLongRunningOperationResult -operationId "12345-abcd-67890-efgh"
```

## PARAMETERS

### -OperationId

The unique identifier of the completed long-running operation whose result you want to retrieve.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
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

- Ensure the Fabric API headers (e.g., authorization tokens) are defined in $FabricConfig.FabricHeaders.
- This function does not handle polling.
Ensure the operation is in a terminal state before calling this function.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

