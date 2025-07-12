---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FabricTools
ms.date: 07/12/2025
PlatyPS schema version: 2024-05-01
title: Convert-ToBase64
---

# Convert-ToBase64

## SYNOPSIS

Encodes the content of a file into a Base64-encoded string.

## SYNTAX

### __AllParameterSets

```
Convert-ToBase64 [-filePath] <string> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The Convert-ToBase64  function takes a file path as input, reads the file's content as a byte array,
and converts it into a Base64-encoded string.
This is useful for embedding binary data (e.g., images,
documents) in text-based formats such as JSON or XML.

## EXAMPLES

### EXAMPLE 1

Convert-ToBase64  -filePath "C:\Path\To\File.txt"

Output:
VGhpcyBpcyBhbiBlbmNvZGVkIGZpbGUu

### EXAMPLE 2

$encodedContent = Convert-ToBase64  -filePath "C:\Path\To\Image.jpg"
$encodedContent | Set-Content -Path "C:\Path\To\EncodedImage.txt"

This saves the Base64-encoded content of the image to a text file.

## PARAMETERS

### -filePath

The full path to the file whose contents you want to encode into Base64.

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

### System.String

{{ Fill in the Description }}

## NOTES

- Ensure the file exists at the specified path before running this function.
- Large files may cause memory constraints due to full loading into memory.

Author: Tiago Balabuch

## RELATED LINKS

{{ Fill in the related links here }}

