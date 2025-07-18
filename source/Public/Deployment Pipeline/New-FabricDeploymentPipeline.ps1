<#
.SYNOPSIS
Creates a new deployment pipeline.

.DESCRIPTION
The `New-FabricDeploymentPipeline` function creates a new deployment pipeline with specified stages.
Each stage can be configured with a display name, description, and public/private visibility setting.

.PARAMETER DisplayName
Required. The display name for the deployment pipeline. Maximum length is 256 characters.

.PARAMETER Description
Optional. The description for the deployment pipeline. Maximum length is 1024 characters.

.PARAMETER Stages
Required. An array of hashtables containing stage configurations. Each stage should have:
- DisplayName (string, max 256 chars)
- Description (string, max 1024 chars)
- IsPublic (boolean)

.EXAMPLE
$stages = @(
    @{
        DisplayName = "Development"
        Description = "Development stage description"
        IsPublic = $false
    },
    @{
        DisplayName = "Test"
        Description = "Test stage description"
        IsPublic = $false
    },
    @{
        DisplayName = "Production"
        Description = "Production stage description"
        IsPublic = $true
    }
)

New-FabricDeploymentPipeline -DisplayName "My Deployment Pipeline" -Description "My pipeline description" -Stages $stages

Creates a new deployment pipeline with three stages: Development, Test, and Production.

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Requires Pipeline.ReadWrite.All delegated scope.
- Service Principals must have permission granted by Fabric administrator.
- Returns the created deployment pipeline object with assigned IDs for the pipeline and its stages.

Author: Kamil Nowinski
#>

function New-FabricDeploymentPipeline {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 256)]
        [string]$DisplayName,

        [Parameter(Mandatory = $false)]
        [ValidateLength(0, 1024)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [array]$Stages
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Validate stages
        foreach ($stage in $Stages) {
            if (-not $stage.ContainsKey('DisplayName') -or
                -not $stage.ContainsKey('IsPublic') -or
                $stage.DisplayName.Length -gt 256 -or
                ($stage.ContainsKey('Description') -and $stage.Description.Length -gt 1024)) {
                throw "Invalid stage configuration. Each stage must have DisplayName (max 256 chars), IsPublic, and optional Description (max 1024 chars)."
            }
        }

        # Step 3: Construct the request body
        $requestBody = @{
            displayName = $DisplayName
            stages = $Stages
        }
        if ($Description) {
            $requestBody.description = $Description
        }

        # Step 4: Make the API request and Validate response
        if ($PSCmdlet.ShouldProcess("Create new Deployment Pipeline")) {
            $apiParameters = @{
                Uri = "deploymentPipelines"
                Method = "Post"
                Body = $requestBody
                HandleResponse = $true
                TypeName = "deployment pipeline"
            }
            $response = Invoke-FabricRestMethod @apiParameters
        }

        # Step 5: Handle results
        $response

    } catch {
        # Step 6: Error handling
        $errorDetails = $_.Exception.Message
        Write-Error -Message "Failed to create deployment pipeline. Error: $errorDetails"
    }
}
