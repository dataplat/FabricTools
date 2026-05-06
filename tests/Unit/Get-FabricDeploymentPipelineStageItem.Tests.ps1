#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDeploymentPipelineStageItem'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricDeploymentPipelineStageItem" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricDeploymentPipelineStageItem
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'DeploymentPipelineId'; Mandatory = $true }
            @{ Name = 'StageId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting deployment pipeline stage items successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ itemId = [guid]::NewGuid(); itemDisplayName = 'Report1'; itemType = 'Report' }
                    [pscustomobject]@{ itemId = [guid]::NewGuid(); itemDisplayName = 'SemanticModel1'; itemType = 'SemanticModel' }
                )
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockPipelineId = [guid]::NewGuid()
            $mockStageId = [guid]::NewGuid()

            Get-FabricDeploymentPipelineStageItem -DeploymentPipelineId $mockPipelineId -StageId $mockStageId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*deploymentPipelines/*/stages/*/items*" -and
                $Method -eq 'GET'
            }
        }

        It 'Should return the list of stage items' {
            $mockPipelineId = [guid]::NewGuid()
            $mockStageId = [guid]::NewGuid()

            $result = Get-FabricDeploymentPipelineStageItem -DeploymentPipelineId $mockPipelineId -StageId $mockStageId

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When no items are found in the stage' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return $null
            }
        }

        It 'Should return null when no items found' {
            $mockPipelineId = [guid]::NewGuid()
            $mockStageId = [guid]::NewGuid()

            $result = Get-FabricDeploymentPipelineStageItem -DeploymentPipelineId $mockPipelineId -StageId $mockStageId

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
            $mockStageId = [guid]::NewGuid()

            { Get-FabricDeploymentPipelineStageItem -DeploymentPipelineId $mockPipelineId -StageId $mockStageId } | Should -Not -Throw

            Should -Invoke -CommandName Write-Error -ParameterFilter {
                $Message -like "*Failed to retrieve deployment pipeline stage items*"
            }
        }
    }
}
