[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param ()

BeforeAll {
    $script:moduleName = 'FabricTools'

    # If the module is not found, run the build task 'noop'.
    if (-not (Get-Module -Name $script:moduleName -ListAvailable)) {
        # Redirect all streams to $null, except the error stream (stream 2)
        & "$PSScriptRoot/../../build.ps1" -Tasks 'noop' 3>&1 4>&1 5>&1 6>&1 > $null
    }

    # Re-import the module using force to get any code changes between runs.
    Import-Module -Name $script:moduleName -Force -ErrorAction 'Stop'

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName
}

AfterAll {
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:moduleName -All | Remove-Module -Force
}

Describe 'Add-FabricDomainWorkspaceAssignmentByCapacity' -Tag 'Public' {
    It 'Should have the correct parameters in parameter set <MockParameterSetName>' -ForEach @(
        @{
            MockParameterSetName = '__AllParameterSets'
            MockExpectedParameters = '[-DomainId] <guid> [-CapacitiesIds] <guid[]> [<CommonParameters>]'
        }
    ) {
        $result = (Get-Command -Name 'Add-FabricDomainWorkspaceAssignmentByCapacity').ParameterSets |
            Where-Object -FilterScript {
                $_.Name -eq $MockParameterSetName
            } |
            Select-Object -Property @(
                @{
                    Name = 'ParameterSetName'
                    Expression = { $_.Name }
                },
                @{
                    Name = 'ParameterListAsString'
                    Expression = { $_.ToString() }
                }
            )

        $result.ParameterSetName | Should -Be $MockParameterSetName
        $result.ParameterListAsString | Should -Be $MockExpectedParameters
    }

    Context 'When assigning workspaces by capacity successfully (201)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return [pscustomobject]@{
                    status = 'Succeeded'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockDomainId = [guid]::NewGuid()
            $mockCapacityIds = @([guid]::NewGuid(), [guid]::NewGuid())

            Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId $mockDomainId -CapacitiesIds $mockCapacityIds

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*admin/domains/*/assignWorkspacesByCapacities" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the response on success' {
            $mockDomainId = [guid]::NewGuid()
            $mockCapacityIds = @([guid]::NewGuid())

            $result = Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId $mockDomainId -CapacitiesIds $mockCapacityIds

            $result.status | Should -Be 'Succeeded'
        }
    }

    Context 'When assigning workspaces by capacity is in progress (202)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 202
                    $script:responseHeader = @{
                        'x-ms-operation-id' = 'op-12345'
                        'Location' = 'https://api.fabric.microsoft.com/v1/operations/op-12345'
                        'Retry-After' = '30'
                    }
                }
                return [pscustomobject]@{}
            }
            Mock -CommandName Get-FabricLongRunningOperation -MockWith {
                return [pscustomobject]@{
                    status = 'Succeeded'
                    operationId = 'op-12345'
                }
            }
        }

        It 'Should call Get-FabricLongRunningOperation when status is 202' {
            $mockDomainId = [guid]::NewGuid()
            $mockCapacityIds = @([guid]::NewGuid())

            Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId $mockDomainId -CapacitiesIds $mockCapacityIds

            Should -Invoke -CommandName Get-FabricLongRunningOperation -Times 1
        }

        It 'Should return the operation status when long running operation succeeds' {
            $mockDomainId = [guid]::NewGuid()
            $mockCapacityIds = @([guid]::NewGuid())

            $result = Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId $mockDomainId -CapacitiesIds $mockCapacityIds

            $result.status | Should -Be 'Succeeded'
        }
    }

    Context 'When long running operation fails' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 202
                    $script:responseHeader = @{
                        'x-ms-operation-id' = 'op-failed'
                        'Location' = 'https://api.fabric.microsoft.com/v1/operations/op-failed'
                        'Retry-After' = '30'
                    }
                }
                return [pscustomobject]@{}
            }
            Mock -CommandName Get-FabricLongRunningOperation -MockWith {
                return [pscustomobject]@{
                    status = 'Failed'
                    operationId = 'op-failed'
                    error = @{
                        message = 'Operation failed'
                    }
                }
            }
        }

        It 'Should return the failed operation status' {
            $mockDomainId = [guid]::NewGuid()
            $mockCapacityIds = @([guid]::NewGuid())

            $result = Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId $mockDomainId -CapacitiesIds $mockCapacityIds

            $result.status | Should -Be 'Failed'
        }
    }

    Context 'When an unexpected status code is returned' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                return [pscustomobject]@{
                    message = 'Bad Request'
                    errorCode = 'InvalidRequest'
                }
            }
        }

        It 'Should write an error message for unexpected status codes' {
            $mockDomainId = [guid]::NewGuid()
            $mockCapacityIds = @([guid]::NewGuid())

            Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId $mockDomainId -CapacitiesIds $mockCapacityIds

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should handle exceptions gracefully' {
            $mockDomainId = [guid]::NewGuid()
            $mockCapacityIds = @([guid]::NewGuid())

            { Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId $mockDomainId -CapacitiesIds $mockCapacityIds } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Error occurred while assigning workspaces*"
            }
        }
    }
}
