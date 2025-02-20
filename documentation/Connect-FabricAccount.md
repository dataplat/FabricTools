# Connect-FabricAccount

## SYNOPSIS
Connects to the Fabric WebAPI.

## SYNTAX

```
Connect-FabricAccount [-TenantId] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Connects to the Fabric WebAPI by using the cmdlet Connect-AzAccount.
This function retrieves the authentication token for the Fabric API and sets up the headers for API calls.

## EXAMPLES

### EXAMPLE 1
```
Connect-RTIAccount `
    -TenantID '12345678-1234-1234-1234-123456789012'
```

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

### -TenantId
The TenantId of the Azure Active Directory tenant you want to connect to
and in which your Fabric Capacity is.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Revsion History:

- 2024-12-22 - FGE: Added Verbose Output

## RELATED LINKS

[Connect-AzAccount https://learn.microsoft.com/de-de/powershell/module/az.accounts/connect-azaccount?view=azps-12.4.0]()

