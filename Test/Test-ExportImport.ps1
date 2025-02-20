$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Set-Location $currentPath

Import-Module ".\FabricPS-PBIP" -Force

$exportWorkspaceId = "d020f53d-eb41-421d-af50-8279882524f3"

Export-FabricItems -workspaceId $exportWorkspaceId -path '.\export'

$importWorkspaceId = "5bff05e0-355e-41d3-a776-08659726f396"

#Remove-FabricItems -workspaceId "5bff05e0-355e-41d3-a776-08659726f396"

Import-FabricItems -workspaceId $importWorkspaceId -path '.\export'

