Remove-Module -Name FabricTools -ErrorAction SilentlyContinue
./build.ps1 -Tasks build
ipmo .\output\module\FabricTools\0.0.1\FabricTools.psd1
Get-Module FabricTools

Write-Host "Connecting to Fabric Account..." -ForegroundColor Cyan
Connect-FabricAccount

Write-Host "Build completed successfully!" -ForegroundColor Green
