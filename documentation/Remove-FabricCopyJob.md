---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Remove-FabricCopyJob

## SYNOPSIS
Deletes a Copy Job from a specified Microsoft Fabric workspace.

## SYNTAX

```
Remove-FabricCopyJob [-WorkspaceId] <Guid> [-CopyJobId] <Guid> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function performs a DELETE operation on the Microsoft Fabric API to remove a Copy Job
from the specified workspace using the provided WorkspaceId and CopyJobId parameters.

## EXAMPLES

### EXAMPLE 1
```
Remove-FabricCopyJob -WorkspaceId "workspace-12345" -CopyJobId "copyjob-67890"
Deletes the Copy Job with ID "copyjob-67890" from the workspace with ID "workspace-12345".
```

## PARAMETERS

### -CopyJobId
The unique identifier of the Copy Job to delete.

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
The unique identifier of the workspace containing the Copy Job to be deleted.

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
- Requires the \`$FabricConfig\` global configuration, which must include \`BaseUrl\` and \`FabricHeaders\`.
- Ensures token validity by invoking \`Confirm-TokenState\` before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
