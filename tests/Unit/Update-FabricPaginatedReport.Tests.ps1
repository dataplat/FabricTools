#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricPaginatedReport'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Update-FabricPaginatedReport
}

Describe "Update-FabricPaginatedReport" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'PaginatedReportId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'PaginatedReportName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'PaginatedReportDescription'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful Paginated Report update" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id = 'report-guid'
                    displayName = 'Updated Report'
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should update Paginated Report with valid parameters' {
            $result = Update-FabricPaginatedReport -WorkspaceId (New-Guid) -PaginatedReportId (New-Guid) -PaginatedReportName 'Updated Report' -Confirm:$false

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
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle errors gracefully and write error message' {
            { Update-FabricPaginatedReport -WorkspaceId (New-Guid) -PaginatedReportId (New-Guid) -PaginatedReportName 'Test' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            } -Times 1 -Exactly
        }
    }
}
