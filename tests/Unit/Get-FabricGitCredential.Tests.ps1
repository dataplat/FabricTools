#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe 'Get-FabricGitCredential' -Tag 'UnitTests' {

    BeforeAll {
        $command = Get-Command -Name Get-FabricGitCredential
    }

    Context 'Command definition' {
        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting credentials' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                [pscustomobject]@{ source = 'ConfiguredConnection'; connectionId = 'c1' }
            }
            $workspaceId = [guid]::NewGuid()
        }

        It 'Should call the myGitCredentials endpoint with GET' {
            Get-FabricGitCredential -WorkspaceId $workspaceId | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "workspaces/$workspaceId/git/myGitCredentials" -and $Method -eq 'Get'
            }
        }

        It 'Should return the credentials with WorkspaceId added' {
            $result = Get-FabricGitCredential -WorkspaceId $workspaceId

            $result.source | Should -Be 'ConfiguredConnection'
            $result.connectionId | Should -Be 'c1'
            $result.WorkspaceId | Should -Be $workspaceId
        }
    }
}
