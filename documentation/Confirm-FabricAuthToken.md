# Confirm-FabricAuthToken

## SYNOPSIS
Check whether the Fabric API authentication token is set and not expired and reset it if necessary.

## SYNTAX

```
Confirm-FabricAuthToken [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Confirm-FabricAuthToken function retrieves the Fabric API authentication token.
If the token is not already set, it calls the Set-FabricAuthToken function to set it.
It then outputs the token.

## EXAMPLES

### EXAMPLE 1
```
Confirm-FabricAuthToken
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

### Returns object as Get-FabricDebugInfo function
## NOTES

## RELATED LINKS
