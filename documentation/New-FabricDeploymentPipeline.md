---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP
schema: 2.0.0
---

# New-FabricDeploymentPipeline

## SYNOPSIS
Creates a new deployment pipeline.

## SYNTAX

```
New-FabricDeploymentPipeline [-DisplayName] <String> [[-Description] <String>] [-Stages] <Array>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The \`New-FabricDeploymentPipeline\` function creates a new deployment pipeline with specified stages.
Each stage can be configured with a display name, description, and public/private visibility setting.

## EXAMPLES

### EXAMPLE 1
```
$stages = @(
    @{
        DisplayName = "Development"
        Description = "Development stage description"
        IsPublic = $false
    },
    @{
        DisplayName = "Test"
        Description = "Test stage description"
        IsPublic = $false
    },
    @{
        DisplayName = "Production"
        Description = "Production stage description"
        IsPublic = $true
    }
)
```

New-FabricDeploymentPipeline -DisplayName "My Deployment Pipeline" -Description "My pipeline description" -Stages $stages

Creates a new deployment pipeline with three stages: Development, Test, and Production.

## PARAMETERS

### -Description
Optional.
The description for the deployment pipeline.
Maximum length is 1024 characters.

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

### -DisplayName
Required.
The display name for the deployment pipeline.
Maximum length is 256 characters.

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

### -Stages
Required.
An array of hashtables containing stage configurations.
Each stage should have:
- DisplayName (string, max 256 chars)
- Description (string, max 1024 chars)
- IsPublic (boolean)

```yaml
Type: System.Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.
- Requires Pipeline.ReadWrite.All delegated scope.
- Service Principals must have permission granted by Fabric administrator.
- Returns the created deployment pipeline object with assigned IDs for the pipeline and its stages.

Author: Kamil Nowinski

## RELATED LINKS
