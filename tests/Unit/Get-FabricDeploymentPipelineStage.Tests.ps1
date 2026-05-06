#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDeploymentPipelineStage'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricDeploymentPipelineStage" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricDeploymentPipelineStage
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'DeploymentPipelineId'; Mandatory = $true }
            @{ Name = 'StageId'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting all deployment pipeline stages successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ id = [guid]::NewGuid(); displayName = 'Development'; order = 0 }
                    [pscustomobject]@{ id = [guid]::NewGuid(); displayName = 'Test'; order = 1 }
                    [pscustomobject]@{ id = [guid]::NewGuid(); displayName = 'Production'; order = 2 }
                )
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockPipelineId = [guid]::NewGuid()

            Get-FabricDeploymentPipelineStage -DeploymentPipelineId $mockPipelineId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*deploymentPipelines/*/stages*" -and
                $Method -eq 'GET'
            }
        }

        It 'Should return the list of stages' {
            $mockPipelineId = [guid]::NewGuid()

            $result = Get-FabricDeploymentPipelineStage -DeploymentPipelineId $mockPipelineId

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 3
        }
    }

    Context 'When getting a specific stage successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'Production'
                    order = 2
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the stage ID in the URI' {
            $mockPipelineId = [guid]::NewGuid()
            $mockStageId = [guid]::NewGuid().ToString()

            Get-FabricDeploymentPipelineStage -DeploymentPipelineId $mockPipelineId -StageId $mockStageId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*deploymentPipelines/*/stages/*"
            }
        }
    }

    Context 'When no stages are found' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return $null
            }
        }

        It 'Should return null when no stages found' {
            $mockPipelineId = [guid]::NewGuid()

            $result = Get-FabricDeploymentPipelineStage -DeploymentPipelineId $mockPipelineId

            $result | Should -BeNullOrEmpty
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Error -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should handle exceptions gracefully' {
            $mockPipelineId = [guid]::NewGuid()

            { Get-FabricDeploymentPipelineStage -DeploymentPipelineId $mockPipelineId } | Should -Not -Throw

            Should -Invoke -CommandName Write-Error -ParameterFilter {
                $Message -like "*Failed to retrieve deployment pipeline stage*"
            }
        }
    }
}
