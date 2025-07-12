---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricEventstream
---

# Get-FabricEventstream

## SYNOPSIS

Retrieves an Eventstream or a list of Eventstreams from a specified workspace in Microsoft Fabric.

## SYNTAX

### __AllParameterSets

```
Get-FabricEventstream [-WorkspaceId] <guid> [[-EventstreamId] <guid>] [[-EventstreamName] <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves Fabric Eventstreams.
Without the EventstreamName or EventstreamID parameter, all Eventstreams are returned.
If you want to retrieve a specific Eventstream, you can use the EventstreamName or EventstreamID parameter.
These
parameters cannot be used together.

## EXAMPLES

### EXAMPLE 1

Retrieves the "Development" Eventstream from workspace "12345".

```powershell
Get-FabricEventstream -WorkspaceId "12345" -EventstreamName "Development"
```

### EXAMPLE 2

Retrieves all Eventstreams in workspace "12345".

```powershell
Get-FabricEventstream -WorkspaceId "12345"
```

## PARAMETERS

### -EventstreamId

The Id of the Eventstream to retrieve.
This parameter cannot be used together with EventstreamName.
The value for EventstreamId is a GUID.
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

### -EventstreamName

(Optional) The name of the specific Eventstream to retrieve.

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

(Mandatory) The ID of the workspace to query Eventstreams.

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

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

