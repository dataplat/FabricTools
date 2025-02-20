# Remove-FabricKQLQueryset

## SYNOPSIS
Removes an existing Fabric KQLQueryset.

## SYNTAX

```
Remove-FabricKQLQueryset [-WorkspaceId] <String> [-KQLQuerysetId] <String> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes an existing Fabric KQLQueryset.
The Eventhouse is identified by the WorkspaceId and KQLQuerysetId.

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricKQLQueryset `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -KQLQuerysetId '12345678-1234-1234-1234-123456789012'
```

## PARAMETERS

### -KQLQuerysetId
The Id of the KQLQueryset to remove.
The value for KQLQuerysetId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.
This parameter is mandatory.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Id

Required: True
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
Id of the Fabric Workspace for which the KQLQueryset should be removed.
The value for WorkspaceId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.
This parameter is mandatory.

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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi

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
TODO: Add functionality to remove KQLQueryset by name.

Revsion History:

- 2024-11-07 - FGE: Implemented SupportShouldProcess
- 2024-12-22 - FGE: Added Verbose Output

## RELATED LINKS
