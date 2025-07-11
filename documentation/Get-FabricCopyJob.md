---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricCopyJob

## SYNOPSIS
Retrieves CopyJob details from a specified Microsoft Fabric workspace.

## SYNTAX

```
Get-FabricCopyJob [-WorkspaceId] <Guid> [[-CopyJobId] <Guid>] [[-CopyJob] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves CopyJob details from a specified workspace using either the provided CopyJobId or CopyJob.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1
```
FabricCopyJob -WorkspaceId "workspace-12345" -CopyJobId "CopyJob-67890"
This example retrieves the CopyJob details for the CopyJob with ID "CopyJob-67890" in the workspace with ID "workspace-12345".
```

### EXAMPLE 2
```
FabricCopyJob -WorkspaceId "workspace-12345" -CopyJob "My CopyJob"
This example retrieves the CopyJob details for the CopyJob named "My CopyJob" in the workspace with ID "workspace-12345".
```

## PARAMETERS

### -CopyJob
The name of the CopyJob to retrieve.
This parameter is optional.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CopyJobId
The unique identifier of the CopyJob to retrieve.
This parameter is optional.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
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
The unique identifier of the workspace where the CopyJob exists.
This parameter is mandatory.

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
Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
