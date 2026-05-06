#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDeploymentPipeline'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricDeploymentPipeline" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricDeploymentPipeline
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'DeploymentPipelineId'; Mandatory = $false }
            @{ Name = 'DeploymentPipelineName'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When retrieving deployment pipelines successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{
                        Id = [guid]::NewGuid()
                        DisplayName = 'TestDeploymentPipeline1'
                    },
                    [pscustomobject]@{
                        Id = [guid]::NewGuid()
                        DisplayName = 'TestDeploymentPipeline2'
                    }
                )
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            Get-FabricDeploymentPipeline

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*deploymentPipelines*" -and
                $Method -eq 'Get'
            }
        }

        It 'Should return all deployment pipelines when no filter is provided' {
            $result = Get-FabricDeploymentPipeline

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When both DeploymentPipelineId and DeploymentPipelineName are provided' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Warning -MockWith { }
        }

        It 'Should write a warning message' {
            $mockDeploymentPipelineId = [guid]::NewGuid()

            Get-FabricDeploymentPipeline -DeploymentPipelineId $mockDeploymentPipelineId -DeploymentPipelineName 'TestDeploymentPipeline'

            Should -Invoke -CommandName Write-Warning -Times 1
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
            Get-FabricDeploymentPipeline

            Should -Invoke -CommandName Write-Error -ParameterFilter {
                $Message -like "*Failed to retrieve deployment pipelines*"
            }
        }
    }
}
