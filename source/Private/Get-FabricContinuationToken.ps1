<#
.SYNOPSIS
Internal function to handle continuation token logic for Fabric API calls.

.DESCRIPTION
The `Get-FabricContinuationToken` function processes the API response to extract and handle continuation tokens.
It updates the continuation token variable and provides debug logging.

.PARAMETER Response
The API response object that may contain a continuation token.

.PARAMETER ContinuationToken
The current continuation token variable that will be updated.

.EXAMPLE
Get-FabricContinuationToken -Response $response -ContinuationToken $continuationToken

Processes the response and updates the continuation token if present.

.NOTES
This is an internal function used by other functions in the module.

Author: Kamil Nowinski
#>

function Get-FabricContinuationToken {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [object]$Response,

        [Parameter(Mandatory = $true)]
        [ref]$ContinuationToken
    )

    if ($null -ne $Response) {
        Write-Message -Message "Adding data to the list" -Level Debug

        # Update the continuation token if present
        if ($Response.PSObject.Properties.Match("continuationToken")) {
            Write-Message -Message "Updating the continuation token" -Level Debug
            $ContinuationToken.Value = $Response.continuationToken
            Write-Message -Message "Continuation token: $($ContinuationToken.Value)" -Level Debug
        } else {
            Write-Message -Message "Updating the continuation token to null" -Level Debug
            $ContinuationToken.Value = $null
        }
    } else {
        Write-Message -Message "No data received from the API." -Level Warning
        $ContinuationToken.Value = $null
    }
}
