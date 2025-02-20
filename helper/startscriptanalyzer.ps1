$basepath = 'D:\GitHub\dataplat\FabricTools\FabricTools'

Invoke-ScriptAnalyzer `
    -Path $basepath `
    -Recurse `
    -Severity All

Invoke-ScriptAnalyzer -Path $basepath -Severity Error -Recurse
Invoke-ScriptAnalyzer -Path $basepath -Severity Warning -Recurse
