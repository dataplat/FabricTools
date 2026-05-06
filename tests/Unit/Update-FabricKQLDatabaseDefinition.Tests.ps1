#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricKQLDatabaseDefinition'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Update-FabricKQLDatabaseDefinition
}

Describe "Update-FabricKQLDatabaseDefinition" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'KQLDatabaseId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'KQLDatabasePathDefinition'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'KQLDatabasePathPlatformDefinition'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'KQLDatabasePathSchemaDefinition'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful KQL Database definition update" {
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

        It 'Should update KQL Database definition with valid parameters' {
            { Update-FabricKQLDatabaseDefinition -WorkspaceId (New-Guid) -KQLDatabaseId (New-Guid) -KQLDatabasePathDefinition 'TestPath' -Confirm:$false } | Should -Not -Throw

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
            { Update-FabricKQLDatabaseDefinition -WorkspaceId (New-Guid) -KQLDatabaseId (New-Guid) -KQLDatabasePathDefinition 'TestPath' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            } -Times 1 -Exactly
        }
    }
}
