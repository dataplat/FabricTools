#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDomainWorkspace'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricDomainWorkspace" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricDomainWorkspace
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'DomainId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting domain workspaces successfully (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return @(
                    [pscustomobject]@{ id = [guid]::NewGuid(); displayName = 'Workspace1' }
                    [pscustomobject]@{ id = [guid]::NewGuid(); displayName = 'Workspace2' }
                )
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockDomainId = [guid]::NewGuid()

            Get-FabricDomainWorkspace -DomainId $mockDomainId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*admin/domains/*/workspaces" -and
                $Method -eq 'Get'
            }
        }

        It 'Should return the list of workspaces' {
            $mockDomainId = [guid]::NewGuid()

            $result = Get-FabricDomainWorkspace -DomainId $mockDomainId

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }
}
