#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Remove-FabricWorkspaceIdentity'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Remove-FabricWorkspaceIdentity
}

Describe "Remove-FabricWorkspaceIdentity" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful workspace identity removal" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{ value = $null }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should remove workspace identity with valid parameters' {
            { Remove-FabricWorkspaceIdentity -WorkspaceId (New-Guid) -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Info' -and $Message -like '*successfully deprovisioned*' } -Times 1 -Exactly -Scope It
        }
    }

    Context "Long running operation - Succeeded" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 202
                    $script:responseHeader = @{ "x-ms-operation-id" = "op-12345" }
                }
                return $null
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricLongRunningOperation -ModuleName FabricTools -MockWith {
                return [pscustomobject]@{ status = "Succeeded" }
            }
            Mock -CommandName Get-FabricLongRunningOperationResult -ModuleName FabricTools -MockWith {
                return [pscustomobject]@{ result = "Identity deprovisioned" }
            }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle long running operation that succeeds' {
            $result = Remove-FabricWorkspaceIdentity -WorkspaceId (New-Guid) -Confirm:$false
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Get-FabricLongRunningOperation -ModuleName FabricTools -Times 1 -Exactly
            Should -Invoke -CommandName Get-FabricLongRunningOperationResult -ModuleName FabricTools -Times 1 -Exactly
        }
    }

    Context "Long running operation - Failed" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 202
                    $script:responseHeader = @{ "x-ms-operation-id" = "op-12345" }
                }
                return $null
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricLongRunningOperation -ModuleName FabricTools -MockWith {
                return [pscustomobject]@{ status = "Failed"; error = "Operation failed" }
            }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle long running operation that fails' {
            $result = Remove-FabricWorkspaceIdentity -WorkspaceId (New-Guid) -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.status | Should -Be "Failed"

            Should -Invoke -CommandName Get-FabricLongRunningOperation -ModuleName FabricTools -Times 1 -Exactly
            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' -and $Message -like '*Operation failed*' } -Times 1 -Exactly -Scope It
        }
    }

    Context "Unexpected status code" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 500
                }
                return [pscustomobject]@{ message = "Internal Server Error" }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle unexpected status codes' {
            { Remove-FabricWorkspaceIdentity -WorkspaceId (New-Guid) -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' -and $Message -like '*Unexpected response code*' } -Times 1 -Exactly -Scope It
            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' -and $Message -like '*Error details*' } -Times 1 -Exactly -Scope It
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
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle errors gracefully and write error message' {
            { Remove-FabricWorkspaceIdentity -WorkspaceId (New-Guid) -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to deprovision workspace identity*"
            }
        }
    }
}
