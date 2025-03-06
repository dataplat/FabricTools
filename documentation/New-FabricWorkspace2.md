# New-FabricWorkspace2

## SYNOPSIS
Creates a new Fabric Workspace

## SYNTAX

```
New-FabricWorkspace2 [-CapacityId] <String> [-WorkspaceName] <String> [[-WorkspaceDescription] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Fabric Workspace

## EXAMPLES

### EXAMPLE 1
```
New-FabricWorkspace `
    -CapacityID '12345678-1234-1234-1234-123456789012' `
    -WorkspaceName 'TestWorkspace' `
    -WorkspaceDescription 'This is a Test Workspace'
```

This example will create a new Workspace with the name 'TestWorkspace' and the description 'This is a test workspace'.

## PARAMETERS

### -CapacityId
Id of the Fabric Capacity for which the Workspace should be created.
The value for CapacityID is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

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

### -WorkspaceDescription
The description of the Workspace to create.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Description

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceName
The name of the Workspace to create.
This parameter is mandatory.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name, DisplayName

Required: True
Position: 2
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
Revsion History:

- 2024-12-22 - FGE: Added Verbose Output

## RELATED LINKS
