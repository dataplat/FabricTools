function Start-FabricSparkJobDefinitionOnDemand
{
    <#
    .SYNOPSIS
        Starts a Fabric Spark Job Definition on demand.

    .DESCRIPTION
        This function initiates a Spark Job Definition on demand within a specified workspace.
        It constructs the appropriate API endpoint URL and makes a POST request to start the job.
        The function can optionally wait for the job to complete based on the 'waitForCompletion' parameter.

    .PARAMETER WorkspaceId
        The ID of the workspace where the Spark Job Definition is located. This parameter is mandatory.

    .PARAMETER SparkJobDefinitionId
        The ID of the Spark Job Definition to be started. This parameter is mandatory.

    .PARAMETER JobType
        The type of job to be started. The default value is 'sparkjob'. This parameter is optional.

    .PARAMETER waitForCompletion
        A boolean flag indicating whether to wait for the job to complete. The default value is $false. This parameter is optional.

    .EXAMPLE
        ```powershell
        Start-FabricSparkJobDefinitionOnDemand -WorkspaceId "workspace123" -SparkJobDefinitionId "jobdef456" -waitForCompletion $true
        ```

    .NOTES
        Ensure that the necessary authentication tokens are valid before running this function.
        The function logs detailed messages for debugging and informational purposes.

    Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$SparkJobDefinitionId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('sparkjob')]
        [string]$JobType = "sparkjob",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$waitForCompletion = $false
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/SparkJobDefinitions/$SparkJobDefinitionId/jobs/instances?jobType=$JobType"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Start Spark Job Definition on demand")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                HandleResponse = $true
                NoWait         = (-not $waitForCompletion)
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Spark Job Definition on demand successfully initiated for SparkJobDefinition." -Level Info
            return $response
        }
        }
        catch {
            # Handle and log errors
            $errorDetails = $_.Exception.Message
            Write-Message -Message "Failed to start Spark Job Definition on demand. Error: $errorDetails" -Level Error
        }
    }
