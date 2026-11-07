---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Git
Locale: en-US
Module Name: FabricTools
ms.date: 11/07/2026
PlatyPS schema version: 2024-05-01
title: Update-FabricGitCredential
---

# Update-FabricGitCredential

## SYNOPSIS

Updates the Git credentials configuration of the current user for a Fabric workspace.

## SYNTAX

### ConfiguredConnection (Default)

```
Update-FabricGitCredential -WorkspaceId <guid> -ConnectionId <guid> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Automatic

```
Update-FabricGitCredential -WorkspaceId <guid> -Automatic [-WhatIf] [-Confirm] [<CommonParameters>]
```

### None

```
Update-FabricGitCredential -WorkspaceId <guid> -None [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Sets how the calling user (or service principal) authenticates to Git in the specified
workspace.
Exactly one of the following is used:
-Automatic          source 'Automatic' (Azure DevOps with the caller's identity)
-ConnectionId <id>  source 'ConfiguredConnection' using a configured Fabric connection
-None               source 'None' (removes the credentials configuration)

## EXAMPLES

### EXAMPLE 1

Update-FabricGitCredential -WorkspaceId '11111111-1111-1111-1111-111111111111' -ConnectionId '22222222-2222-2222-2222-222222222222'

Uses the configured connection for Git operations in the workspace.

### EXAMPLE 2

Update-FabricGitCredential -WorkspaceId '11111111-1111-1111-1111-111111111111' -Automatic

Uses automatic credentials for Git operations in the workspace.

## PARAMETERS

### -Automatic

Use automatic credentials.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Automatic
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

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

### -ConnectionId

The ID of a configured Fabric connection holding the Git credentials.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ConfiguredConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -None

Remove the Git credentials configuration.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: None
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

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

The ID of the workspace.
Accepts pipeline input by property name (alias Id).

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

### System.Guid

{{ Fill in the Description }}

## OUTPUTS

### System.Management.Automation.PSCustomObject

The updated credentials configuration with WorkspaceId added.

{{ Fill in the Description }}

### System.Management.Automation.PSCustomObject

{{ Fill in the Description }}

## NOTES

https://learn.microsoft.com/en-us/rest/api/fabric/core/git/update-my-git-credentials

Requires the workspace Contributor role or higher.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

