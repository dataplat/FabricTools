@{
    <#
        This is only required if you need to use the method PowerShellGet & PSDepend
        It is not required for PSResourceGet or ModuleFast (and will be ignored).
        See Resolve-Dependency.psd1 on how to enable methods.
    #>
    #PSDependOptions             = @{
    #    AddToPath  = $true
    #    Target     = 'output\RequiredModules'
    #    Parameters = @{
    #        Repository = 'PSGallery'
    #    }
    #}
    Assert                         = "0.9.6"
    InvokeBuild                    = 'latest'
    PSScriptAnalyzer               = '1.24.0'
    Pester                         = 'latest'
    ModuleBuilder                  = 'latest'
    ChangelogManagement            = 'latest'
    Sampler                        = 'latest'
    'Sampler.GitHubTasks'          = 'latest'
    MarkdownLinkCheck              = 'latest'
    'PSFramework'                  = 'latest'
    'Az.Accounts'                  = '5.3.0'
    'Az.Resources'                 = '8.1.1'
    'MicrosoftPowerBIMgmt'         = '1.2.1111'
    'Microsoft.PowerShell.PlatyPS' = 'latest'
}
