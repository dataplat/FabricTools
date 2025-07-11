---
external help file: FabricTools-help.xml
Module Name: FabricTools
online version:
schema: 2.0.0
---

# Convert-ToBase64

## SYNOPSIS
Encodes the content of a file into a Base64-encoded string.

## SYNTAX

```
Convert-ToBase64 [-filePath] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Convert-ToBase64  function takes a file path as input, reads the file's content as a byte array,
and converts it into a Base64-encoded string.
This is useful for embedding binary data (e.g., images,
documents) in text-based formats such as JSON or XML.

## EXAMPLES

### EXAMPLE 1
```
Convert-ToBase64  -filePath "C:\Path\To\File.txt"
```

Output:
VGhpcyBpcyBhbiBlbmNvZGVkIGZpbGUu

### EXAMPLE 2
```
$encodedContent = Convert-ToBase64  -filePath "C:\Path\To\Image.jpg"
$encodedContent | Set-Content -Path "C:\Path\To\EncodedImage.txt"
```

This saves the Base64-encoded content of the image to a text file.

## PARAMETERS

### -filePath
The full path to the file whose contents you want to encode into Base64.

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

### System.String
## NOTES
- Ensure the file exists at the specified path before running this function.
- Large files may cause memory constraints due to full loading into memory.

Author: Tiago Balabuch

## RELATED LINKS
