---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Invoke-FabricKQLCommand

## SYNOPSIS
Executes a KQL command in a Kusto Database.

## SYNTAX

```
Invoke-FabricKQLCommand [-WorkspaceId] <Guid> [[-KQLDatabaseName] <String>] [[-KQLDatabaseId] <Guid>]
 [-KQLCommand] <String> [-ReturnRawResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Executes a KQL command in a Kusto Database.
The KQL command is executed in the Kusto Database that is specified by the KQLDatabaseName or KQLDatabaseId parameter.
The KQL command is executed in the context of the Fabric Real-Time Intelligence session that is established by the Connect-RTISession cmdlet.
The cmdlet distinguishes between management commands and query commands.
Management commands are executed in the management API, while query commands are executed in the query API.
The distinction is made by checking if the KQL command starts with a dot.
If it does, it is a management command else it is a query command.
If the KQL command is a management command, it is crucial to have the execute database script \<| in the beginning, otherwise the Kusto API will not execute the script.
This cmdlet will automatically add the .execute database script \<| in the beginning of the KQL command if it is a management command and if it is not already present.
If the KQL Command is a query command, the result is returned as an array of PowerShell objects by default.
If the parameter -ReturnRawResult is used, the raw result of the KQL query is returned which is a JSON object.

## EXAMPLES

### EXAMPLE 1
```
Invoke-FabricKQLCommand -WorkspaceId '12345678-1234-1234-1234-123456789012' -KQLDatabaseName 'MyKQLDatabase'-KQLCommand '.create table MyTable (MyColumn: string)
```

This example will create a table named 'MyTable' with a column named 'MyColumn' in
the KQLDatabase 'MyKQLDatabase'.

### EXAMPLE 2
```
Invoke-FabricKQLCommand `
            -WorkspaceId '2c4ccbb5-9b13-4495-9ab3-ba41152733d9' `
            -KQLDatabaseName 'MyEventhouse2' `
            -KQLCommand 'productcategory
                        | take 100'
```

This example will Execute the Query 'productcategory | take 100' in the KQLDatabase 'MyEventhouse2'
and it will return the result as an array of PowerShell objects.

### EXAMPLE 3
```
Invoke-FabricKQLCommand `
            -WorkspaceId '2c4ccbb5-9b13-4495-9ab3-ba41152733d9' `
            -KQLDatabaseName 'MyEventhouse2' `
            -ReturnRawResult `
            -KQLCommand 'productcategory
                        | take 100'
```

This example will Execute the Query 'productcategory | take 100' in the KQLDatabase 'MyEventhouse2'
and it will return the result as the raw result of the KQL command, which is a JSON object.

## PARAMETERS

### -KQLCommand
The KQL command that should be executed in the Kusto Database.
The KQL command is a string.
An example of a string is '.create table MyTable (MyColumn: string)'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDatabaseId
The Id of the KQLDatabase in which the KQL command should be executed.
This parameter cannot be used together with KQLDatabaseName.
The value for KQLDatabaseId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDatabaseName
The name of the KQLDatabase in which the KQL command should be executed.
This parameter cannot be used together with KQLDatabaseId.

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

### -ReturnRawResult
When this switch is used, the raw result of the KQL command is returned.
By default, the result is returned as
a PowerShell object.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
Id of the Fabric Workspace for which the KQL command should be executed.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

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
Revision History:

2024-12-22 - FGE: Added Verbose Output
2024-12-27 - FGE: Major Update to support KQL Queries and Management Commands

Author: Frank Geisler

## RELATED LINKS
