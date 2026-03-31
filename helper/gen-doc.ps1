# Init
Install-Module Microsoft.PowerShell.PlatyPS
Import-Module Microsoft.PowerShell.PlatyPS
Get-Module -Name "*PlatyPS"

# OLD
./build.ps1 -Tasks Generate_help_from_built_module

# NEW
./build.ps1 -Tasks generate_docs
