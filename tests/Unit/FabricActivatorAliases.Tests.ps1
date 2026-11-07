#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
}

Describe 'Fabric Activator aliases' -Tag 'UnitTests' {
    It '<AliasName> resolves to <CommandName>' -ForEach @(
        @{ AliasName = 'Get-FabricActivator'; CommandName = 'Get-FabricReflex' }
        @{ AliasName = 'Get-FabricActivatorDefinition'; CommandName = 'Get-FabricReflexDefinition' }
        @{ AliasName = 'New-FabricActivator'; CommandName = 'New-FabricReflex' }
        @{ AliasName = 'Remove-FabricActivator'; CommandName = 'Remove-FabricReflex' }
        @{ AliasName = 'Update-FabricActivator'; CommandName = 'Update-FabricReflex' }
        @{ AliasName = 'Update-FabricActivatorDefinition'; CommandName = 'Update-FabricReflexDefinition' }
    ) {
        $command = Get-Command -Name $AliasName -Module $ModuleName

        $command.CommandType | Should -Be 'Alias'
        $command.ResolvedCommand.Name | Should -Be $CommandName
    }
}
