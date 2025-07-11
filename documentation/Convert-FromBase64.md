---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Convert-FromBase64

## SYNOPSIS
Decodes a Base64-encoded string into its original text representation.

## SYNTAX

```
Convert-FromBase64 [-Base64String] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Convert-FromBase64 function takes a Base64-encoded string as input, decodes it into a byte array,
and converts it back into a UTF-8 encoded string.
It is useful for reversing Base64 encoding applied
to text or other data.

## EXAMPLES

### EXAMPLE 1
```
Convert-FromBase64 -Base64String "SGVsbG8sIFdvcmxkIQ=="
```

Output:
Hello, World!

### EXAMPLE 2
```
$encodedString = "U29tZSBlbmNvZGVkIHRleHQ="
Convert-FromBase64 -Base64String $encodedString
```

Output:
Some encoded text

## PARAMETERS

### -Base64String
The Base64-encoded string that you want to decode.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function assumes the Base64 input is a valid UTF-8 encoded string.
Any decoding errors will throw a descriptive error message.

Author: Tiago Balabuch

## RELATED LINKS
