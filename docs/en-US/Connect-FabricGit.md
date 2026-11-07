---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Git
Locale: en-US
Module Name: FabricTools
ms.date: 11/07/2026
PlatyPS schema version: 2024-05-01
title: Connect-FabricGit
---

# Connect-FabricGit

## SYNOPSIS

Connects a Fabric workspace to a Git repository and branch.

## SYNTAX

### AzureDevOps (Default)

```
Connect-FabricGit -WorkspaceId <guid> -GitProviderType <string> -OrganizationName <string>
 -ProjectName <string> -RepositoryName <string> -BranchName <string> [-DirectoryName <string>]
 [-ConnectionId <guid>] [-Initialize] [-InitializationStrategy <string>] [-NoWait] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### GitHub

```
Connect-FabricGit -WorkspaceId <guid> -GitProviderType <string> -OwnerName <string>
 -RepositoryName <string> -BranchName <string> [-DirectoryName <string>] [-ConnectionId <guid>]
 [-Initialize] [-InitializationStrategy <string>] [-NoWait] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Connects the specified workspace to an Azure DevOps or GitHub repository, branch and
folder.
After connecting, the connection must be initialized; use -Initialize to do this
in the same call, or run Initialize-FabricGitConnection afterwards.

-GitProviderType is mandatory and must match the provider parameters supplied:
AzureDevOps requires -OrganizationName and -ProjectName, GitHub requires -OwnerName and
-ConnectionId.

## EXAMPLES

### EXAMPLE 1

Connect-FabricGit -WorkspaceId '11111111-1111-1111-1111-111111111111' -GitProviderType AzureDevOps -OrganizationName 'contoso' -ProjectName 'Fabric' -RepositoryName 'sales' -BranchName 'main' -DirectoryName '/workspace' -Initialize -InitializationStrategy PreferRemote

Connects the workspace to an Azure DevOps repository and initializes the connection,
preferring the content of the branch.

### EXAMPLE 2

Connect-FabricGit -WorkspaceId '11111111-1111-1111-1111-111111111111' -GitProviderType GitHub -OwnerName 'contoso' -RepositoryName 'sales' -BranchName 'main' -ConnectionId '22222222-2222-2222-2222-222222222222'

Connects the workspace to a GitHub repository using the credentials stored in a
configured connection.
Initialize-FabricGitConnection must be run afterwards.

## PARAMETERS

### -BranchName

The name of the branch in the repository to connect to.

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
When supplied, the
credentials source is 'ConfiguredConnection'; otherwise 'Automatic' (Azure DevOps with
the signed-in user's identity).
Required for GitHub.

```yaml
Type: System.Guid
DefaultValue: ''
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

### -DirectoryName

The folder in the repository that holds the workspace content.
Defaults to '/'.

```yaml
Type: System.String
DefaultValue: /
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

### -GitProviderType

The Git provider: AzureDevOps or GitHub.

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

### -InitializationStrategy

Used with -Initialize.
None (default), PreferRemote or PreferWorkspace.

```yaml
Type: System.String
DefaultValue: None
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

### -Initialize

Also initializes the Git connection after connecting (see Initialize-FabricGitConnection).

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

### -NoWait

Used with -Initialize.
Returns the long-running operation details instead of waiting.

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

### -OrganizationName

Azure DevOps only.
The Azure DevOps organization name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureDevOps
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OwnerName

GitHub only.
The owner (user or organization) of the GitHub repository.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: GitHub
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectName

Azure DevOps only.
The Azure DevOps project name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureDevOps
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RepositoryName

The name of the Git repository to connect to.

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

The ID of the workspace to connect.
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

Nothing without -Initialize. With -Initialize

{{ Fill in the Description }}

### System.Management.Automation.PSCustomObject

{{ Fill in the Description }}

## NOTES

https://learn.microsoft.com/en-us/rest/api/fabric/core/git/connect

Requires the workspace Admin role.
Service principals require -ConnectionId.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

