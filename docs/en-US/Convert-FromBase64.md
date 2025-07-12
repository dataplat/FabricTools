---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Convert-FromBase64
---

# Convert-FromBase64

## SYNOPSIS

Decodes a Base64-encoded string into its original text representation.

## SYNTAX

### __AllParameterSets

```
Convert-FromBase64 [-Base64String] <string> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Convert-FromBase64 function takes a Base64-encoded string as input, decodes it into a byte array,
and converts it back into a UTF-8 encoded string.
It is useful for reversing Base64 encoding applied
to text or other data.

## EXAMPLES

### EXAMPLE 1

Output: Hello, World!

```powershell
Convert-FromBase64 -Base64String "SGVsbG8sIFdvcmxkIQ=="
```

### EXAMPLE 2

Output: Some encoded text

```powershell
$encodedString = "U29tZSBlbmNvZGVkIHRleHQ="
Convert-FromBase64 -Base64String $encodedString
```

## PARAMETERS

### -Base64String

The Base64-encoded string that you want to decode.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function assumes the Base64 input is a valid UTF-8 encoded string.
Any decoding errors will throw a descriptive error message.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

