#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Connect-FabricAccount'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Connect-FabricAccount
}

Describe "Connect-FabricAccount" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'TenantId'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ServicePrincipalId'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ServicePrincipalSecret'; ExpectedParameterType = 'securestring'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Credential'; ExpectedParameterType = 'pscredential'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Reset'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'UseDeviceAuthentication'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Device code authentication fallback" {

        BeforeEach {
            Mock -CommandName Get-AzContext -MockWith { $null }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-PSFConfigValue -MockWith { 'https://api.fabric.microsoft.com' }
            Mock -CommandName Set-PSFConfig -MockWith { }
            Mock -CommandName Get-AzAccessToken -MockWith {
                [pscustomobject]@{
                    Token      = (ConvertTo-SecureString -String 'fake-token' -AsPlainText -Force)
                    ExpiresOn  = (Get-Date).AddHours(1)
                    TenantId   = [guid]::NewGuid()
                }
            }
        }

        It 'Should use interactive Connect-AzAccount when broker sign-in succeeds' {
            $script:connectCallLog = [System.Collections.Generic.List[bool]]::new()
            Mock -CommandName Connect-AzAccount -MockWith {
                $script:connectCallLog.Add([bool]$UseDeviceAuthentication)
                [pscustomobject]@{ Context = [pscustomobject]@{ Account = 'user@contoso.com'; Tenant = [pscustomobject]@{ Id = [guid]::NewGuid() } } }
            }

            Connect-FabricAccount -Confirm:$false

            $script:connectCallLog.Count | Should -Be 1
            $script:connectCallLog[0] | Should -BeFalse
        }

        It 'Should fall back to device code authentication when interactive Connect-AzAccount fails' {
            $script:connectCallLog = [System.Collections.Generic.List[bool]]::new()
            Mock -CommandName Connect-AzAccount -MockWith {
                $script:connectCallLog.Add([bool]$UseDeviceAuthentication)
                if (-not $UseDeviceAuthentication) {
                    throw 'No account picker UI could be shown.'
                }
                [pscustomobject]@{ Context = [pscustomobject]@{ Account = 'user@contoso.com'; Tenant = [pscustomobject]@{ Id = [guid]::NewGuid() } } }
            }

            { Connect-FabricAccount -Confirm:$false } | Should -Not -Throw

            $script:connectCallLog.Count | Should -Be 2
            $script:connectCallLog[0] | Should -BeFalse   # first attempt: interactive, fails
            $script:connectCallLog[1] | Should -BeTrue    # second attempt: device code fallback, succeeds
            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Warning' -and $Message -like '*Falling back to device code authentication*' }
        }

        It 'Should go straight to device code authentication when -UseDeviceAuthentication is specified' {
            $script:connectCallLog = [System.Collections.Generic.List[bool]]::new()
            Mock -CommandName Connect-AzAccount -MockWith {
                $script:connectCallLog.Add([bool]$UseDeviceAuthentication)
                [pscustomobject]@{ Context = [pscustomobject]@{ Account = 'user@contoso.com'; Tenant = [pscustomobject]@{ Id = [guid]::NewGuid() } } }
            }

            Connect-FabricAccount -UseDeviceAuthentication -Confirm:$false

            $script:connectCallLog.Count | Should -Be 1
            $script:connectCallLog[0] | Should -BeTrue
        }
    }
}
