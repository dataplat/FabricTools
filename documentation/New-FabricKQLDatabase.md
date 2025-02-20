# New-FabricKQLDatabase

## SYNOPSIS
Creates a new Fabric KQLDatabase

## SYNTAX

```
New-FabricKQLDatabase [-WorkspaceID] <String> [-EventhouseID] <String> [-KQLDatabaseName] <String>
 [[-KQLDatabaseDescription] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new Fabric KQLDatabase.
The KQLDatabase is created in the specified Workspace and Eventhouse.
It will be created with the specified name and description.

## EXAMPLES

### EXAMPLE 1
```
New-FabricKQLDatabase `
    -WorkspaceID '12345678-1234-1234-1234-123456789012' `
    -EventhouseID '12345678-1234-1234-1234-123456789012' `
    -KQLDatabaseName 'MyKQLDatabase' `
    -KQLDatabaseDescription 'This is my KQLDatabase'
```

This example will create a new KQLDatabase with the name 'MyKQLDatabase' and the description 'This is my KQLDatabase'.

## PARAMETERS

### -EventhouseID
Id of the Fabric Eventhouse for which the KQLDatabase should be created.
The value for EventhouseID is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDatabaseDescription
The description of the KQLDatabase to create.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Description

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDatabaseName
The name of the KQLDatabase to create.
The name must be unique within the eventhouse and is a
mandatory parameter.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name, DisplayName

Required: True
Position: 3
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

### -WorkspaceID
Id of the Fabric Workspace for which the KQLDatabase should be created.
The value for WorkspaceID is a GUID.
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

- 2024-11-07 - FGE: Implemented SupportShouldProcess
- 2024-11-09 - FGE: Added DisplaName as Alias for KQLDatabaseName
- 2024-12-08 - FGE: Added Verbose Output

## RELATED LINKS
