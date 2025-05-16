<#
.SYNOPSIS
Get the configuration for use with all functions in the PSFabricTools module.

.DESCRIPTION
Get the configuration for use with all functions in the PSFabricTools module.
This is copied from dbatools module, which shows you can do a lot more in here if we need config for integration tests.
https://github.com/dataplat/dbatools/blob/development/private/testing/Get-TestConfig.ps1

.EXAMPLE
PS> Get-TestConfig
Get the configuration for use with all functions in the PSFabricTools module and outputs them.

.NOTES
Thanks Chrissy LeMaire for the original code.

#>
function Get-TestConfig {
    $config = [ordered]@{}

    # derive the command name from the CALLING script's filename
    $config['CommandName'] = ($MyInvocation.MyCommand.Name | Split-Path -Leaf).Replace(".Tests.ps1", "")

    if (-not $config['CommandName']) {
        $config['CommandName'] = "Unknown"
    }

    $config['CommonParameters'] = [System.Management.Automation.PSCmdlet]::CommonParameters

    [pscustomobject]$config
}
