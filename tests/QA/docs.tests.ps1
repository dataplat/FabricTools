BeforeDiscovery {
    $projectPath = "$($PSScriptRoot)\..\.." | Convert-Path

    . (Join-Path -Path $projectPath -ChildPath '.build/helpers/Get-CommandItemTypeMap.ps1')
    $itemTypeMap = Get-CommandItemTypeMap -PublicPath (Join-Path -Path $projectPath -ChildPath 'src/Public')

    $docsPath = Join-Path -Path $projectPath -ChildPath 'docs/en-US'
    $docCases = foreach ($file in Get-ChildItem -Path $docsPath -Filter '*.md' -File)
    {
        if ((Get-Content -Path $file.FullName -TotalCount 3) -notcontains 'document type: cmdlet') { continue }
        @{ Name = $file.BaseName; Path = $file.FullName; Expected = $itemTypeMap[$file.BaseName] }
    }

    $functionCases = foreach ($name in ($itemTypeMap.Keys | Sort-Object))
    {
        @{ Name = $name; Path = Join-Path -Path $docsPath -ChildPath "$name.md" }
    }
}

Describe 'Documentation item types' -Tag 'Docs' {
    It '<Name> documents a public function and has the matching itemType' -TestCases $docCases {
        $Expected | Should -Not -BeNullOrEmpty -Because "a help file in docs/en-US must document a function in src/Public"

        $itemType = Select-String -Path $Path -Pattern '^itemType:\s*(.+)$' | Select-Object -First 1
        $itemType | Should -Not -BeNullOrEmpty -Because "the frontmatter must contain 'itemType'. Run './build.ps1 -Tasks generate_docs'"
        $itemType.Matches[0].Groups[1].Value.Trim().Trim("'") | Should -Be $Expected
    }

    It 'Public function <Name> has a help file in docs/en-US' -TestCases $functionCases {
        $Path | Should -Exist -Because "run './build.ps1 -Tasks generate_docs' after adding a public function"
    }
}

Describe 'Documentation website' -Tag 'Docs' {
    BeforeAll {
        $projectPath = "$($PSScriptRoot)\..\.." | Convert-Path
        $sitePath = Join-Path -Path $TestDrive -ChildPath 'site'
        $docsPath = Join-Path -Path $projectPath -ChildPath 'docs/en-US'

        $buildParams = @{
            OutputPath = $sitePath
            BaseUrl    = 'https://example.org/FabricTools/'
        }
        $warnings = & (Join-Path -Path $projectPath -ChildPath 'site/Build-DocsSite.ps1') @buildParams 3>&1 6>$null |
            Where-Object { $_ -is [System.Management.Automation.WarningRecord] }

        $commandNames = Get-ChildItem -Path $docsPath -Filter '*.md' -File |
            Where-Object { (Get-Content -Path $_.FullName -TotalCount 3) -contains 'document type: cmdlet' } |
            Select-Object -ExpandProperty BaseName
    }

    It 'builds without warnings' {
        $warnings | Should -BeNullOrEmpty
    }

    It 'creates the Command Explorer, 404 page, sitemap and assets' {
        foreach ($file in 'index.html', '404.html', 'sitemap.xml', 'robots.txt', '.nojekyll', 'assets/site.css', 'assets/site.js', 'assets/commands.js')
        {
            Join-Path -Path $sitePath -ChildPath $file | Should -Exist
        }
    }

    It 'creates a page for every documented command' {
        foreach ($name in $commandNames)
        {
            Join-Path -Path $sitePath -ChildPath "commands/$name/index.html" | Should -Exist
        }
    }

    It 'puts every command with an item type into the search index' {
        $index = Get-Content -Path (Join-Path -Path $sitePath -ChildPath 'assets/commands.js') -Raw
        $json = [regex]::Match($index, 'window\.FABRIC_COMMANDS = (\[.*\]);').Groups[1].Value
        $commands = $json | ConvertFrom-Json

        $commands.Count | Should -Be $commandNames.Count
        $commands | Where-Object { -not $_.itemType -or $_.itemType -eq 'Uncategorized' } | Should -BeNullOrEmpty
    }

    It 'uses BaseUrl for canonical links and the sitemap' {
        Get-Content -Path (Join-Path -Path $sitePath -ChildPath 'sitemap.xml') -Raw |
            Should -Match ([regex]::Escape('https://example.org/FabricTools/commands/'))
        Get-Content -Path (Join-Path -Path $sitePath -ChildPath "commands/$($commandNames[0])/index.html") -Raw |
            Should -Match ([regex]::Escape("<link rel=""canonical"" href=""https://example.org/FabricTools/commands/$($commandNames[0])/"">"))
    }

    It 'HTML-encodes help text' {
        $page = Get-Content -Path (Join-Path -Path $sitePath -ChildPath 'commands/Get-FabricLakehouse/index.html') -Raw
        $page | Should -Match '&lt;guid&gt;' -Because 'the SYNTAX block contains <guid>, which must not be emitted as an HTML tag'
    }
}
