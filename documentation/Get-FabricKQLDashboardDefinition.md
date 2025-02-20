# Get-FabricKQLDashboardDefinition

## SYNOPSIS
Retrieves Fabric KQLDashboard Definitions for a given KQLDashboard.

## SYNTAX

```
Get-FabricKQLDashboardDefinition [-WorkspaceId] <String> [[-KQLDashboardName] <String>]
 [[-KQLDashboardId] <String>] [[-Format] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the Definition of the Fabric KQLDashboard that is specified by the KQLDashboardName or KQLDashboardID.
The KQLDashboard Definition contains the parts of the KQLDashboard, which are the visualizations and their configuration.
This is provided as a JSON object.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricKQLDashboardDefinition `
    -WorkspaceId "12345678-1234-1234-1234-123456789012" `
    -KQLDashboardName "MyKQLDashboard"
```

This example retrieves the KQLDashboard Definition for the KQLDashboard named "MyKQLDashboard" in the
Workspace with the ID "12345678-1234-1234-1234-123456789012".

### EXAMPLE 2
```
$db = Get-FabricKQLDashboardDefinition `
        -WorkspaceId "12345678-1234-1234-1234-123456789012" `
        -KQLDashboardName "MyKQLDashboard"
```

$db\[0\].payload | \`
    Set-Content \`
        -Path "C:\temp\mydashboard.json"

This example retrieves the KQLDashboard Definition for the KQLDashboard named "MyKQLDashboard" in the
Workspace with the ID "12345678-1234-1234-1234-123456789012".
The definition is saved to a file named "mydashboard.json".

## PARAMETERS

### -Format
{{ Fill Format Description }}

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
Id of the Fabric Workspace in which the KQLDashboard exists.
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
Revision History:
    - 2024-11-16 - FGE: First version
    - 2024-12-08 - FGE: Added Verbose Output

## RELATED LINKS
