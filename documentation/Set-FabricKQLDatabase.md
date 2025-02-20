# Set-FabricKQLDatabase

## SYNOPSIS
Updates Properties of an existing Fabric KQLDatabase

## SYNTAX

```
Set-FabricKQLDatabase [-WorkspaceId] <String> [-KQLDatabaseId] <String> [[-NewKQLDatabaseName] <String>]
 [[-KQLDatabaseDescription] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates Properties of an existing Fabric KQLDatabase.
The KQLDatabase is updated
in the specified Workspace.
The KQLDatabaseId is used to identify the KQLDatabase
that should be updated.
The KQLDatabaseNewName and KQLDatabaseDescription are the
properties that can be updated.

## EXAMPLES

### EXAMPLE 1
```
Set-FabricKQLDatabase `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -KQLDatabaseId '12345678-1234-1234-1234-123456789012' `
    -NewKQLDatabaseNewName 'MyNewKQLDatabase' `
    -KQLDatabaseDescription 'This is my new KQLDatabase'
```

This example will update the KQLDatabase with the Id '12345678-1234-1234-1234-123456789012'.
It will update the name to 'MyNewKQLDatabase' and the description to 'This is my new KQLDatabase'.

## PARAMETERS

### -KQLDatabaseDescription
The new description of the KQLDatabase.
The description can be up to 256 characters long.

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

### -KQLDatabaseId
The Id of the KQLDatabase to update.
The value for KQLDatabaseId is a GUID.
An example of a GUID is '12345678-1234-123-1234-123456789012'.

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

### -NewKQLDatabaseName
The new name of the KQLDatabase.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: NewName, NewDisplayName

Required: False
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

### -WorkspaceId
Id of the Fabric Workspace for which the KQLDatabase should be updated.
The value for WorkspaceId is a GUID.
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
                    Renamed Parameter KQLDatabaseName to NewKQLDatabaseNewName

## RELATED LINKS
