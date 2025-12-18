#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Start-FabricDeploymentPipelineStage'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Start-FabricDeploymentPipelineStage
}

Describe "Start-FabricDeploymentPipelineStage" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'DeploymentPipelineId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'SourceStageId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'TargetStageId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'Items'; ExpectedParameterType = 'array'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Note'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'NoWait'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful deployment pipeline stage start" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    executionPlanId = 'execution-plan-guid'
                    status = 'Running'
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should start deployment pipeline stage with valid parameters' {
            $result = Start-FabricDeploymentPipelineStage -DeploymentPipelineId (New-Guid) -SourceStageId (New-Guid) -TargetStageId (New-Guid) -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
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
            Mock -CommandName Write-Error -MockWith { }
        }

        It 'Should handle errors gracefully and write error message' {
            { Start-FabricDeploymentPipelineStage -DeploymentPipelineId (New-Guid) -SourceStageId (New-Guid) -TargetStageId (New-Guid) -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Error -ParameterFilter {
                $Message -like "*Failed to initiate deployment*"
            }
        }
    }
}
