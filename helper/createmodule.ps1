#============================================================================
#  Datei:      createmodule.ps1
#
#  Summary:    This script helps creating the module. It has the 
#              New-ModuleManifest function in it.
#
#  Datum:      2024-11-04
#
#  Revisionen: yyyy-dd-mm
#                   - ...
#  Kunde:      Kunde
#
#  Projekt:    PowerRTI
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

New-ModuleManifest `
    -Path '.\powerrti.psd1' `
    -RootModule '.\powerrti.psm1' `
    -Author 'Frank Geisler' `
    -CompanyName 'GDS Business Intelligence GmbH' `
    -Description 'PowerRTI is a PowerShell module to automate Fabric Real-Time Intelligence in PowerShell' `
    -ModuleVersion '0.1.0' `
    -PowerShellVersion '7.1' `
    -FunctionsToExport '*' `
    -VariablesToExport '*' `
    -AliasesToExport '*' `
    -CmdletsToExport '*' `
    -TypesToProcess '*' `
    -FormatsToProcess '*' 

# FGE: Import the module for testing
Import-Module `
    -Name 'C:\Users\fgeisler\repos\github\powerrit\powerrti\powerrti.psd1'

Remove-Module `
    -Name 'PowerRTI' `
    -Force