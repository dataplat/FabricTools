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
    Alias: Invoke-FabDatasetRefresh

    Author: Ioana Bouariu

#>
function Invoke-FabricDatasetRefresh {
    # Define aliases for the function for flexibility.
    [Alias("Invoke-FabDatasetRefresh")]

    # Define parameters for the workspace ID and dataset ID.
    param(
        # Mandatory parameter for the dataset ID
        [Parameter(Mandatory = $true, ParameterSetName = "DatasetId")]
        [string]$DatasetID
    )

    Confirm-TokenState

    # Check if the dataset is refreshable
    if ((Get-FabricDataset -DatasetId $DatasetID).isrefreshable -eq $false) {
        # If the dataset is not refreshable, write an error
        Write-Error "Dataset is not refreshable"
    } else {
        # If the dataset is refreshable, invoke a PowerBI REST method to refresh the dataset
        # The URL for the request is constructed using the provided workspace ID and dataset ID.

        # Check if the dataset is refreshable

        # If the dataset is refreshable, invoke a PowerBI REST method to refresh the dataset
        # The URL for the request is constructed using the provided workspace ID and dataset ID.
        return Invoke-RestMethod -Method POST -uri ("$($PowerBI.BaseApiUrl)/datasets/$datasetid/refreshes") -Headers $FabricSession.HeaderParams
    }
}
