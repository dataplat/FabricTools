---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# Import-FabricItem

## SYNOPSIS
Imports items using the Power BI Project format (PBIP) into a Fabric workspace from a specified file system source.

## SYNTAX

```
Import-FabricItem [[-path] <String>] [[-workspaceId] <Guid>] [[-filter] <String>]
 [[-fileOverrides] <Hashtable>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Import-FabricItem function imports items using the Power BI Project format (PBIP) into a Fabric workspace from a specified file system source.
It supports multiple aliases for flexibility.
The function handles the import of datasets and reports, ensuring that the correct item type is used and that the items are created or updated as necessary.

## EXAMPLES

### EXAMPLE 1
```
Import-FabricItems -path 'C:\PBIPFiles' -workspaceId '12345' -filter 'C:\PBIPFiles\Reports'
```

This example imports PBIP files from the 'C:\PBIPFiles' folder into the Fabric workspace with ID '12345'.
It only searches for PBIP files in the 'C:\PBIPFiles\Reports' folder.

## PARAMETERS

### -fileOverrides
This parameter let's you override a PBIP file without altering the local file.

```yaml
Type: System.Collections.Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter
A filter to limit the search for PBIP files to specific folders.

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

### -path
The path to the PBIP files.
Default value is '.\pbipOutput'.

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
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
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
This function requires the Invoke-FabricRestMethod function to be available in the current session.

Author: Rui Romano

## RELATED LINKS
