#============================================================================
#  Datei:      createdocumentation.ps1
#
#  Summary:    This script will help to create the documentation for
#              the PowerShell module. Markdown Code will be created
#              with platyPS
#
#  Datum:      2024-11-05
#
#  Revisionen: yyyy-dd-mm
#                   - ...
#
#  PowerShell Version: 7.1
#------------------------------------------------------------------------------
#  Geschrieben von 
#       Frank Geisler, GDS Business Intelligence GmbH
#
#   Dieses Script ist nur zu Lehr- bzw. Lernzwecken gedacht
#
#   DIESER CODE UND DIE ENTHALTENEN INFORMATIONEN WERDEN OHNE GEWÄHR JEGLICHER
#   ART ZUR VERFÜGUNG GESTELLT, WEDER AUSDRÜCKLICH NOCH IMPLIZIT, EINSCHLIESSLICH,
#   ABER NICHT BESCHRÄNKT AUF FUNKTIONALITÄT ODER EIGNUNG FÜR EINEN BESTIMMTEN
#   ZWECK. SIE VERWENDEN DEN CODE AUF EIGENE GEFAHR.
#============================================================================*/

#----------------------------------------------------------------------------
# 01. Define the variables we will need further down the
#     road.
#----------------------------------------------------------------------------

$basepath = 'C:\Users\fgeisler\repos\github\powerrit'
$moduleName = 'powerrti'
$modulePathName = "$basepath\powerrti\$moduleName.psd1"
$markdownPath = "$basepath\documentation"
$mamlPath = "$basepath\en-US"

#----------------------------------------------------------------------------
# 02. Import the module to be documented
#     ATTENTION!!!!!! The module must be loaded in the PowerShell session
#----------------------------------------------------------------------------

# FGE: Remove the module from PowerShell
Remove-Module `
    -Name powerrti `
    -ErrorAction SilentlyContinue

Import-Module `
    -Name $modulePathName

#----------------------------------------------------------------------------
# 03. Create the markdown documentation
#----------------------------------------------------------------------------
New-MarkdownHelp `
    -Module $moduleName `
    -OutputFolder $markdownPath `
    -AlphabeticParamsOrder `
    -UseFullTypeName `
    -WithModulePage `
    -ExcludeDontShow `
    -NoMetadata `
    -Force
