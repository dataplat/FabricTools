#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDeploymentPipelineRoleAssignments'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricDeploymentPipelineRoleAssignments" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricDeploymentPipelineRoleAssignments
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
    }

    Context 'When getting deployment pipeline role assignments successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ principal = @{ id = [guid]::NewGuid(); displayName = 'User1' }; role = 'Admin' }
                    [pscustomobject]@{ principal = @{ id = [guid]::NewGuid(); displayName = 'User2' }; role = 'Member' }
                )
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockPipelineId = [guid]::NewGuid()

            Get-FabricDeploymentPipelineRoleAssignments -DeploymentPipelineId $mockPipelineId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*deploymentPipelines/*/roleAssignments*"
            }
        }

        It 'Should return the list of role assignments' {
            $mockPipelineId = [guid]::NewGuid()

            $result = Get-FabricDeploymentPipelineRoleAssignments -DeploymentPipelineId $mockPipelineId

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When no role assignments are found' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return $null
            }
        }

        It 'Should return null when no assignments found' {
            $mockPipelineId = [guid]::NewGuid()

            $result = Get-FabricDeploymentPipelineRoleAssignments -DeploymentPipelineId $mockPipelineId

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

            Get-FabricDeploymentPipelineRoleAssignments -DeploymentPipelineId $mockPipelineId

            Should -Invoke -CommandName Write-Error -ParameterFilter {
                $Message -like "*Failed to get deployment pipeline role assignments*"
            }
        }
    }
}
