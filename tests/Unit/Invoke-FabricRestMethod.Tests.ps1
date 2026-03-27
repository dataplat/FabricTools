#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Invoke-FabricRestMethod'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Invoke-FabricRestMethod
}

Describe "Invoke-FabricRestMethod" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'Uri'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'Method'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Body'; ExpectedParameterType = 'object'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'TestTokenExpired'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'PowerBIApi'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'NoWait'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'HandleResponse'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ExtractValue'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'TypeName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ObjectIdOrName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'SuccessMessage'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful REST call" {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith {
                return @{
                    value = @(@{ id = 'test-id'; name = 'test-name' })
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should invoke REST method successfully' {
            InModuleScope -ModuleName 'FabricTools' {
                { Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/workspaces' } | Should -Not -Throw
            }
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith {
                return @{
                    errorCode = 'TestError'
                    message = 'API Error'
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should not throw when API returns error response (SkipHttpErrorCheck is used)' {
            InModuleScope -ModuleName 'FabricTools' {
                { Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/workspaces' } | Should -Not -Throw
            }
        }
    }

    Context "User-Agent header" {
        BeforeAll {
            Mock -CommandName Get-PSFConfigValue -MockWith {
                param($FullName)
                switch ($FullName) {
                    'FabricTools.UserAgent' { return 'TestUA/1.2' }
                    'FabricTools.FabricSession.Headers' { return @{} }
                    'FabricTools.FabricApi.ContentType' { return 'application/json; charset=utf-8' }
                    Default { return $null }
                }
            }

            Mock -CommandName Invoke-RestMethod -MockWith {
                return @{ value = @(); statusCode = 200 }
            }

            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should include configured User-Agent header in request' {
            InModuleScope -ModuleName 'FabricTools' {
                Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/test' | Out-Null

                Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                    $Headers -ne $null -and $Headers['User-Agent'] -eq 'TestUA/1.2'
                } -Because 'Invoke-RestMethod should be called with User-Agent header set to configured value'
            }
        }
    }
}
