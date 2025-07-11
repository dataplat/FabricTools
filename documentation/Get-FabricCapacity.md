---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricCapacity

## SYNOPSIS
Retrieves capacity details from a specified Microsoft Fabric workspace.

## SYNTAX

```
Get-FabricCapacity [[-capacityId] <Guid>] [[-capacityName] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function retrieves capacity details from a specified workspace using either the provided capacityId or capacityName.
It handles token validation, constructs the API URL, makes the API request, and processes the response.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricCapacity -capacityId "capacity-12345"
This example retrieves the capacity details for the capacity with ID "capacity-12345".
```

### EXAMPLE 2
```
Get-FabricCapacity -capacityName "MyCapacity"
This example retrieves the capacity details for the capacity named "MyCapacity".
```

## PARAMETERS

### -capacityId
The unique identifier of the capacity to retrieve.
This parameter is optional.

```yaml
Type: System.Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -capacityName
The name of the capacity to retrieve.
This parameter is optional.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Requires \`$FabricConfig\` global configuration, including \`BaseUrl\` and \`FabricHeaders\`.
- Calls \`Confirm-TokenState\` to ensure token validity before making the API request.

Author: Tiago Balabuch

## RELATED LINKS
