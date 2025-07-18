---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# New-FabricKQLDatabase

## SYNOPSIS
Creates a new KQLDatabase in a specified Microsoft Fabric workspace.

## SYNTAX

```
New-FabricKQLDatabase [-WorkspaceId] <Guid> [-KQLDatabaseName] <String> [[-KQLDatabaseDescription] <String>]
 [[-parentEventhouseId] <Guid>] [-KQLDatabaseType] <String> [[-KQLInvitationToken] <String>]
 [[-KQLSourceClusterUri] <String>] [[-KQLSourceDatabaseName] <String>] [[-KQLDatabasePathDefinition] <String>]
 [[-KQLDatabasePathPlatformDefinition] <String>] [[-KQLDatabasePathSchemaDefinition] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function sends a POST request to the Microsoft Fabric API to create a new KQLDatabase
in the specified workspace.
It supports optional parameters for KQLDatabase description
and path definitions for the KQLDatabase content.

## EXAMPLES

### EXAMPLE 1
```
Add-FabricKQLDatabase -WorkspaceId "workspace-12345" -KQLDatabaseName "New KQLDatabase" -KQLDatabasePathDefinition "C:\KQLDatabases\example.ipynb"
```

## PARAMETERS

### -KQLDatabaseDescription
An optional description for the KQLDatabase.

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

### -KQLDatabaseName
The name of the KQLDatabase to be created.

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

### -KQLDatabasePathDefinition
An optional path to the KQLDatabase definition file (e.g., .ipynb file) to upload.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDatabasePathPlatformDefinition
An optional path to the platform-specific definition (e.g., .platform file) to upload.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDatabasePathSchemaDefinition
the path to the KQLDatabase schema definition file (e.g., .kql file) to upload.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLDatabaseType
The type of KQLDatabase to create.
Valid values are "ReadWrite" and "Shortcut".

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLInvitationToken
An optional invitation token for the KQLDatabase.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLSourceClusterUri
An optional source cluster URI for the KQLDatabase.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KQLSourceDatabaseName
An optional source database name for the KQLDatabase.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -parentEventhouseId
The ID of the parent Eventhouse item for the KQLDatabase.
This is mandatory for ReadWrite type databases.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
The unique identifier of the workspace where the KQLDatabase will be created.

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
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.
- Precedent Request Body
    - Definition file high priority.
    - CreationPayload is evaluate only if Definition file is not provided.
        - invitationToken has priority over all other payload fields.

Author: Tiago Balabuch

## RELATED LINKS
