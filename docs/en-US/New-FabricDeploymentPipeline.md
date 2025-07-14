---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: New-FabricDeploymentPipeline
---

# New-FabricDeploymentPipeline

## SYNOPSIS

Creates a new deployment pipeline.

## SYNTAX

### __AllParameterSets

```
New-FabricDeploymentPipeline [-DisplayName] <string> [[-Description] <string>] [-Stages] <array>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `New-FabricDeploymentPipeline` function creates a new deployment pipeline with specified stages.
Each stage can be configured with a display name, description, and public/private visibility setting.

## EXAMPLES

### EXAMPLE 1

Creates a new deployment pipeline with two stages.

```powershell
New-FabricDeploymentPipeline -DisplayName "My Deployment Pipeline" -Description "This is a test deployment pipeline" -Stages @(
    @{ DisplayName = "Stage 1"; Description = "First stage"; IsPublic = $true },
    @{ DisplayName = "Stage 2"; Description = "Second stage"; IsPublic = $false }
)
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

### -Description

Optional.
The description for the deployment pipeline.
Maximum length is 1024 characters.

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

### -DisplayName

Required.
The display name for the deployment pipeline.
Maximum length is 256 characters.

```yaml
Type: System.String
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

### -Stages

Required.
An array of hashtables containing stage configurations.
Each stage should have:
- DisplayName (string, max 256 chars)
- Description (string, max 1024 chars)
- IsPublic (boolean)

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Requires Pipeline.ReadWrite.All delegated scope.
- Service Principals must have permission granted by Fabric administrator.
- Returns the created deployment pipeline object with assigned IDs for the pipeline and its stages.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

