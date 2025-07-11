---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricDomain

## SYNOPSIS
Retrieves domain information from Microsoft Fabric, optionally filtering by domain ID, domain name, or only non-empty domains.

## SYNTAX

```
Get-FabricDomain [[-DomainId] <Guid>] [[-DomainName] <String>] [[-NonEmptyDomainsOnly] <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricDomain\` function allows retrieval of domains in Microsoft Fabric, with optional filtering by domain ID or name.
Additionally, it can filter to return only non-empty domains.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDomain -DomainId "12345"
```

Fetches the domain with ID "12345".

### EXAMPLE 2
```
Get-FabricDomain -DomainName "Finance"
```

Fetches the domain with the display name "Finance".

## PARAMETERS

### -DomainId
(Optional) The ID of the domain to retrieve.

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

### -DomainName
(Optional) The display name of the domain to retrieve.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NonEmptyDomainsOnly
(Optional) If set to \`$true\`, only domains containing workspaces will be returned.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
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

### System.Object[]
## NOTES
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
