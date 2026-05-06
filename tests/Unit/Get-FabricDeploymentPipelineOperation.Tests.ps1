#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDeploymentPipelineOperation'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricDeploymentPipelineOperation" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricDeploymentPipelineOperation
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'DeploymentPipelineId'; Mandatory = $true }
            @{ Name = 'OperationId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting a specific operation successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    status = 'Succeeded'
                    executionStartTime = (Get-Date).AddHours(-1)
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the operation ID in the URI' {
            $mockPipelineId = [guid]::NewGuid()
            $mockOperationId = [guid]::NewGuid()

            Get-FabricDeploymentPipelineOperation -DeploymentPipelineId $mockPipelineId -OperationId $mockOperationId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*deploymentPipelines/*/operations/*"
            }
        }

        It 'Should return the operation details' {
            $mockPipelineId = [guid]::NewGuid()
            $mockOperationId = [guid]::NewGuid()

            $result = Get-FabricDeploymentPipelineOperation -DeploymentPipelineId $mockPipelineId -OperationId $mockOperationId

            $result | Should -Not -BeNullOrEmpty
            $result.status | Should -Be 'Succeeded'
        }
    }

    Context 'When operation is not found' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return $null
            }
        }

        It 'Should return null when operation not found' {
            $mockPipelineId = [guid]::NewGuid()
            $mockOperationId = [guid]::NewGuid()

            $result = Get-FabricDeploymentPipelineOperation -DeploymentPipelineId $mockPipelineId -OperationId $mockOperationId

            $result | Should -BeNullOrEmpty
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Write-Error -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should handle exceptions and write an error' {
            $mockPipelineId = [guid]::NewGuid()
            $mockOperationId = [guid]::NewGuid()

            Get-FabricDeploymentPipelineOperation -DeploymentPipelineId $mockPipelineId -OperationId $mockOperationId

            Should -Invoke -CommandName Write-Error -ParameterFilter {
                $Message -like "*Failed to retrieve deployment pipeline operation*"
            }
        }
    }
}
