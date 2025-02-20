# Get-FabricDatasetRefreshes

## SYNOPSIS
Retrieves the refresh history of a specified dataset in a PowerBI workspace.

## SYNTAX

```
Get-FabricDatasetRefreshes [-DatasetID] <String> [-workspaceId] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricDatasetRefreshes function uses the PowerBI cmdlets to retrieve the refresh history of a specified dataset in a workspace.
It uses the dataset ID and workspace ID to get the dataset and checks if it is refreshable.
If it is, the function retrieves the refresh history.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDatasetRefreshes -DatasetID "12345678-90ab-cdef-1234-567890abcdef" -workspaceId "abcdef12-3456-7890-abcd-ef1234567890"
```

This command retrieves the refresh history of the specified dataset in the specified workspace.

## PARAMETERS

### -DatasetID
The ID of the dataset.
This is a mandatory parameter.

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

### -workspaceId
The ID of the workspace.
This is a mandatory parameter.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String. You can pipe two strings that contain the dataset ID and workspace ID to Get-FabricDatasetRefreshes.
## OUTPUTS

### Object. Get-FabricDatasetRefreshes returns an object that contains the refresh history.
## NOTES
Alias: Get-PowerBIDatasetRefreshes, Get-FabricDatasetRefreshes

## RELATED LINKS
