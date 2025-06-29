function Get-FabricEventhouse {
    <#
    .SYNOPSIS
        Retrieves Fabric Eventhouses

    .DESCRIPTION
        Retrieves Fabric Eventhouses. Without the EventhouseName or EventhouseID parameter, all Eventhouses are returned.
        If you want to retrieve a specific Eventhouse, you can use the EventhouseName or EventhouseID parameter. These
        parameters cannot be used together.

    .PARAMETER WorkspaceId
        Id of the Fabric Workspace for which the Eventhouses should be retrieved. The value for WorkspaceId is a GUID.
        An example of a GUID is '12345678-1234-1234-1234-123456789012'.

    .PARAMETER EventhouseName
        The name of the Eventhouse to retrieve. This parameter cannot be used together with EventhouseID.

    .PARAMETER EventhouseId
        The Id of the Eventhouse to retrieve. This parameter cannot be used together with EventhouseName. The value for WorkspaceId is a GUID.
        An example of a GUID is '12345678-1234-1234-1234-123456789012'.

    .EXAMPLE
        Get-FabricEventhouse `
            -WorkspaceId '12345678-1234-1234-1234-123456789012'

        This example will give you all Eventhouses in the Workspace.

    .EXAMPLE
        Get-FabricEventhouse `
            -WorkspaceId '12345678-1234-1234-1234-123456789012' `
            -EventhouseName 'MyEventhouse'

        This example will give you all Information about the Eventhouse with the name 'MyEventhouse'.

    .EXAMPLE
        Get-FabricEventhouse `
            -WorkspaceId '12345678-1234-1234-1234-123456789012' `
            -EventhouseId '12345678-1234-1234-1234-123456789012'

        This example will give you all Information about the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.

        .EXAMPLE
        Get-FabricEventhouse `
            -WorkspaceId '12345678-1234-1234-1234-123456789012' `
            -EventhouseId '12345678-1234-1234-1234-123456789012' `
            -Verbose

        This example will give you all Information about the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.
        It will also give you verbose output which is useful for debugging.

    .LINK
        https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP

    .NOTES
        TODO: Add functionality to list all Eventhouses in the subscription. To do so fetch all workspaces
        and then all eventhouses in each workspace.

        Author: Tiago Balabuch

        #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$EventhouseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventhouseName
    )
    try {

        # Step 1: Handle ambiguous input
        if ($EventhouseId -and $EventhouseName) {
            Write-Message -Message "Both 'EventhouseId' and 'EventhouseName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Step 2: Ensure token validity
        Confirm-TokenState

        # Step 3: Initialize variables
        $continuationToken = $null
        $eventhouses = @()

        if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq "System.Web" })) {
            Add-Type -AssemblyName System.Web
        }

        # Step 4: Loop to retrieve all capacities with continuation token
        Write-Message -Message "Loop started to get continuation token" -Level Debug
        $baseApiEndpointUrl = "{0}/workspaces/{1}/eventhouses" -f $FabricConfig.BaseUrl, $WorkspaceId
        # Step 3:  Loop to retrieve data with continuation token
        do {
            # Step 5: Construct the API URL
            $apiEndpointUrl = $baseApiEndpointUrl

            if ($null -ne $continuationToken) {
                # URL-encode the continuation token
                $encodedToken = [System.Web.HttpUtility]::UrlEncode($continuationToken)
                $apiEndpointUrl = "{0}?continuationToken={1}" -f $apiEndpointUrl, $encodedToken
            }
            Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

            # Step 6: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Get

            # Step 7: Validate the response code
            if ($statusCode -ne 200) {
                Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
                Write-Message -Message "Error: $($response.message)" -Level Error
                Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
                Write-Message "Error Code: $($response.errorCode)" -Level Error
                return $null
            }

            # Step 8: Add data to the list
            if ($null -ne $response) {
                Write-Message -Message "Adding data to the list" -Level Debug
                $eventhouses += $response.value

                # Update the continuation token if present
                if ($response.PSObject.Properties.Match("continuationToken")) {
                    Write-Message -Message "Updating the continuation token" -Level Debug
                    $continuationToken = $response.continuationToken
                    Write-Message -Message "Continuation token: $continuationToken" -Level Debug
                } else {
                    Write-Message -Message "Updating the continuation token to null" -Level Debug
                    $continuationToken = $null
                }
            } else {
                Write-Message -Message "No data received from the API." -Level Warning
                break
            }
        } while ($null -ne $continuationToken)
        Write-Message -Message "Loop finished and all data added to the list" -Level Debug

        # Step 8: Filter results based on provided parameters
        $eventhouse = if ($EventhouseId) {
            $eventhouses | Where-Object { $_.Id -eq $EventhouseId }
        } elseif ($EventhouseName) {
            $eventhouses | Where-Object { $_.DisplayName -eq $EventhouseName }
        } else {
            # Return all eventhouses if no filter is provided
            Write-Message -Message "No filter provided. Returning all Eventhouses." -Level Debug
            $eventhouses
        }

        # Step 9: Handle results
        if ($eventhouse) {
            Write-Message -Message "Eventhouse found in the Workspace '$WorkspaceId'." -Level Debug
            return $eventhouse
        } else {
            Write-Message -Message "No Eventhouse found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Eventhouse. Error: $errorDetails" -Level Error
    }

}
