# Set-FabricAuthToken

## SYNOPSIS
Sets the Fabric authentication token.

## SYNTAX

```
Set-FabricAuthToken [[-servicePrincipalId] <String>] [[-servicePrincipalSecret] <String>]
 [[-credential] <PSCredential>] [[-tenantId] <String>] [-reset] [[-apiUrl] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-FabricAuthToken function sets the Fabric authentication token.
It checks if an Azure context is already available.
If not, it connects to the Azure account using either a service principal ID and secret, a provided credential, or interactive login.
It then gets the Azure context and sets the Fabric authentication token.

## EXAMPLES

### EXAMPLE 1
```
Set-FabricAuthToken -servicePrincipalId "12345678-90ab-cdef-1234-567890abcdef" -servicePrincipalSecret "secret" -tenantId "12345678-90ab-cdef-1234-567890abcdef"
```

This command sets the Fabric authentication token using the provided service principal ID, secret, and tenant ID.

## PARAMETERS

### -apiUrl
{{ Fill apiUrl Description }}

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -credential
The credential.
If provided, the function uses this credential to connect to the Azure account.

```yaml
Type: System.Management.Automation.PSCredential
Parameter Sets: (All)
Aliases:

Required: False
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

### -reset
{{ Fill reset Description }}

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -servicePrincipalId
The service principal ID.
If provided, the function uses this ID and the service principal secret to connect to the Azure account.

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

### -servicePrincipalSecret
The service principal secret.
Used with the service principal ID to connect to the Azure account.

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

### -tenantId
The tenant ID.
Used with the service principal ID and secret or the credential to connect to the Azure account.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

### String, SecureString, PSCredential. You can pipe a string that contains the service principal ID, a secure string that contains the service principal secret, and a PSCredential object that contains the credential to Set-FabricAuthToken.
## OUTPUTS

### None. This function does not return any output.
## NOTES
This function was originally written by Rui Romano.
https://github.com/RuiRomano/fabricps-pbip

## RELATED LINKS
