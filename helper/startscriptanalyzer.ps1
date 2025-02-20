$rootPath = Switch ($Host.name) {
	'Visual Studio Code Host' { split-path $psEditor.GetEditorContext().CurrentFile.Path }
	'Windows PowerShell ISE Host' { Split-Path -Path $psISE.CurrentFile.FullPath }
	'ConsoleHost' { $PSScriptRoot }
}

$basepath = Split-Path $rootPath -Parent
$basepath = Join-Path (Split-Path $rootPath -Parent) (Split-Path $basePath -Leaf)


Invoke-ScriptAnalyzer `
    -Path $basepath `
    -Recurse `
    -Severity All

#Invoke-ScriptAnalyzer -Path $basepath -Severity Error -Recurse
Invoke-ScriptAnalyzer -Path $basepath -Severity @('Error', 'Warning') -Recurse
