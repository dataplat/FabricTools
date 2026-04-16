function New-FabricSparkCustomPool
{
    <#
    .SYNOPSIS
        Creates a new Spark custom pool in a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function sends a POST request to the Microsoft Fabric API to create a new Spark custom pool
        in the specified workspace. It supports various parameters for Spark custom pool configuration.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the Spark custom pool will be created. This parameter is mandatory.

    .PARAMETER SparkCustomPoolName
        The name of the Spark custom pool to be created. This parameter is mandatory.

    .PARAMETER NodeFamily
        The family of nodes to be used in the Spark custom pool. This parameter is mandatory and must be 'MemoryOptimized'.

    .PARAMETER NodeSize
        The size of the nodes to be used in the Spark custom pool. This parameter is mandatory and must be one of 'Large', 'Medium', 'Small', 'XLarge', 'XXLarge'.

    .PARAMETER AutoScaleEnabled
        Specifies whether auto-scaling is enabled for the Spark custom pool. This parameter is mandatory.

    .PARAMETER AutoScaleMinNodeCount
        The minimum number of nodes for auto-scaling in the Spark custom pool. This parameter is mandatory.

    .PARAMETER AutoScaleMaxNodeCount
        The maximum number of nodes for auto-scaling in the Spark custom pool. This parameter is mandatory.

    .PARAMETER DynamicExecutorAllocationEnabled
        Specifies whether dynamic executor allocation is enabled for the Spark custom pool. This parameter is mandatory.

    .PARAMETER DynamicExecutorAllocationMinExecutors
        The minimum number of executors for dynamic executor allocation in the Spark custom pool. This parameter is mandatory.

    .PARAMETER DynamicExecutorAllocationMaxExecutors
        The maximum number of executors for dynamic executor allocation in the Spark custom pool. This parameter is mandatory.

    .EXAMPLE
        This example creates a new Spark custom pool named "New Spark Pool" in the workspace with ID "workspace-12345" with the specified configuration.

        ```powershell
        New-FabricSparkCustomPool -WorkspaceId "workspace-12345" -SparkCustomPoolName "New Spark Pool" -NodeFamily "MemoryOptimized" -NodeSize "Large" -AutoScaleEnabled $true -AutoScaleMinNodeCount 1 -AutoScaleMaxNodeCount 10 -DynamicExecutorAllocationEnabled $true -DynamicExecutorAllocationMinExecutors 1 -DynamicExecutorAllocationMaxExecutors 10
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SparkCustomPoolName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('MemoryOptimized')]
        [string]$NodeFamily,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Large', 'Medium', 'Small', 'XLarge', 'XXLarge')]
        [string]$NodeSize,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [bool]$AutoScaleEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$AutoScaleMinNodeCount,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$AutoScaleMaxNodeCount,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [bool]$DynamicExecutorAllocationEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$DynamicExecutorAllocationMinExecutors,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$DynamicExecutorAllocationMaxExecutors
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/spark/pools" -f $WorkspaceId

        # Construct the request body
        $body = @{
            name                      = $SparkCustomPoolName
            nodeFamily                = $NodeFamily
            nodeSize                  = $NodeSize
            autoScale                 = @{
                enabled      = $AutoScaleEnabled
                minNodeCount = $AutoScaleMinNodeCount
                maxNodeCount = $AutoScaleMaxNodeCount
            }
            dynamicExecutorAllocation = @{
                enabled      = $DynamicExecutorAllocationEnabled
                minExecutors = $DynamicExecutorAllocationMinExecutors
                maxExecutors = $DynamicExecutorAllocationMaxExecutors
            }
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Create Spark Custom Pool"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
                TypeName       = 'SparkCustomPool'
                ObjectIdOrName = $SparkCustomPoolName
            }
            $response = Invoke-FabricRestMethod @apiParams
        }

        return $response
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create SparkCustomPool. Error: $errorDetails" -Level Error
    }
}
