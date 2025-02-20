<#
.SYNOPSIS
Retrieves usage metrics for a specific dataset.

.DESCRIPTION
The Get-FabricUsageMetricsQuery function retrieves usage metrics for a specific dataset. It supports multiple aliases for flexibility.

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
#>

# This function retrieves usage metrics for a specific dataset.
function Get-FabricUsageMetricsQuery {
  # Define aliases for the function for flexibility.
  [Alias("Get-FabUsageMetricsQuery")]

  # Define parameters for the dataset ID, group ID, report name, token, and impersonated user.
  param (
    [Parameter(Mandatory = $true)]
    [string]$DatasetID,
    [Parameter(Mandatory = $true)]
    [string]$groupId,
    [Parameter(Mandatory = $true)]
    $reportname,
    [Parameter(Mandatory = $false)]
    [string]$ImpersonatedUser = "",
    [Parameter(Mandatory = $false)]
    [string]$authToken
  )

  if ([string]::IsNullOrEmpty($authToken)) {
    $authToken = Get-FabricAuthToken
  }

  $fabricHeaders = @{
    "Content-Type"  = "application/json"
    'Authorization' = "Bearer {0}" -f $authToken
  }

  # Define the body of the POST request.
  if ($ImpersonatedUser -ne "") {
    $reportbody = '{
      "queries": [
        {
          "query": "EVALUATE VALUES(' + $reportname + ')"
        }
      ],
      "serializerSettings": {
        "includeNulls": true
      },
      "impersonatedUserName": "'+ $ImpersonatedUser + '"
    }'
  }
  else {
    $reportbody = '{
      "queries": [
        {
          "query": "EVALUATE VALUES(' + $reportname + ')"
        }
      ],
      "serializerSettings": {
        "includeNulls": true
      }
    }'
  }
  # Make a POST request to the PowerBI API to retrieve the usage metrics for the specified dataset.
  # The function returns the response of the POST request.
  return Invoke-RestMethod -uri "https://api.powerbi.com/v1.0/myorg/groups/$groupId/datasets/$DatasetID/executeQueries" -Headers $fabricHeaders -Body $reportbody -Method Post
}