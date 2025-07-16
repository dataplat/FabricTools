---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Get-FabricConfig

## SYNOPSIS
Gets the configuration for use with all functions in the PSFabricTools module.

## SYNTAX

```
Get-FabricConfig [[-ConfigName] <String>]
```

## DESCRIPTION
Gets the configuration for use with all functions in the PSFabricTools module.

## EXAMPLES

### EXAMPLE 1
```
Get-FabricConfig
```

Gets all the configuration values for the PSFabricTools module and outputs them.

### EXAMPLE 2
```
Get-FabricConfig -ConfigName BaseUrl
```

Gets the BaseUrl configuration value for the PSFabricTools module.

## PARAMETERS

### -ConfigName
The name of the configuration to be retrieved.

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

## INPUTS

## OUTPUTS

## NOTES
Author: Jess Pomfret

## RELATED LINKS
