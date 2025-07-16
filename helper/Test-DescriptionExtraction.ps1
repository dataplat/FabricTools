# Test script to verify description extraction

function Get-FunctionDescription {
    param(
        [string]$FilePath
    )

    try {
        $content = Get-Content -Path $FilePath -Raw -ErrorAction Stop

        # Pattern to match .DESCRIPTION section in comment-based help
        # Find everything between .DESCRIPTION and the next help section (.EXAMPLE, .PARAMETER, .INPUTS, etc.)
        $descriptionPattern = '\.DESCRIPTION\s*\r?\n(.*?)(?=\r?\n\.[A-Z]|\r?\n\s*function|\r?\n\s*param|\r?\n\s*\[CmdletBinding|\r?\n\s*$|\r?\n\s*#>)'

        if ($content -match $descriptionPattern) {
            $description = $matches[1].Trim()

            # Clean up the description - remove leading/trailing whitespace and normalize line breaks
            $description = $description -replace '\r?\n\s*', ' '
            $description = $description -replace '\s+', ' '
            $description = $description.Trim()

            return $description
        }

        return $null
    }
    catch {
        Write-Warning "Could not read file: $FilePath - $($_.Exception.Message)"
        return $null
    }
}

# Test with Connect-FabricAccount.ps1
Write-Host "Testing Connect-FabricAccount.ps1..." -ForegroundColor Yellow
$description1 = Get-FunctionDescription -FilePath "source/Public/Connect-FabricAccount.ps1"
if ($description1) {
    Write-Host "✓ Found description: $description1" -ForegroundColor Green
} else {
    Write-Host "✗ No description found" -ForegroundColor Red
}

# Test with Get-FabricAuthToken.ps1
Write-Host "`nTesting Get-FabricAuthToken.ps1..." -ForegroundColor Yellow
$description2 = Get-FunctionDescription -FilePath "source/Public/Get-FabricAuthToken.ps1"
if ($description2) {
    Write-Host "✓ Found description: $description2" -ForegroundColor Green
} else {
    Write-Host "✗ No description found" -ForegroundColor Red
}

# Test with a function from subdirectory
Write-Host "`nTesting Get-FabricCapacities.ps1..." -ForegroundColor Yellow
$description3 = Get-FunctionDescription -FilePath "source/Public/Capacity/Get-FabricCapacities.ps1"
if ($description3) {
    Write-Host "✓ Found description: $description3" -ForegroundColor Green
} else {
    Write-Host "✗ No description found" -ForegroundColor Red
}
