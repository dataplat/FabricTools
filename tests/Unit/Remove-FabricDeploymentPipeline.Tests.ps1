#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Remove-FabricDeploymentPipeline'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Remove-FabricDeploymentPipeline" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Remove-FabricDeploymentPipeline
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'DeploymentPipelineId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When removing deployment pipeline successfully (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return $null
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockDeploymentPipelineId = [guid]::NewGuid()

            Remove-FabricDeploymentPipeline -DeploymentPipelineId $mockDeploymentPipelineId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*deploymentPipelines/*" -and
                $Method -eq 'Delete'
            }
        }
    }

    Context 'When an unexpected status code is returned' -Skip {
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
            $mockDeploymentPipelineId = [guid]::NewGuid()

            Remove-FabricDeploymentPipeline -DeploymentPipelineId $mockDeploymentPipelineId -Confirm:$false

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
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
            $mockDeploymentPipelineId = [guid]::NewGuid()

            { Remove-FabricDeploymentPipeline -DeploymentPipelineId $mockDeploymentPipelineId -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Error -ParameterFilter {
                $Message -like "*Failed to delete deployment pipeline*"
            }
        }
    }
}
