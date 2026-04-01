---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 04/01/2026
PlatyPS schema version: 2024-05-01
title: Update-FabricCapacity
---

# Update-FabricCapacity

## SYNOPSIS

Creates or updates a Microsoft Fabric capacity.

## SYNTAX

### __AllParameterSets

```
Update-FabricCapacity [-SubscriptionId] <guid> [-ResourceGroupName] <string>
 [-CapacityName] <string> [-SkuName] <string> [-Location] <string>
 [-AdministrationMembers] <string[]> [[-Tags] <hashtable>] [-NoWait] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Update-FabricCapacity` function sends a PATCH request to the Microsoft Fabric API to create or update a capacity
in the specified Azure subscription and resource group.
It supports parameters for capacity administration,
SKU details, and optional tags.

## EXAMPLES

### EXAMPLE 1

```powershell
$azureResource = @{
    subscriptionID = 'GUID-GUID'
    ResourceGroup  = 'TestRG'
    CapacityName   = 'fabricblogdemof4'
    Location       = 'uksouth'
}
Update-FabricCapacity @azureResource -SkuName 'F8' -AdministrationMembers 'azsdktest@microsoft.com' -Debug -Confirm:$false
```

### EXAMPLE 2

```powershell
$azureResource = @{
    subscriptionID = 'GUID-GUID'
    ResourceGroup  = 'TestRG'
    CapacityName   = 'fabricblogdemof4'
    Location       = 'uksouth'
    SkuName        = 'F8'
    AdministrationMembers = 'azsdktest@microsoft.com'
}
Update-FabricCapacity @azureResource -Tags @{Environment="Production"; Owner="IT Team"} -Confirm:$false
```

## PARAMETERS

### -AdministrationMembers

An array of administrator user identities for the capacity administration.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CapacityName

The name of the Microsoft Fabric capacity.
It must be a minimum of 3 characters, and a maximum of 63.
Must match pattern: ^[a-z][a-z0-9]*$

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

### -Location

The Azure region where the capacity is located (e.g., "uksouth").

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoWait

If specified, the function will not wait for the operation to complete and will return immediately.

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

### -ResourceGroupName

The name of the resource group.
The name is case insensitive.

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

### -SkuName

The name of the SKU level (e.g., "F2").

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SubscriptionId

The ID of the target subscription.
The value must be a UUID.

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

### -Tags

Optional resource tags as a hashtable.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 6
  IsRequired: false
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Uses Azure Resource Manager API endpoint for capacity management.

Author: Kamil Nowinski

## RELATED LINKS

{{ Fill in the related links here }}

