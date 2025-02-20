$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Set-Location $currentPath

Import-Module ".\FabricPS-PBIP" -Force

# Set-FabricAuthToken -reset

$workspaceId = "9e34f19a-dec9-4405-88a9-f09b8c99310f"

Export-FabricItems -workspaceId $workspaceId -path '.\export' -filter {$_.id -eq "74ab67cc-1cfc-4275-8a96-1d03ef4e186b"}
