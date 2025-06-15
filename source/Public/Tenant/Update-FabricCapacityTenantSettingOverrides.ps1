<#
.SYNOPSIS
Updates tenant setting overrides for a specified capacity ID.

.DESCRIPTION
The `Update-FabricCapacityTenantSettingOverrides` function updates tenant setting overrides in a Fabric environment by making a POST request to the appropriate API endpoint. It allows specifying settings such as enabling tenant settings, delegating to a workspace, and including or excluding security groups.

.PARAMETER CapacityId
(Mandatory) The ID of the capacity for which the tenant setting overrides are being updated.

.PARAMETER SettingTitle
(Mandatory) The title of the tenant setting to be updated.

.PARAMETER EnableTenantSetting
(Mandatory) Indicates whether the tenant setting should be enabled.

.PARAMETER DelegateToWorkspace
(Optional) Specifies the workspace to which the setting should be delegated.

.PARAMETER EnabledSecurityGroups
(Optional) A JSON array of security groups to be enabled, each containing `graphId` and `name` properties.

.PARAMETER ExcludedSecurityGroups
(Optional) A JSON array of security groups to be excluded, each containing `graphId` and `name` properties.

.EXAMPLE
Update-FabricCapacityTenantSettingOverrides -CapacityId "12345" -SettingTitle "SomeSetting" -EnableTenantSetting "true"

Updates the tenant setting "SomeSetting" for the capacity with ID "12345" and enables it.

.EXAMPLE
Update-FabricCapacityTenantSettingOverrides -CapacityId "12345" -SettingTitle "SomeSetting" -EnableTenantSetting "true" -EnabledSecurityGroups @(@{graphId="1";name="Group1"},@{graphId="2";name="Group2"})

Updates the tenant setting "SomeSetting" for the capacity with ID "12345", enables it, and specifies security groups to include.

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

#>

function Update-FabricCapacityTenantSettingOverrides
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$CapacityId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SettingTitle,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [bool]$EnableTenantSetting,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$DelegateToWorkspace,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Object]$EnabledSecurityGroups,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Object]$ExcludedSecurityGroups
    )

    try
    {
        # Validate authentication token
        Confirm-TokenState

        # Validate Security Groups if provided
        if ($EnabledSecurityGroups)
        {
            foreach ($enabledGroup in $EnabledSecurityGroups)
            {
                if (-not ($enabledGroup.PSObject.Properties.Name -contains 'graphId' -and $enabledGroup.PSObject.Properties.Name -contains 'name'))
                {
                    throw "Each enabled security group must contain 'graphId' and 'name' properties."
                }
            }
        }

        if ($ExcludedSecurityGroups)
        {
            foreach ($excludedGroup in $ExcludedSecurityGroups)
            {
                if (-not ($excludedGroup.PSObject.Properties.Name -contains 'graphId' -and $excludedGroup.PSObject.Properties.Name -contains 'name'))
                {
                    throw "Each excluded security group must contain 'graphId' and 'name' properties."
                }
            }
        }

        # Construct API endpoint URL
        $apiEndpointURI = "admin/capacities/{0}/delegatedTenantSettingOverrides" -f $CapacityId

        # Construct request body
        $body = @{
            EnableTenantSetting = $EnableTenantSetting
            SettingTitle        = $SettingTitle
        }

        if ($DelegateToWorkspace)
        {
            $body.delegateToWorkspace = $DelegateToWorkspace
        }

        if ($EnabledSecurityGroups)
        {
            $body.enabledSecurityGroups = $EnabledSecurityGroups
        }

        if ($ExcludedSecurityGroups)
        {
            $body.excludedSecurityGroups = $ExcludedSecurityGroups
        }

        # Convert body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 4
        Write-Message -Message "Request Body: $bodyJson" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointURI, "Update Tenant Setting Overrides")){
            # Invoke Fabric API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointURI `
                -method Post `
                -body $bodyJson
        }

        Write-Message -Message "Successfully updated capacity tenant setting overrides for CapacityId: $CapacityId and SettingTitle: $SettingTitle." -Level Info
        return $response
    }
    catch
    {
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error updating tenant settings: $errorDetails" -Level Error
    }
}
