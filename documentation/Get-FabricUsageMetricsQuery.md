---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Get-FabricUsageMetricsQuery

## SYNOPSIS
Retrieves usage metrics for a specific dataset.

## SYNTAX

```
Get-FabricUsageMetricsQuery [-DatasetID] <Guid> [-groupId] <Guid> [-reportname] <Object>
 [[-ImpersonatedUser] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricUsageMetricsQuery function retrieves usage metrics for a specific dataset.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricUsageMetricsQuery -DatasetID "your-dataset-id" -groupId "your-group-id" -reportname "your-report-name" -token "your-token"
```

This example retrieves the usage metrics for a specific dataset given the dataset ID, group ID, report name, and token.

## PARAMETERS

### -DatasetID
The ID of the dataset.
This is a mandatory parameter.

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

### -groupId
The ID of the group.
This is a mandatory parameter.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImpersonatedUser
The name of the impersonated user.
This is an optional parameter.

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

### -reportname
The name of the report.
This is a mandatory parameter.

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The function defines the headers and body for a POST request to the PowerBI API to retrieve the usage metrics for the specified dataset.
It then makes the POST request and returns the response.

Author: Ioana Bouariu

## RELATED LINKS
