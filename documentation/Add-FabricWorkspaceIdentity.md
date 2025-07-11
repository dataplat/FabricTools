---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Add-FabricWorkspaceIdentity

## SYNOPSIS
Provisions an identity for a Fabric workspace.

## SYNTAX

```
Add-FabricWorkspaceIdentity [-WorkspaceId] <Guid> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Add-FabricWorkspaceIdentity\` function provisions an identity for a specified workspace by making an API call.

## EXAMPLES

### EXAMPLE 1
```
Add-FabricWorkspaceIdentity -WorkspaceId "workspace123"
```

Provisions a Managed Identity for the workspace with ID "workspace123".

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

### -WorkspaceId
The unique identifier of the workspace for which the identity will be provisioned.

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
