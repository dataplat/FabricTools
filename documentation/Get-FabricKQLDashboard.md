# Get-FabricKQLDashboard

## SYNOPSIS
Retrieves Fabric KQLDashboards

## SYNTAX

```
Get-FabricKQLDashboard [-WorkspaceId] <String> [[-KQLDashboardName] <String>] [[-KQLDashboardId] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves Fabric KQLDashboards.
Without the KQLDashboardName or KQLDashboardID parameter, all KQLDashboards are returned.
If you want to retrieve a specific KQLDashboard, you can use the KQLDashboardName or KQLDashboardID parameter.
These
parameters cannot be used together.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricKQLDashboard
```

## PARAMETERS

### -KQLDashboardId
The Id of the KQLDashboard to retrieve.
This parameter cannot be used together with KQLDashboardName.
The value for KQLDashboardID is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Id

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDashboardName
The name of the KQLDashboard to retrieve.
This parameter cannot be used together with KQLDashboardID.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name, DisplayName

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

### -WorkspaceId
Id of the Fabric Workspace for which the KQLDashboards should be retrieved.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
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
TODO: Add functionality to list all KQLDashboards.
To do so fetch all workspaces and
      then all KQLDashboards in each workspace.

Revision History:
    - 2024-11-09 - FGE: Added DisplaName as Alias for KQLDashboardName
    - 2024-12-08 - FGE: Added Verbose Output

## RELATED LINKS
