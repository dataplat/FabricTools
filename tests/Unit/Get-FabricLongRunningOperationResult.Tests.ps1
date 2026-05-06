#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricLongRunningOperationResult'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricLongRunningOperationResult
}

Describe "Get-FabricLongRunningOperationResult" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'operationId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful operation result retrieval" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    definition = [pscustomobject]@{
                        parts = @(
                            [pscustomobject]@{ path = 'item.json'; payload = 'encodedPayload' }
                        )
                    }
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should return operation result when operationId is provided' {
            $result = Get-FabricLongRunningOperationResult -operationId ([guid]::NewGuid())

            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should throw an error when API call fails' {
            {
                Get-FabricLongRunningOperationResult -operationId ([guid]::NewGuid())
            } | Should -Throw
        }
    }
}
