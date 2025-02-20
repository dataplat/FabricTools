<#
.SYNOPSIS
    This function invokes a refresh of a PowerBI dataset

.DESCRIPTION
    The Invoke-FabricDatasetRefresh function is used to refresh a PowerBI dataset. It first checks if the dataset is refreshable. If it is not, it writes an error. If it is, it invokes a PowerBI REST method to refresh the dataset. The URL for the request is constructed using the provided  dataset ID.


.PARAMETER DatasetID
    A mandatory parameter that specifies the dataset ID.

.EXAMPLE
    Invoke-FabricDatasetRefresh  -DatasetID "12345678-1234-1234-1234-123456789012"

    This command invokes a refresh of the dataset with the ID "12345678-1234-1234-1234-123456789012"
.NOTES
    Alias: Invoke-FabDatasetRetresh
#>
function Invoke-FabricDatasetRefresh {
    # Define aliases for the function for flexibility.
    [Alias("Invoke-FabDatasetRefresh")]

    # Define parameters for the workspace ID and dataset ID.
    param(
        # Mandatory parameter for the dataset ID
        [Parameter(Mandatory = $true, ParameterSetName = "DatasetId")]
        [string]$DatasetID,
        # Optional parameter for the authentication token
        [Parameter(Mandatory = $false)]
        [string]$authToken
    )

    # Check if the dataset is refreshable
    if ((Get-FabricDataset -DatasetId $DatasetID).isrefreshable -eq $false) {
        # If the dataset is not refreshable, write an error
        Write-error "Dataset is not refreshable"
    }
    else {
        # If the dataset is refreshable, invoke a PowerBI REST method to refresh the dataset
        # The URL for the request is constructed using the provided workspace ID and dataset ID.
        if ([string]::IsNullOrEmpty($authToken)) {
            $authToken = Get-FabricAuthToken
        }
        $fabricHeaders = @{
            'Content-Type'  = $contentType
            'Authorization' = "Bearer {0}" -f $authToken
        }
        # Check if the dataset is refreshable

        # If the dataset is refreshable, invoke a PowerBI REST method to refresh the dataset
        # The URL for the request is constructed using the provided workspace ID and dataset ID.
        return invoke-restmethod -Method POST -uri ("https://api.powerbi.com/v1.0/myorg/datasets/$datasetid/refreshes") -Headers $fabricHeaders
    }
}