function Invoke-FabricDatasetRefresh {
    <#
    .SYNOPSIS
    This function invokes a refresh of a PowerBI dataset

    .DESCRIPTION
    The Invoke-FabricDatasetRefresh function is used to refresh a PowerBI dataset.
    It first checks if the dataset is refreshable.
    If it is not, it writes an error. If it is, it invokes a PowerBI REST method to refresh the dataset.
    The URL for the request is constructed using the provided  dataset ID.

    .PARAMETER DatasetID
    A mandatory parameter that specifies the dataset ID.

    .EXAMPLE
    Invoke-FabricDatasetRefresh  -DatasetID "12345678-1234-1234-1234-123456789012"

    This command invokes a refresh of the dataset with the ID "12345678-1234-1234-1234-123456789012"

    .NOTES

    Author: Ioana Bouariu

#>
    # Define aliases for the function for flexibility.

    # Define parameters for the workspace ID and dataset ID.
    param(
        # Mandatory parameter for the dataset ID
        [Parameter(Mandatory = $true, ParameterSetName = "DatasetId")]
        [guid]$DatasetID
    )

    Confirm-TokenState

    # Check if the dataset is refreshable
    if ((Get-FabricDataset -DatasetId $DatasetID).isrefreshable -eq $false) {
        # If the dataset is not refreshable, write an error
        Write-Error "Dataset is not refreshable"
    } else {
        # If the dataset is refreshable, invoke a PowerBI REST method to refresh the dataset
        # The URL for the request is constructed using the provided workspace ID and dataset ID.
        Invoke-FabricRestMethod -Method POST -PowerBIApi -Uri "datasets/$DatasetID/refreshes"
    }
}
