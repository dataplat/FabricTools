# Get-FabricAuthToken

## SYNOPSIS
Retrieves the Fabric API authentication token.

## SYNTAX

```
Get-FabricAuthToken [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-FabricAuthToken function retrieves the Fabric API authentication token.
If the token is not already set, it calls the Set-FabricAuthToken function to set it.
It then outputs the token.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricAuthToken
```

This command retrieves the Fabric API authentication token.

## PARAMETERS

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

### None. You cannot pipe inputs to this function.
## OUTPUTS

### String. This function returns the Fabric API authentication token.
## NOTES
This function was originally written by Rui Romano.
https://github.com/RuiRomano/fabricps-pbip

## RELATED LINKS
