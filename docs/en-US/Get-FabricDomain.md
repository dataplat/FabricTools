---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricDomain
---

# Get-FabricDomain

## SYNOPSIS

Retrieves domain information from Microsoft Fabric, optionally filtering by domain ID, domain name, or only non-empty domains.

## SYNTAX

### __AllParameterSets

```
Get-FabricDomain [[-DomainId] <guid>] [[-DomainName] <string>] [[-NonEmptyDomainsOnly] <bool>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FabricDomain` function allows retrieval of domains in Microsoft Fabric, with optional filtering by domain ID or name.
Additionally, it can filter to return only non-empty domains.

## EXAMPLES

### EXAMPLE 1

Get-FabricDomain -DomainId "12345"

Fetches the domain with ID "12345".

### EXAMPLE 2

Get-FabricDomain -DomainName "Finance"

Fetches the domain with the display name "Finance".

## PARAMETERS

### -DomainId

(Optional) The ID of the domain to retrieve.

```yaml
Type: System.Guid
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DomainName

(Optional) The display name of the domain to retrieve.

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

### -NonEmptyDomainsOnly

(Optional) If set to `$true`, only domains containing workspaces will be returned.

```yaml
Type: System.Boolean
DefaultValue: False
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

{{ Fill in the Description }}

## NOTES

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

