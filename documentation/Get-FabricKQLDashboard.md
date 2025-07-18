---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricKQLDashboard

## SYNOPSIS
Retrieves an KQLDashboard or a list of KQLDashboards from a specified workspace in Microsoft Fabric.

## SYNTAX

```
Get-FabricKQLDashboard [-WorkspaceId] <Guid> [[-KQLDashboardId] <Guid>] [[-KQLDashboardName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricKQLDashboard\` function sends a GET request to the Fabric API to retrieve KQLDashboard details for a given workspace.
It can filter the results by \`KQLDashboardName\`.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricKQLDashboard -WorkspaceId "12345" -KQLDashboardName "Development"
```

Retrieves the "Development" KQLDashboard from workspace "12345".

### EXAMPLE 2
```
Get-FabricKQLDashboard -WorkspaceId "12345"
```

Retrieves all KQLDashboards in workspace "12345".

## PARAMETERS

### -KQLDashboardId
The Id of the KQLDashboard to retrieve.
This parameter cannot be used together with KQLDashboardName.
The value for KQLDashboardID is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

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

### -KQLDashboardName
(Optional) The name of the specific KQLDashboard to retrieve.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
(Mandatory) The ID of the workspace to query KQLDashboards.

```yaml
Type: System.Guid
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
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
