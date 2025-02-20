# Get-FabricKQLQueryset

## SYNOPSIS
Retrieves Fabric KQLQuerysets

## SYNTAX

```
Get-FabricKQLQueryset [-WorkspaceId] <String> [[-KQLQuerysetName] <String>] [[-KQLQuerysetId] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves Fabric KQLQuerysets.
Without the KQLQuerysetName or KQLQuerysetId parameter,
all KQLQuerysets are returned in the given Workspace.
If you want to retrieve a specific
KQLQueryset, you can use the KQLQuerysetName or KQLQuerysetId parameter.
These parameters
cannot be used together.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricKQLQueryset `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -KQLQuerysetName 'MyKQLQueryset'
```

This example will retrieve the KQLQueryset with the name 'MyKQLQueryset'.

### EXAMPLE 2
```
Get-FabricKQLQueryset `
    -WorkspaceId '12345678-1234-1234-1234-123456789012'
```

This example will retrieve all KQLQuerysets in the workspace that is specified
by the WorkspaceId.

### EXAMPLE 3
```
Get-FabricKQLQueryset `
    -WorkspaceId '12345678-1234-1234-1234-123456789012' `
    -KQLQuerysetId '12345678-1234-1234-1234-123456789012'
```

This example will retrieve the KQLQueryset with the ID '12345678-1234-1234-1234-123456789012'.

## PARAMETERS

### -KQLQuerysetId
The Id of the KQLQueryset to retrieve.
This parameter cannot be used together with KQLQuerysetName.
The value for KQLQuerysetId is a GUID.
An example of a GUID is '12345678-1234-1234-1234-123456789012'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Id

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLQuerysetName
The name of the KQLQueryset to retrieve.
This parameter cannot be used together with KQLQuerysetId.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Name, DisplayName

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
Id of the Fabric Workspace for which the KQLQuerysets should be retrieved.
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
TODO: Add functionality to list all KQLQuerysets.
To do so fetch all workspaces and
    then all KQLQuerysets in each workspace.

Revision History:
    - 2024-11-09 - FGE: Added DisplaName as Alias for KQLQuerysetName
    - 2024-12-22 - FGE: Added Verbose Output

## RELATED LINKS
