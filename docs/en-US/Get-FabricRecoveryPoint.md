---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Get-FabricRecoveryPoint
---

# Get-FabricRecoveryPoint

## SYNOPSIS

Get a list of Fabric recovery points.

## SYNTAX

### __AllParameterSets

```
Get-FabricRecoveryPoint [[-WorkspaceGUID] <guid>] [[-DataWarehouseGUID] <guid>]
 [[-BaseUrl] <string>] [[-Since] <datetime>] [[-Type] <string>] [[-CreateTime] <string>]
```

## ALIASES

## DESCRIPTION

Get a list of Fabric recovery points.
Results can be filter by date or type.

## EXAMPLES

### EXAMPLE 1

Gets all the available recovery points for the specified data warehouse, in the specified workspace.

```powershell
Get-FabricRecoveryPoint -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'
```

## PARAMETERS

### -BaseUrl

Defaults to api.powerbi.com

```yaml
Type: System.String
DefaultValue: api.powerbi.com
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

### -CreateTime

The specific unique time of the restore point to remove.
Get this from Get-FabricRecoveryPoint.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DataWarehouseGUID

The GUID for the data warehouse which we want to retrieve restore points for.

```yaml
Type: System.Guid
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

### -Since

Filter the results to only include restore points created after this date.

```yaml
Type: System.DateTime
DefaultValue: ''
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

### -Type

Filter the results to only include restore points of this type.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WorkspaceGUID

This is the workspace GUID in which the data warehouse resides.

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

## INPUTS

## OUTPUTS

## NOTES

Based on API calls from this blog post: https://blog.fabric.microsoft.com/en-US/blog/the-art-of-data-warehouse-recovery-within-microsoft-fabric/

Author: Jess Pomfret

## RELATED LINKS

{{ Fill in the related links here }}

