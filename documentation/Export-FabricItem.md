# Export-FabricItem

## SYNOPSIS
Exports items from a Fabric workspace.
Either all items in a workspace or a specific item.

## SYNTAX

```
Export-FabricItem [[-path] <String>] [[-workspaceId] <String>] [[-filter] <ScriptBlock>] [[-itemID] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Export-FabricItem function exports items from a Fabric workspace to a specified directory.
It can export items of type "Report", "SemanticModel", "SparkJobDefinitionV1" or "Notebook".
If a specific item ID is provided, only that item will be exported.
Otherwise, all items in the workspace will be exported.

## EXAMPLES

### EXAMPLE 1
```
Export-FabricItem -workspaceId "12345678-1234-1234-1234-1234567890AB" -path "C:\ExportedItems"
```

This example exports all items from the Fabric workspace with the specified ID to the "C:\ExportedItems" directory.

### EXAMPLE 2
```
Export-FabricItem -workspaceId "12345678-1234-1234-1234-1234567890AB" -itemID "98765432-4321-4321-4321-9876543210BA" -path "C:\ExportedItems"
```

This example exports the item with the specified ID from the Fabric workspace with the specified ID to the "C:\ExportedItems" directory.

## PARAMETERS

### -filter
A script block used to filter the items to be exported.
Only items that match the filter will be exported.
The default filter includes items of type "Report", "SemanticModel", "SparkJobDefinitionV1" or "Notebook".

```yaml
Type: System.Management.Automation.ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: { $_.type -in @("Report", "SemanticModel", "Notebook","SparkJobDefinitionV1") }
Accept pipeline input: False
Accept wildcard characters: False
```

### -itemID
The ID of the specific item to export.
If provided, only that item will be exported.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -path
The path to the directory where the items will be exported.
The default value is '.\pbipOutput'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: .\pbipOutput
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

### -workspaceId
The ID of the Fabric workspace.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function is based on the Export-FabricItems function written by Rui Romano.
https://github.com/RuiRomano/fabricps-pbip

## RELATED LINKS
