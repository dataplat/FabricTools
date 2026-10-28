#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricLongRunningOperation'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricLongRunningOperation
}

Describe "Get-FabricLongRunningOperation" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'operationId'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'location'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'retryAfter'; ExpectedParameterType = 'int'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Timeout'; ExpectedParameterType = 'int'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful operation retrieval" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    status = 'Succeeded'
                    percentComplete = 100
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should return operation status when operationId is provided' {
            $result = Get-FabricLongRunningOperation -operationId 'test-operation-id'

            $result | Should -Not -BeNullOrEmpty
            $result.status | Should -Be 'Succeeded'

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Timeout handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                [pscustomobject]@{ status = 'Running' }
            }
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Start-Sleep -MockWith {
                throw 'Sleep intercepted'
            }
        }

        It 'Should cap the polling interval to the remaining timeout' {
            {
                Get-FabricLongRunningOperation -OperationId 'test-operation-id' -RetryAfter 120 -Timeout 1
            } | Should -Throw

            Should -Invoke -CommandName Start-Sleep -Times 1 -ParameterFilter {
                $Seconds -le 60
            }
        }

        It 'Should cap the status request timeout to the remaining time' {
            Mock -CommandName Start-Sleep -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                [pscustomobject]@{ status = 'Succeeded' }
            }

            Get-FabricLongRunningOperation -OperationId 'test-operation-id' -Timeout 1 | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $RequestTimeoutSeconds -gt 0 -and $RequestTimeoutSeconds -le 60
            }
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should throw an error when API call fails' {
            {
                Get-FabricLongRunningOperation -operationId 'test-operation-id'
            } | Should -Throw
        }
    }
}
