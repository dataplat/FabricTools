function Update-FabricSparkSettings
{
    <#
    .SYNOPSIS
        Updates Spark settings in a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function sends a PATCH request to the Microsoft Fabric API to update Spark settings
        in the specified workspace. It supports optional parameters for automatic logging, high concurrency,
        pool configuration, environment, and starter pool settings.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace whose Spark settings will be updated. This parameter is mandatory.

    .PARAMETER automaticLogEnabled
        Specifies whether automatic logging is enabled. This parameter is optional.

    .PARAMETER notebookInteractiveRunEnabled
        Specifies whether notebook interactive run (high concurrency) is enabled. This parameter is optional.

    .PARAMETER customizeComputeEnabled
        Specifies whether compute customization is enabled for the pool. This parameter is optional.

    .PARAMETER defaultPoolName
        The name of the default pool. Must be provided together with defaultPoolType. This parameter is optional.

    .PARAMETER defaultPoolType
        The type of the default pool. Must be 'Workspace' or 'Capacity'. Must be provided together with defaultPoolName. This parameter is optional.

    .PARAMETER starterPoolMaxNode
        The maximum number of nodes for the starter pool. This parameter is optional.

    .PARAMETER starterPoolMaxExecutors
        The maximum number of executors for the starter pool. This parameter is optional.

    .PARAMETER EnvironmentName
        The name of the environment. This parameter is optional.

    .PARAMETER EnvironmentRuntimeVersion
        The runtime version of the environment. This parameter is optional.

    .EXAMPLE
        This example enables automatic logging for the workspace with ID "workspace-12345".

        ```powershell
        Update-FabricSparkSettings -WorkspaceId "workspace-12345" -automaticLogEnabled $true
        ```

    .EXAMPLE
        This example sets the default pool for the workspace with ID "workspace-12345".

        ```powershell
        Update-FabricSparkSettings -WorkspaceId "workspace-12345" -defaultPoolName "MyPool" -defaultPoolType "Workspace"
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


        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$automaticLogEnabled,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$notebookInteractiveRunEnabled,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$customizeComputeEnabled,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$defaultPoolName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Workspace', 'Capacity')]
        [string]$defaultPoolType,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]$starterPoolMaxNode,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]$starterPoolMaxExecutors,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EnvironmentName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EnvironmentRuntimeVersion
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/spark/settings" -f $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{ }

        if ($PSBoundParameters.ContainsKey('automaticLogEnabled'))
        {
            $body.automaticLog = @{
                enabled = $automaticLogEnabled
            }
        }

        if ($PSBoundParameters.ContainsKey('notebookInteractiveRunEnabled'))
        {
            $body.highConcurrency = @{
                notebookInteractiveRunEnabled = $notebookInteractiveRunEnabled
            }
        }

        if ($PSBoundParameters.ContainsKey('customizeComputeEnabled') )
        {
            $body.pool = @{
                customizeComputeEnabled = $customizeComputeEnabled
            }
        }
        if ($PSBoundParameters.ContainsKey('defaultPoolName') -or $PSBoundParameters.ContainsKey('defaultPoolType'))
        {
            if ($PSBoundParameters.ContainsKey('defaultPoolName') -and $PSBoundParameters.ContainsKey('defaultPoolType'))
            {
                $body.pool = @{
                    defaultPool = @{
                        name = $defaultPoolName
                        type = $defaultPoolType
                    }
                }
            }
            else
            {
                Write-Message -Message "Both 'defaultPoolName' and 'defaultPoolType' must be provided together." -Level Error
                throw
            }
        }

        if ($PSBoundParameters.ContainsKey('EnvironmentName') -or $PSBoundParameters.ContainsKey('EnvironmentRuntimeVersion'))
        {
            $body.environment = @{
                name = $EnvironmentName
            }
        }
        if ($PSBoundParameters.ContainsKey('EnvironmentRuntimeVersion'))
        {
            $body.environment = @{
                runtimeVersion = $EnvironmentRuntimeVersion
            }
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Update SparkSettings"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Patch'
                Body           = $bodyJson
                HandleResponse = $true
                TypeName       = 'SparkSettings'
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Spark Settings updated successfully!" -Level Info
        }

        return $response
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update SparkSettings. Error: $errorDetails" -Level Error
    }
}
