#Requires -Version 5.1

<#
.SYNOPSIS
    Updates the readme.md file with actual function descriptions from PowerShell function files.

.DESCRIPTION
    This script scans all PowerShell function files in the source/Public directory and its subdirectories,
    extracts the .DESCRIPTION from each function's comment-based help, and replaces the placeholders
    in the documentation/readme.md file with the actual descriptions.

.PARAMETER ReadmePath
    Path to the readme.md file. Defaults to "documentation/readme.md".

.PARAMETER PublicPath
    Path to the Public directory containing function files. Defaults to "source/Public".

.EXAMPLE
    .\Update-ReadmeDescriptions.ps1

    Updates the readme.md file with descriptions from all function files.

.EXAMPLE
    .\Update-ReadmeDescriptions.ps1 -ReadmePath "custom/path/readme.md"

    Updates a custom readme.md file with descriptions from function files.
#>

param(
    [string]$ReadmePath = "documentation/readme.md",
    [string]$PublicPath = "source/Public",
    [switch]$Backup = $true
)

# Function to extract description from a PowerShell function file
function Get-FunctionDescription {
    param(
        [string]$FilePath
    )

    try {
        $lines = Get-Content -Path $FilePath -ErrorAction Stop

        # Find line with ".DESCRIPTION"
        $descriptionStartIndex = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '\.DESCRIPTION') {
                $descriptionStartIndex = $i
                break
            }
        }

        if ($descriptionStartIndex -eq -1) {
            return $null
        }

        # Find the next line that starts with "." after .DESCRIPTION
        $descriptionEndIndex = -1
        for ($i = $descriptionStartIndex + 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\s*\.') {
                $descriptionEndIndex = $i
                break
            }
        }

        # If no next section found, go to the end of the comment block
        if ($descriptionEndIndex -eq -1) {
            for ($i = $descriptionStartIndex + 1; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match '^\s*function|\s*param|\s*\[CmdletBinding|\s*#>\s*$') {
                    $descriptionEndIndex = $i
                    break
                }
            }
        }

        # If still no end found, use the end of file
        if ($descriptionEndIndex -eq -1) {
            $descriptionEndIndex = $lines.Count
        }

        # Extract the description lines
        $descriptionLines = @()
        for ($i = $descriptionStartIndex + 1; $i -lt $descriptionEndIndex; $i++) {
            $descriptionLines += $lines[$i]
        }

        # Join the lines and clean up
        $description = $descriptionLines -join ' '
        $description = $description -replace '\s+', ' '
        $description = $description.Trim()

        return $description
    }
    catch {
        Write-Warning "Could not read file: $FilePath - $($_.Exception.Message)"
        return $null
    }
}

# Function to get function name from file path
function Get-FunctionNameFromPath {
    param(
        [string]$FilePath
    )

    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
    return $fileName
}

# Main script logic
Write-Host "Starting readme.md description update..." -ForegroundColor Green

# Check if paths exist
if (-not (Test-Path $ReadmePath)) {
    Write-Error "Readme file not found: $ReadmePath"
    exit 1
}

if (-not (Test-Path $PublicPath)) {
    Write-Error "Public directory not found: $PublicPath"
    exit 1
}

# Read the current readme content
$readmeContent = Get-Content -Path $ReadmePath -Raw
$originalContent = $readmeContent

# Find all PowerShell function files
$functionFiles = Get-ChildItem -Path $PublicPath -Filter "*.ps1" -Recurse

Write-Host "Found $($functionFiles.Count) function files to process..." -ForegroundColor Yellow

# Create a hashtable to store function descriptions
$functionDescriptions = @{}

# Process each function file
foreach ($file in $functionFiles) {
    $functionName = Get-FunctionNameFromPath -FilePath $file.FullName
    $description = Get-FunctionDescription -FilePath $file.FullName

    if ($description) {
        $functionDescriptions[$functionName] = $description
        Write-Host "  ✓ $functionName" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $functionName (no description found)" -ForegroundColor Red
    }
}

Write-Host "`nProcessing readme.md file..." -ForegroundColor Yellow

# Replace placeholders in the readme content
$replacements = 0

foreach ($functionName in $functionDescriptions.Keys) {
    $placeholder = "{{ Fill in the Description }}"
    $description = $functionDescriptions[$functionName]

    # Look for the pattern: ### [FunctionName](FunctionName.md)
    # followed by {{ Fill in the Description }}
    $pattern = "### \[$functionName\]\([^)]+\)\s*\r?\n$placeholder"
    $replacement = "### [$functionName]($functionName.md)`n$description"

    if ($readmeContent -match $pattern) {
        $readmeContent = $readmeContent -replace $pattern, $replacement
        $replacements++
        Write-Host "  ✓ Updated description for $functionName" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Could not find placeholder for $functionName" -ForegroundColor Red
    }
}

# Check if any changes were made
if ($readmeContent -eq $originalContent) {
    Write-Host "`nNo changes were made to the readme.md file." -ForegroundColor Yellow
} else {
    if ($Backup) {
        # Create backup of original file
        $backupPath = "$ReadmePath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item -Path $ReadmePath -Destination $backupPath
        Write-Host "`nBackup created: $backupPath" -ForegroundColor Cyan
    }

    # Write updated content back to file
    Set-Content -Path $ReadmePath -Value $readmeContent -NoNewline
    Write-Host "`nSuccessfully updated readme.md with $replacements function descriptions!" -ForegroundColor Green
}

Write-Host "`nScript completed." -ForegroundColor Green
