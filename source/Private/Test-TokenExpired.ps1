<#
.SYNOPSIS
Checks if the Fabric token is expired and logs appropriate messages.

.DESCRIPTION
The `Test-TokenExpired` function checks the expiration status of the Fabric token stored in the `$FabricConfig.TokenExpiresOn` variable.
If the token is expired, it logs an error message and provides guidance for refreshing the token.
Otherwise, it logs that the token is still valid.

.EXAMPLE
Test-TokenExpired

Checks the token expiration status using session's `$FabricConfig` object.

.NOTES
- Ensure the `FabricConfig` object includes a valid `TokenExpiresOn` property of type `DateTimeOffset`.
- Requires the `Write-Message` function for logging.
- Uses EnableTokenRefresh feature flag to determine if the token should be refreshed automatically.

.AUTHOR
Tiago Balabuch
#>
function Test-TokenExpired {
    [CmdletBinding()]
    param ()

    Write-Message -Message "Validating token..." -Level Verbose

    try {
        # Ensure required properties have valid values
        if ([string]::IsNullOrWhiteSpace($FabricConfig.TenantId) -or
            [string]::IsNullOrWhiteSpace($FabricConfig.TokenExpiresOn)) {
            Write-Message -Message "Token details are missing. Please run 'Connect-FabricAccount' to configure the session." -Level Error
            throw "MissingTokenDetailsException: Token details are missing."
        }

        # Convert the TokenExpiresOn value to a DateTime object
        if ($FabricConfig.TokenExpiresOn.GetType() -eq [datetimeoffset]) {
            $tokenExpiryDate = $FabricConfig.TokenExpiresOn
        } else {
            $tokenExpiryDate = [datetimeoffset]::Parse($FabricConfig.TokenExpiresOn)
        }

        # Check if the token is expired
        if ($tokenExpiryDate -le [datetimeoffset]::Now) {
            if ($FabricConfig.FeatureFlags.EnableTokenRefresh) {
                Write-Message -Message "Token has expired. Attempting to refresh the token..." -Level Warning
                Connect-FabricAccount -reset
            } else {
                Write-Message -Message "Token has expired and automatic refresh is disabled. Please sign in again using 'Connect-FabricAccount'." -Level Error
                throw "TokenExpiredException: Token has expired."
            }
        }
        else {
            # Log valid token status
            Write-Message -Message "Token is still valid. Expiry time: $($tokenExpiryDate.ToString("u"))" -Level Debug
        }
    } catch [System.FormatException] {
        Write-Message -Message "Invalid 'TokenExpiresOn' format in the FabricConfig object. Ensure it is a valid datetime string." -Level Error
        throw "FormatException: Invalid TokenExpiresOn value."
    } catch {
        # Log unexpected errors with details
        Write-Message -Message "An unexpected error occurred: $_" -Level Error
        throw $_
    }
    Write-Message -Message "Token validation completed." -Level Verbose
}
