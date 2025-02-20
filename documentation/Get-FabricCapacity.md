# Get-FabricCapacity

## SYNOPSIS
Retrieves the fabric capacity information.

## SYNTAX

```
Get-FabricCapacity [[-capacity] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function makes a GET request to the Fabric API to retrieve the tenant settings.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricCapacity -capacity "exampleCapacity"
Retrieves the fabric capacity information for the specified capacity.
```

Get-FabricCapacity
Retrieves the fabric capacity information for all capacities.

## PARAMETERS

### -capacity
Specifies the capacity to retrieve information for.
If not provided, all capacities will be retrieved.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
