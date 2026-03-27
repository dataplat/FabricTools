<#
.SYNOPSIS
Internal function to get the User-Agent string for FabricTools HTTP calls.

.DESCRIPTION
Internal function to get the User-Agent string for FabricTools HTTP calls.
This includes the PowerShell version, FabricTools module version, OS description and architecture.

.EXAMPLE
Get-FabricUserAgent
#>

function Get-FabricUserAgent {
    [CmdletBinding()]param()
    try {
        $psVersion = $PSVersionTable.PSVersion.ToString()
    } catch {
        $psVersion = 'unknown'
    }

    $moduleVersion = $null
    try {
        $mod = Get-Module -Name FabricTools -ListAvailable | Select-Object -First 1
        if ($mod) { $moduleVersion = $mod.Version.ToString() }
    } catch {
        $moduleVersion = $null
    }

    if (-not $moduleVersion) {
        $candidate = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) '..\FabricTools.psd1'
        $resolved = (Resolve-Path $candidate -ErrorAction SilentlyContinue)
        if ($resolved) {
            try {
                $content = Get-Content $resolved.Path -ErrorAction SilentlyContinue -Raw
                if ($content) {
                    $m = [regex]::Match($content, "ModuleVersion\s*=\s*'([^']+)'")
                    if ($m.Success) { $moduleVersion = $m.Groups[1].Value }
                }
            } catch {
                $moduleVersion = $null
            }
        }
    }

    if (-not $moduleVersion) { $moduleVersion = 'unknown' }

    try {
        $osToken = ([System.Runtime.InteropServices.RuntimeInformation]::OSDescription) -replace '\s+',' '
        $archToken = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
    } catch {
        $osToken = $env:OS -or 'unknown'
        $archToken = $env:PROCESSOR_ARCHITECTURE -or 'unknown'
    }

    return "FabricTools/$moduleVersion powershell/$psVersion ($osToken; $archToken)"
}
