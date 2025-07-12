---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricSparkCustomPool
---

# Get-FabricSparkCustomPool

## SYNOPSIS

Retrieves Spark custom pools from a specified workspace.

## SYNTAX

### __AllParameterSets

```
Get-FabricSparkCustomPool [-WorkspaceId] <guid> [[-SparkCustomPoolId] <guid>]
 [[-SparkCustomPoolName] <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function retrieves all Spark custom pools from a specified workspace using the provided WorkspaceId.
It handles token validation, constructs the API URL, makes the API request, and processes the response.
The function supports filtering by SparkCustomPoolId or SparkCustomPoolName, but not both simultaneously.

## EXAMPLES

### EXAMPLE 1

This example retrieves all Spark custom pools from the workspace with ID "12345".

```powershell
Get-FabricSparkCustomPool -WorkspaceId "12345"
```

### EXAMPLE 2

This example retrieves the Spark custom pool with ID "pool1" from the workspace with ID "12345".

```powershell
Get-FabricSparkCustomPool -WorkspaceId "12345" -SparkCustomPoolId "pool1"
```

### EXAMPLE 3

This example retrieves the Spark custom pool with name "MyPool" from the workspace with ID "12345".

```powershell
Get-FabricSparkCustomPool -WorkspaceId "12345" -SparkCustomPoolName "MyPool"
```

## PARAMETERS

### -SparkCustomPoolId

The ID of the specific Spark custom pool to retrieve.
This parameter is optional.

```yaml
Type: System.Guid
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

### -SparkCustomPoolName

The name of the specific Spark custom pool to retrieve.
This parameter is optional.

```yaml
Type: System.String
DefaultValue: ''
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

### -WorkspaceId

The ID of the workspace from which to retrieve Spark custom pools.
This parameter is mandatory.

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

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Handles continuation tokens to retrieve all Spark custom pools if there are multiple pages of results.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

