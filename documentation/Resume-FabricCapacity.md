---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version: https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP

- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
schema: 2.0.0
---

# Resume-FabricCapacity

## SYNOPSIS
Resumes a capacity.

## SYNTAX

```
Resume-FabricCapacity [-subscriptionID] <Guid> [-resourcegroup] <String> [-capacity] <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Resume-FabricCapacity function resumes a capacity.
It supports multiple aliases for flexibility.

## EXAMPLES

### EXAMPLE 1
```
Resume-FabricCapacity -subscriptionID "your-subscription-id" -resourcegroupID "your-resource-group" -capacityID "your-capacity"
```

This example resumes a capacity given the subscription ID, resource group, and capacity.

## PARAMETERS

### -capacity
The capacity.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

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

### -resourcegroup
The resource group.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

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

### -subscriptionID
The the ID of the subscription.
This is a mandatory parameter.
This is a parameter found in Azure, not Fabric.

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
The function defines parameters for the subscription ID, resource group, and capacity.
If the 'azToken' environment variable is null, it connects to the Azure account and sets the 'azToken' environment variable.
It then defines the headers for the request, defines the URI for the request, and makes a GET request to the URI.

Author: Ioana Bouariu

## RELATED LINKS
