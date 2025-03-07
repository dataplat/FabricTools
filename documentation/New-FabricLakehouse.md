# New-FabricLakehouse

## SYNOPSIS
Creates a new Fabric Lakehouse

## SYNTAX

```
New-FabricLakehouse [-WorkspaceID] <String> [-LakehouseName] <String> [-LakehouseSchemaEnabled] <Bool> [[-LakehouseDescription] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Fabric Lakehouse

## EXAMPLES

### EXAMPLE 1
```
New-FabricLakehouse `
        -WorkspaceID '12345678-1234-1234-1234-123456789012' `
        -LakehouseName 'MyLakehouse' `
        -LakehouseSchemaEnabled $true `
        -LakehouseDescription 'This is my Lakehouse'
```

This example will create a new Lakehouse with the name 'MyLakehouse' and the description 'This is my Lakehouse'.

### EXAMPLE 2
```
New-FabricLakehouse `
    -WorkspaceID '12345678-1234-1234-1234-123456789012' `
    -LakehouseName 'MyLakehouse' `
    -LakehouseSchemaEnabled $true `
    -LakehouseDescription 'This is my Lakehouse' `
    -Verbose
```

This example will create a new Lakehouse with the name 'MyLakehouse' and the description 'This is my MyLakehouse'.
It will also give you verbose output which is useful for debugging.

## PARAMETERS

### -EventhouseDescription
The description of the Eventhouse to create.

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

### -EventhouseName
The name of the Eventhouse to create.

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
Id of the Fabric Workspace for which the Eventhouse should be created.
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

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP)

