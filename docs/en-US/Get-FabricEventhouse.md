---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricEventhouse
---

# Get-FabricEventhouse

## SYNOPSIS

Retrieves Fabric Eventhouses

## SYNTAX

### __AllParameterSets

```
Get-FabricEventhouse [-WorkspaceId] <guid> [[-EventhouseId] <guid>] [[-EventhouseName] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves Fabric Eventhouses.
Without the EventhouseName or EventhouseID parameter, all Eventhouses are returned.
If you want to retrieve a specific Eventhouse, you can use the EventhouseName or EventhouseID parameter.
These
parameters cannot be used together.

## EXAMPLES

### EXAMPLE 1

This example will give you all Eventhouses in the Workspace.

```powershell
Get-FabricEventhouse `
-WorkspaceId '12345678-1234-1234-1234-123456789012'
```

### EXAMPLE 2

This example will give you all Information about the Eventhouse with the name 'MyEventhouse'.

```powershell
Get-FabricEventhouse `
-WorkspaceId '12345678-1234-1234-1234-123456789012' `
-EventhouseName 'MyEventhouse'
```

### EXAMPLE 3

This example will give you all Information about the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.

```powershell
Get-FabricEventhouse `
-WorkspaceId '12345678-1234-1234-1234-123456789012' `
-EventhouseId '12345678-1234-1234-1234-123456789012'
```

### EXAMPLE 4

This example will give you all Information about the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'. It will also give you verbose output which is useful for debugging.

```powershell
Get-FabricEventhouse `
-WorkspaceId '12345678-1234-1234-1234-123456789012' `
-EventhouseId '12345678-1234-1234-1234-123456789012' `
-Verbose
```

## PARAMETERS

### -EventhouseId

The Id of the Eventhouse to retrieve.
This parameter cannot be used together with EventhouseName.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

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

### -EventhouseName

The name of the Eventhouse to retrieve.
This parameter cannot be used together with EventhouseID.

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

Id of the Fabric Workspace for which the Eventhouses should be retrieved.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

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

TODO: Add functionality to list all Eventhouses in the subscription.
To do so fetch all workspaces
and then all eventhouses in each workspace.

Author: Tiago Balabuch

## RELATED LINKS

- [](https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP)
