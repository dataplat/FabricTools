---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricDomainWorkspace

## SYNOPSIS
Retrieves the workspaces associated with a specific domain in Microsoft Fabric.

## SYNTAX

```
Get-FabricDomainWorkspace [-DomainId] <Guid> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FabricDomainWorkspace\` function fetches the workspaces for the given domain ID.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDomainWorkspace -DomainId "12345"
```

Fetches workspaces for the domain with ID "12345".

## PARAMETERS

### -DomainId
The ID of the domain for which to retrieve workspaces.

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
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
