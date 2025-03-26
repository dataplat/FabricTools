function Test-FabricApiResponse {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory = $true)]
      $statusCode,
      [Parameter(Mandatory = $false)]
      $response,
      [Parameter(Mandatory = $false)]
      $responseHeader,
      [Parameter(Mandatory = $false)]
      $Name,
      [Parameter(Mandatory = $false)]
      $typeName = 'Fabric Item'
  )

  switch ($statusCode) {
    201 {
        Write-Message -Message "$typeName '$Name' created successfully!" -Level Info
        return $response
    }
    202 {
        Write-Message -Message "$typeName '$Name' creation accepted. Provisioning in progress!" -Level Info
       
        [string]$operationId = $responseHeader["x-ms-operation-id"]
        Write-Message -Message "Operation ID: '$operationId'" -Level Debug
        Write-Message -Message "Getting Long Running Operation status" -Level Debug
       
        $operationStatus = Get-FabricLongRunningOperation -operationId $operationId
        Write-Message -Message "Long Running Operation status: $operationStatus" -Level Debug
        # Handle operation result
        if ($operationStatus.status -eq "Succeeded") {
            Write-Message -Message "Operation Succeeded" -Level Debug
            Write-Message -Message "Getting Long Running Operation result" -Level Debug
        
            $operationResult = Get-FabricLongRunningOperationResult -operationId $operationId
            Write-Message -Message "Long Running Operation status: $operationResult" -Level Debug
        
            return $operationResult
        }
        else {
            Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Debug
            Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Error
            return $operationStatus
        } 
    }
    default {
        Write-Message -Message "Unexpected response code: $statusCode" -Level Error
        Write-Message -Message "Error details: $($response.message)" -Level Error
        throw "API request failed with status code $statusCode."
    }
  }

}
