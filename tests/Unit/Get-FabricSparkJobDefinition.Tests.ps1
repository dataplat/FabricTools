#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricSparkJobDefinition'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricSparkJobDefinition'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Get-FabricSparkJobDefinition" -Tag "UnitTests" {

    Context "Command definition" {
        BeforeAll {
            $command = Get-Command -Name $CommandName -Module $ModuleName
        }

        It "Command <CommandName> should exist" {
            $command | Should -Not -BeNullOrEmpty
        }

        It "Command <CommandName> should have WorkspaceId parameter" {
            $command | Should -HaveParameter 'WorkspaceId' -Type [guid]
        }

        It "Command <CommandName> should have SparkJobDefinitionId parameter" {
            $command | Should -HaveParameter 'SparkJobDefinitionId' -Type [guid]
        }

        It "Command <CommandName> should have SparkJobDefinitionName parameter" {
            $command | Should -HaveParameter 'SparkJobDefinitionName' -Type [string]
        }
    }

    Context "Get Spark Job Definition successfully" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return @{
                    value = @(
                        [pscustomobject]@{
                            id          = "00000000-0000-0000-0000-000000000001"
                            displayName = "TestSparkJobDefinition"
                            description = "Test Spark Job Definition Description"
                            type        = "SparkJobDefinition"
                        }
                    )
                }
            }
        }

        It "Should return spark job definitions" {
            $result = Get-FabricSparkJobDefinition -WorkspaceId ([guid]::NewGuid())
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "TestSparkJobDefinition"

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }

        It "Should return specific spark job definition by Id" {
            $result = Get-FabricSparkJobDefinition -WorkspaceId ([guid]::NewGuid()) -SparkJobDefinitionId ([guid]::NewGuid())
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw "API Error"
            }
        }

        It "Should handle errors gracefully" {
            { Get-FabricSparkJobDefinition -WorkspaceId ([guid]::NewGuid()) } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
