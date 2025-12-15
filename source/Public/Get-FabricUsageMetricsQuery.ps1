function Get-FabricUsageMetricsQuery {
    <#
.SYNOPSIS
Retrieves usage metrics for a specific dataset.

.DESCRIPTION
The Get-FabricUsageMetricsQuery function retrieves usage metrics for a specific dataset.

.PARAMETER DatasetID
The ID of the dataset. This is a mandatory parameter.

.PARAMETER groupId
The ID of the group. This is a mandatory parameter.

.PARAMETER reportname
The name of the report. This is a mandatory parameter.

.PARAMETER token
The access token. This is a mandatory parameter.

.PARAMETER ImpersonatedUser
The name of the impersonated user. This is an optional parameter.

.PARAMETER authToken
The authentication token. This is an optional parameter.

.EXAMPLE
Get-FabricUsageMetricsQuery -DatasetID "your-dataset-id" -groupId "your-group-id" -reportname "your-report-name" -token "your-token"

This example retrieves the usage metrics for a specific dataset given the dataset ID, group ID, report name, and token.

.NOTES
The function defines the headers and body for a POST request to the PowerBI API to retrieve the usage metrics for the specified dataset. It then makes the POST request and returns the response.

Author: Ioana Bouariu

    #>

    # This function retrieves usage metrics for a specific dataset.

    # Define parameters for the dataset ID, group ID, report name, token, and impersonated user.
    param (
        [Parameter(Mandatory = $true)]
        [guid]$DatasetID,
        [Parameter(Mandatory = $true)]
        [guid]$groupId,
        [Parameter(Mandatory = $true)]
        $reportName,
        [Parameter(Mandatory = $false)]
        [string]$ImpersonatedUser = ""
    )

    # Confirm the authentication token.
    Confirm-TokenState

    # Define the body of the POST request.
    if ($ImpersonatedUser -ne "") {
        $reportBody = '{
      "queries": [
        {
          "query": "EVALUATE VALUES(' + $reportName + ')"
        }
      ],
      "serializerSettings": {
        "includeNulls": true
      },
      "impersonatedUserName": "' + $ImpersonatedUser + '"
    }'
    } else {
        $reportBody = '{
      "queries": [
        {
          "query": "EVALUATE VALUES(' + $reportName + ')"
        }
      ],
      "serializerSettings": {
        "includeNulls": true
      }
    }'
    }
    # Make a POST request to the PowerBI API to retrieve the usage metrics for the specified dataset.
    # The function returns the response of the POST request.
    Invoke-FabricRestMethod -Method POST -PowerBIApi -Uri "groups/$groupId/datasets/$DatasetID/executeQueries" -Body $reportBody

}
