<#
.SYNOPSIS
Calculates the SHA256 hash of a string.

.DESCRIPTION
The Get-Sha256 function calculates the SHA256 hash of a string.

.PARAMETER string
The string to hash. This is a mandatory parameter.

.EXAMPLE
Get-Sha256 -string "your-string"

This example calculates the SHA256 hash of a string.

.NOTES
The function creates a new SHA256CryptoServiceProvider object, converts the string to a byte array using UTF8 encoding, computes the SHA256 hash of the byte array, converts the hash to a string and removes any hyphens, and returns the resulting hash.
#>

# This function calculates the SHA256 hash of a string.
function Get-Sha256 ($string) {
    # Create a new SHA256CryptoServiceProvider object.
    $sha256 = New-Object System.Security.Cryptography.SHA256CryptoServiceProvider

    # Convert the string to a byte array using UTF8 encoding.
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($string)

    # Compute the SHA256 hash of the byte array.
    $hash = $sha256.ComputeHash($bytes)

    # Convert the hash to a string and remove any hyphens.
    $result = [System.BitConverter]::ToString($hash) -replace '-'

    # Return the resulting hash.
    return $result
}