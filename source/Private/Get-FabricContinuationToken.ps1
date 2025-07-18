function Get-FabricContinuationToken {
    <#
.SYNOPSIS
Internal function to handle continuation token logic for Fabric API calls.

.DESCRIPTION
The `Get-FabricContinuationToken` function processes the API response to extract and handle continuation tokens.
It returns the continuation token variable and provides debug logging.

.PARAMETER Response
The API response object that may contain a continuation token.

.EXAMPLE
Get-FabricContinuationToken -Response $response

Processes the response and returns the continuation token if present.

.NOTES
This is an internal function used by other functions in the module.

Author: Kamil Nowinski
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [object]$Response
    )

    $continuationToken = $null
    if ($null -ne $Response) {
        # Update the continuation token if present
        if ($Response.PSObject.Properties.Match("continuationToken")) {
            $continuationToken = $Response.continuationToken
            Write-Message -Message "New continuation token: $continuationToken" -Level Debug
        } else {
            Write-Message -Message "New continuation token to null" -Level Debug
        }
    } else {
        Write-Message -Message "No data received from the API." -Level Warning
    }
    $continuationToken
}
