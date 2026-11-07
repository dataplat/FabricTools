---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 10/28/2026
title: Refresh-FabricSQLEndpoint
---

# Refresh-FabricSQLEndpoint

## SYNOPSIS

Refreshes the metadata of a SQL analytics endpoint.

## SYNTAX

```
Refresh-FabricSQLEndpoint [-WorkspaceId] <guid> [-SQLEndpointId] <guid> [[-Timeout] <int>]
 [-NoWait] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Starts a refresh of the metadata for a SQL analytics endpoint in a specified workspace.
By default, the function waits for the long-running operation to complete.

## EXAMPLES

### EXAMPLE 1

```powershell
Refresh-FabricSQLEndpoint -WorkspaceId $workspaceId -SQLEndpointId $sqlEndpointId
```

## PARAMETERS

### -WorkspaceId

The ID of the workspace containing the SQL analytics endpoint.

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

### -SQLEndpointId

The ID of the SQL analytics endpoint to refresh.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Timeout

The maximum time, in minutes, to wait for the refresh operation. A value of 0 waits indefinitely.

```yaml
Type: System.Int32
DefaultValue: 15
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

### -NoWait

If specified, returns immediately after the refresh request is accepted.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
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

## NOTES

Author: Kamil Nowinski
