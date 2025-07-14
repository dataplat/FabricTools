---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: Start-FabricSparkJobDefinitionOnDemand
---

# Start-FabricSparkJobDefinitionOnDemand

## SYNOPSIS

Starts a Fabric Spark Job Definition on demand.

## SYNTAX

### __AllParameterSets

```
Start-FabricSparkJobDefinitionOnDemand [-WorkspaceId] <guid> [-SparkJobDefinitionId] <guid>
 [[-JobType] <string>] [[-waitForCompletion] <bool>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function initiates a Spark Job Definition on demand within a specified workspace.
It constructs the appropriate API endpoint URL and makes a POST request to start the job.
The function can optionally wait for the job to complete based on the 'waitForCompletion' parameter.

## EXAMPLES

### EXAMPLE 1

```powershell
Start-FabricSparkJobDefinitionOnDemand -WorkspaceId "workspace123" -SparkJobDefinitionId "jobdef456" -waitForCompletion $true
```

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -JobType

The type of job to be started.
The default value is 'sparkjob'.
This parameter is optional.

```yaml
Type: System.String
DefaultValue: sparkjob
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

### -SparkJobDefinitionId

The ID of the Spark Job Definition to be started.
This parameter is mandatory.

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

### -waitForCompletion

A boolean flag indicating whether to wait for the job to complete.
The default value is $false.
This parameter is optional.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Tells PowerShell to run the command in a mode that only reports what would happen, but not actually let the command run or make changes.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

The ID of the workspace where the Spark Job Definition is located.
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

Ensure that the necessary authentication tokens are valid before running this function.
The function logs detailed messages for debugging and informational purposes.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

