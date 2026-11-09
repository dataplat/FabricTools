---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: KQL Queryset
Locale: en-US
Module Name: FabricTools
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: Invoke-FabricKQLCommand
---

# Invoke-FabricKQLCommand

## SYNOPSIS

Executes a KQL command in a Kusto Database.

## SYNTAX

### ByName (Default)

```
Invoke-FabricKQLCommand -WorkspaceId <guid> -KQLDatabaseName <string> -KQLCommand <string> [-Raw]
 [<CommonParameters>]
```

### ById

```
Invoke-FabricKQLCommand -WorkspaceId <guid> -KQLDatabaseId <guid> -KQLCommand <string> [-Raw]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Executes a KQL command in the KQL Database specified by the KQLDatabaseName or KQLDatabaseId parameter.
The command is sent to the query service of the database (the 'queryServiceUri' property of the KQL Database)
using an access token for the Kusto API (configuration key 'FabricTools.KustoApi.ResourceUrl'), which is
acquired on first use and cached for the session.

The cmdlet distinguishes between management commands and queries: a command starting with a dot is a management
command and is sent to the management endpoint (/v1/rest/mgmt), anything else is a query and is sent to the
query endpoint (/v1/rest/query).
Management commands are wrapped in '.execute database script <|' unless the command already contains it.

Query results are returned as an array of PowerShell objects (one per row) by default.
Use -Raw to get the raw response of the Kusto API.

## EXAMPLES

### EXAMPLE 1

$params = @{
    WorkspaceId     = '12345678-1234-1234-1234-123456789012'
    KQLDatabaseName = 'MyKQLDatabase'
    KQLCommand      = '.create table MyTable (MyColumn: string)'
}
Invoke-FabricKQLCommand @params

Creates a table named 'MyTable' with a column named 'MyColumn' in the KQL Database 'MyKQLDatabase'.

### EXAMPLE 2

$params = @{
    WorkspaceId     = '12345678-1234-1234-1234-123456789012'
    KQLDatabaseName = 'MyEventhouse'
    KQLCommand      = 'productcategory | take 100'
}
Invoke-FabricKQLCommand @params

Runs the query in the KQL Database 'MyEventhouse' and returns the rows as an array of PowerShell objects.

### EXAMPLE 3

$params = @{
    WorkspaceId     = '12345678-1234-1234-1234-123456789012'
    KQLDatabaseId   = '87654321-4321-4321-4321-210987654321'
    KQLCommand      = 'StormEvents | count'
    Raw             = $true
}
Invoke-FabricKQLCommand @params

Runs the query in the KQL Database with the given Id and returns the raw response of the Kusto API.

## PARAMETERS

### -KQLCommand

The KQL command or query that should be executed in the KQL Database.
An example is '.create table MyTable (MyColumn: string)'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -KQLDatabaseId

The Id of the KQL Database in which the KQL command should be executed.
Cannot be used together with KQLDatabaseName.
The value for KQLDatabaseId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ById
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -KQLDatabaseName

The name of the KQL Database in which the KQL command should be executed.
Cannot be used together with KQLDatabaseId.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Raw

When this switch is used, the raw response of the Kusto API is returned instead of an array of PowerShell objects.
Alias: ReturnRawResult (the former parameter name).
Management commands always return the raw response.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- ReturnRawResult
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

### -WorkspaceId

Id of the Fabric Workspace that contains the KQL Database.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
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

Author: Frank Geisler, Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

