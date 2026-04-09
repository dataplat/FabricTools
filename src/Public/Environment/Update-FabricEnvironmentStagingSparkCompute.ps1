function Update-FabricEnvironmentStagingSparkCompute
{
<#
.SYNOPSIS
Updates the Spark compute configuration in the staging environment for a given workspace.

.DESCRIPTION
This function sends a PATCH request to the Microsoft Fabric API to update the Spark compute settings
for a specified environment, including instance pool, driver and executor configurations, and dynamic allocation settings.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the environment exists.

.PARAMETER EnvironmentId
The unique identifier of the environment where the Spark compute settings will be updated.

.PARAMETER InstancePoolName
The name of the instance pool to be used for Spark compute.

.PARAMETER InstancePoolType
The type of instance pool (either 'Workspace' or 'Capacity').

.PARAMETER DriverCores
The number of cores to allocate to the driver.

.PARAMETER DriverMemory
The amount of memory to allocate to the driver.

.PARAMETER ExecutorCores
The number of cores to allocate to each executor.

.PARAMETER ExecutorMemory
The amount of memory to allocate to each executor.

.PARAMETER DynamicExecutorAllocationEnabled
Boolean flag to enable or disable dynamic executor allocation.

.PARAMETER DynamicExecutorAllocationMinExecutors
The minimum number of executors when dynamic allocation is enabled.

.PARAMETER DynamicExecutorAllocationMaxExecutors
The maximum number of executors when dynamic allocation is enabled.

.PARAMETER RuntimeVersion
The Spark runtime version to use.

.PARAMETER SparkProperties
A hashtable of additional Spark properties to configure.

.EXAMPLE
    ```powershell
    Update-FabricEnvironmentStagingSparkCompute -WorkspaceId "workspace-12345" -EnvironmentId "env-67890" -InstancePoolName "pool1" -InstancePoolType "Workspace" -DriverCores 4 -DriverMemory "16GB" -ExecutorCores 8 -ExecutorMemory "32GB" -DynamicExecutorAllocationEnabled $true -DynamicExecutorAllocationMinExecutors 2 -DynamicExecutorAllocationMaxExecutors 10 -RuntimeVersion "3.1" -SparkProperties @{ "spark.executor.memoryOverhead"="4GB" }
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
        [guid]$EnvironmentId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InstancePoolName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Workspace', 'Capacity')]
        [string]$InstancePoolType,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$DriverCores,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DriverMemory,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$ExecutorCores,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ExecutorMemory,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [bool]$DynamicExecutorAllocationEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$DynamicExecutorAllocationMinExecutors,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$DynamicExecutorAllocationMaxExecutors,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$RuntimeVersion,

        [Parameter(Mandatory = $true)]
        [System.Object]$SparkProperties
    )

    # Ensure token validity
    Confirm-TokenState

    $body = @{
        instancePool              = @{
            name = $InstancePoolName
            type = $InstancePoolType
        }
        driverCores               = $DriverCores
        driverMemory              = $DriverMemory
        executorCores             = $ExecutorCores
        executorMemory            = $ExecutorMemory
        dynamicExecutorAllocation = @{
            enabled      = $DynamicExecutorAllocationEnabled
            minExecutors = $DynamicExecutorAllocationMinExecutors
            maxExecutors = $DynamicExecutorAllocationMaxExecutors
        }
        runtimeVersion            = $RuntimeVersion
        sparkProperties           = $SparkProperties
    }

    $bodyJson = $body | ConvertTo-Json -Depth 4
    Write-Message -Message "Request Body: $bodyJson" -Level Debug

    if ($PSCmdlet.ShouldProcess($EnvironmentId, "Update Environment Staging Spark Compute"))
    {
        $apiParams = @{
            Uri            = "workspaces/$WorkspaceId/environments/$EnvironmentId/staging/sparkcompute"
            Method         = 'Patch'
            Body           = $bodyJson
            TypeName       = 'Environment'
            ObjectIdOrName = $EnvironmentId
            HandleResponse = $true
        }

        $response = Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Environment staging Spark compute updated successfully!" -Level Info
        $response
    }
}
