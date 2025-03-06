# Invoke-FabricDatasetRefresh

## SYNOPSIS
This function invokes a refresh of a PowerBI dataset

## SYNTAX

```
Invoke-FabricDatasetRefresh -DatasetID <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-FabricDatasetRefresh function is used to refresh a PowerBI dataset.
It first checks if the dataset is refreshable.
If it is not, it writes an error.
If it is, it invokes a PowerBI REST method to refresh the dataset.
The URL for the request is constructed using the provided  dataset ID.

## EXAMPLES

### EXAMPLE 1
```
Invoke-FabricDatasetRefresh  -DatasetID "12345678-1234-1234-1234-123456789012"
```

This command invokes a refresh of the dataset with the ID "12345678-1234-1234-1234-123456789012"

## PARAMETERS

### -DatasetID
A mandatory parameter that specifies the dataset ID.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Alias: Invoke-FabDatasetRetresh

## RELATED LINKS
