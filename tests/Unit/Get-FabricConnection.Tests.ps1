#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $PSDefaultParameterValues['Mock:ModuleName'] = 'FabricTools'
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = 'FabricTools'
    $PSDefaultParameterValues['Should:ModuleName'] = 'FabricTools'
}

Describe 'Get-FabricConnection' -Tag 'UnitTests' {
    It 'Supports ID and name filters' {
        $command = Get-Command Get-FabricConnection
        $command | Should -HaveParameter connectionId -Mandatory:$false
        $command | Should -HaveParameter ConnectionName -Mandatory:$false
    }

    It 'Lists connections and extracts the value collection' {
        InModuleScope FabricTools {
            Mock Confirm-TokenState {}
            Mock Invoke-FabricRestMethod { @([pscustomobject]@{ displayName = 'One' }) }
            $result = Get-FabricConnection
            $result.Count | Should -Be 1
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'connections' -and $ExtractValue -eq 'True' -and $HandleResponse
            }
        }
    }

    It 'Retrieves a connection by ID' {
        InModuleScope FabricTools {
            Mock Confirm-TokenState {}
            Mock Invoke-FabricRestMethod { [pscustomobject]@{ displayName = 'One' } }
            $id = [guid]::NewGuid()
            (Get-FabricConnection -connectionId $id).displayName | Should -Be 'One'
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter { $Uri -eq "connections/$id" }
        }
    }

    It 'Returns only an exact display-name match' {
        InModuleScope FabricTools {
            Mock Confirm-TokenState {}
            Mock Invoke-FabricRestMethod {
                @(
                    [pscustomobject]@{ displayName = 'Finance API' }
                    [pscustomobject]@{ displayName = 'Finance API v2' }
                )
            }
            $result = Get-FabricConnection -ConnectionName 'Finance API'
            $result.Count | Should -Be 1
            $result.displayName | Should -Be 'Finance API'
        }
    }

    It 'Rejects ambiguous names and both selectors' {
        InModuleScope FabricTools {
            Mock Confirm-TokenState {}
            Mock Invoke-FabricRestMethod {
                @(
                    [pscustomobject]@{ displayName = 'Finance API' }
                    [pscustomobject]@{ displayName = 'Finance API' }
                )
            }
            { Get-FabricConnection -ConnectionName 'Finance API' } | Should -Throw '*ambiguous*'
            { Get-FabricConnection -connectionId ([guid]::NewGuid()) -ConnectionName 'Finance API' } | Should -Throw '*Specify either*'
        }
    }

    It 'Returns no results when the connection list is empty' {
        InModuleScope FabricTools {
            Mock Confirm-TokenState {}
            Mock Invoke-FabricRestMethod { $null }
            Get-FabricConnection | Should -BeNullOrEmpty
        }
    }

    It 'Propagates API errors' {
        InModuleScope FabricTools {
            Mock Confirm-TokenState {}
            Mock Invoke-FabricRestMethod { throw 'API connection failed' }
            { Get-FabricConnection } | Should -Throw '*API connection failed*'
        }
    }
}
