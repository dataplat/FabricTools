
# This script checks for the presence of try/catch blocks in .ps1 files under src/Public and lists those that do not have try/catch.

$all   = Get-ChildItem -Path ".\src\Public\*\*.ps1" -Recurse -Filter "*.ps1"
$withTryCatch    = $all | Where-Object { Select-String -Path $_.FullName -Pattern '\btry\b' -Quiet }
$withoutTryCatch = $all | Where-Object { -not (Select-String -Path $_.FullName -Pattern '\btry\b' -Quiet) }

Write-Host "Without try/catch: $($withoutTryCatch.Count) / $($all.Count)" -ForegroundColor Cyan
$withoutTryCatch | ForEach-Object {
    $_.FullName.Replace((Resolve-Path ".\src\Public").Path + "\", "")
}
