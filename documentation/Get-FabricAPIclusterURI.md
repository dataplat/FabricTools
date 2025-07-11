---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricAPIclusterURI

## SYNOPSIS
Retrieves the cluster URI for the tenant.

## SYNTAX

```
Get-FabricAPIclusterURI [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricAPIclusterURI function retrieves the cluster URI for the tenant.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricAPIclusterURI
```

This example retrieves the cluster URI for the tenant.

## PARAMETERS

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

### System.String
## NOTES
The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the datasets.
It then extracts the '@odata.context' property from the response, splits it on the '/' character, and selects the third element.
This element is used to construct the cluster URI, which is then returned by the function.

Author: Ioana Bouariu

## RELATED LINKS
