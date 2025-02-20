# Get-FabricDebugInfo

## SYNOPSIS
Shows internal debug information about the current session.

## SYNTAX

```
Get-FabricDebugInfo [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Shows internal debug information about the current session.
It is useful for troubleshooting purposes.
It will show you the current session object.
This includes the bearer token.
This can be useful
for connecting to the REST API directly via Postman.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricDebugInfo
```

This example shows the current session object.

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

## OUTPUTS

## NOTES
Revsion History:

- 2024-12-22 - FGE: Added Verbose Output

## RELATED LINKS
