---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricRecoveryPoint

## SYNOPSIS
Get a list of Fabric recovery points.

## SYNTAX

```
Get-FabricRecoveryPoint [[-WorkspaceGUID] <Guid>] [[-DataWarehouseGUID] <Guid>] [[-BaseUrl] <String>]
 [[-Since] <DateTime>] [[-Type] <String>] [[-CreateTime] <String>]
```

## DESCRIPTION
Get a list of Fabric recovery points.
Results can be filter by date or type.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricRecoveryPoint -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'
```

Gets all the available recovery points for the specified data warehouse, in the specified workspace.

## PARAMETERS

### -BaseUrl
Defaults to api.powerbi.com

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Api.powerbi.com
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateTime
The specific unique time of the restore point to remove.
Get this from Get-FabricRecoveryPoint.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataWarehouseGUID
The GUID for the data warehouse which we want to retrieve restore points for.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Since
Filter the results to only include restore points created after this date.

```yaml
Type: System.DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Filter the results to only include restore points of this type.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceGUID
This is the workspace GUID in which the data warehouse resides.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Based on API calls from this blog post: https://blog.fabric.microsoft.com/en-US/blog/the-art-of-data-warehouse-recovery-within-microsoft-fabric/

Author: Jess Pomfret

## RELATED LINKS
