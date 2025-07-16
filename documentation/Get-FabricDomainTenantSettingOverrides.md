---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricDomainTenantSettingOverrides

## SYNOPSIS
Retrieves tenant setting overrides for a specific domain or all capacities in the Fabric tenant.

## SYNTAX

```
Get-FabricDomainTenantSettingOverrides [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricDomainTenantSettingOverrides\` function retrieves tenant setting overrides for all domains in the Fabric tenant by making a GET request to the designated API endpoint.
The function ensures token validity before making the request and handles the response appropriately.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDomainTenantSettingOverrides
```

Fetches tenant setting overrides for all domains in the Fabric tenant.

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

## NOTES
- Requires the \`$FabricConfig\` global configuration, which must include \`BaseUrl\` and \`FabricHeaders\`.
- Ensures token validity by invoking \`Confirm-TokenState\` before making the API request.
- Logs detailed messages for debugging and error handling.

Author: Tiago Balabuch

## RELATED LINKS
