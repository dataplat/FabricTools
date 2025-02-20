# Set-FabricKQLQueryset

## SYNOPSIS
Updates Properties of an existing Fabric KQLQueryset

## SYNTAX

```
Set-FabricKQLQueryset [-WorkspaceId] <String> [-KQLQuerysetId] <String> [[-KQLQuerysetNewName] <String>]
 [[-KQLQuerysetDescription] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates Properties of an existing Fabric KQLQueryset.
The KQLQueryset is identified by
the WorkspaceId and KQLQuerysetId.

## EXAMPLES

### EXAMPLE 1
```
Set-FabricKQLQueryset `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -KQLQuerysetId '12345678-1234-1234-1234-123456789012' `
    -KQLQuerysetNewName 'MyKQLQueryset' `
    -KQLQuerysetDescription 'This is my KQLQueryset'
```

This example will update the KQLQueryset.
The KQLQueryset will have the name 'MyKQLQueryset'
and the description 'This is my KQLQueryset'.

## PARAMETERS

### -KQLQuerysetDescription
The new description of the KQLQueryset.
This parameter is optional.

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

### -KQLQuerysetId
The Id of the KQLQueryset to update.
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

### -KQLQuerysetNewName
{{ Fill KQLQuerysetNewName Description }}

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
Id of the Fabric Workspace for which the KQLQueryset should be updated.
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
Revsion History:

- 2024-11-07 - FGE: Implemented SupportShouldProcess
- 2024-11-09 - FGE: Added NewDisplaName as Alias for KQLQuerysetNewName
- 2024-12-22 - FGE: Added Verbose Output

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/KQLQueryset/items/create-KQLQueryset?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/KQLQueryset/items/create-KQLQueryset?tabs=HTTP)

