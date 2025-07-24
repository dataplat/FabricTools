---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/18/2025
PlatyPS schema version: 2024-05-01
title: Resume-FabricCapacity
---

# Resume-FabricCapacity

## SYNOPSIS

Resumes a capacity.

## SYNTAX

### __AllParameterSets

```
Resume-FabricCapacity [-subscriptionID] <guid> [-resourcegroup] <string> [-capacity] <string>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

Resume-FabCapacity

## DESCRIPTION

The Resume-FabricCapacity function resumes a capacity.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1

This example resumes a capacity given the subscription ID, resource group, and capacity.

```powershell
Resume-FabricCapacity -subscriptionID "your-subscription-id" -resourcegroupID "your-resource-group" -capacityID "your-capacity"
```

## PARAMETERS

### -capacity

The capacity.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

```yaml
Type: System.String
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

### -resourcegroup

The resource group.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

```yaml
Type: System.String
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

### -subscriptionID

The the ID of the subscription.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

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

The function defines parameters for the subscription ID, resource group, and capacity.
If the 'azToken' environment variable is null, it connects to the Azure account and sets the 'azToken' environment variable.
It then defines the headers for the request, defines the URI for the request, and makes a GET request to the URI.

Author: Ioana Bouariu

Define aliases for the function for flexibility.

## RELATED LINKS

{{ Fill in the related links here }}

