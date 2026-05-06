#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricReflexDefinition'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Update-FabricReflexDefinition
}

Describe "Update-FabricReflexDefinition" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'ReflexId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'ReflexPathDefinition'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'ReflexPathPlatformDefinition'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful Reflex definition update" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return $null
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Convert-ToBase64 -ModuleName FabricTools -MockWith { return 'base64encodedcontent' }
        }

        It 'Should update Reflex definition with valid parameters' {
            { Update-FabricReflexDefinition -WorkspaceId (New-Guid) -ReflexId (New-Guid) -ReflexPathDefinition 'TestPath' -Confirm:$false } | Should -Not -Throw

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
            Mock -CommandName Convert-ToBase64 -ModuleName FabricTools -MockWith { return 'base64encodedcontent' }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle errors gracefully and write error message' {
            { Update-FabricReflexDefinition -WorkspaceId (New-Guid) -ReflexId (New-Guid) -ReflexPathDefinition 'TestPath' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            } -Times 1 -Exactly
        }
    }
}
