function Write-Log {
<#
.SYNOPSIS
    Write a log message to the console with color coding based on the log level.

.DESCRIPTION
    This function writes a log message to the console with color coding based on the log level. It supports different log levels such as INFO, WARN, ERROR, and DEBUG. The function also has an option to stop execution if an error occurs.

.PARAMETER Message
    The log message to be written to the console.

.PARAMETER Level
    The log level for the message. Default is INFO. Other options are WARN, ERROR, and DEBUG.

.PARAMETER Stop
    A boolean value indicating whether to stop execution if an error occurs. Default is true.

.EXAMPLE
    Write-Log -Message "This is an info message." -Level "INFO"
    Write-Log -Message "This is a warning message." -Level "WARN"
    Write-Log -Message "This is an error message." -Level "ERROR" -Stop $true
    Write-Log -Message "This is a debug message." -Level "DEBUG" -Stop $false
#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$Message,

      [Parameter(Mandatory = $false)]
      [string]$Level = 'INFO',

      [Parameter(Mandatory = $false)]
      [bool]$Stop = $true
    )

    $color = switch ($Level) {
      'INFO' { 'Green' }
      'WARN' { 'Yellow' }
      'ERROR' { 'Red' }
      'DEBUG' { 'DarkMagenta' }
      default { 'Green' }
    }

    $prefix = switch ($Level) {
      'INFO' { '*' }
      'WARN' { '!' }
      'ERROR' { 'X' }
      'DEBUG' { 'D' }
      default { '*' }
    }

    Write-Host -ForegroundColor $color "[$prefix] $Message"

    if ($Stop -and $Level -eq 'ERROR') {
      exit 1
    }
}

function Install-ModuleIfNotInstalled {
<#
.SYNOPSIS
    Installs a PowerShell module if it is not already installed.
.DESCRIPTION
    This function checks if a specified PowerShell module is installed. If the module is not found, it attempts to install it from the PSGallery repository. The function handles errors during installation and logs messages accordingly.
.PARAMETER ModuleName
    The name of the PowerShell module to be installed.
.EXAMPLE
    Install-ModuleIfNotInstalled -ModuleName "Az.Accounts"
    This example installs the Az.Accounts module if it is not already installed.

#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$ModuleName
    )

    if (-not (Get-Module -Name $ModuleName -ListAvailable)) {
      try {
        Write-Log -Message "Installing module: $ModuleName" -Level 'DEBUG'
        Install-Module -Name $ModuleName -AllowClobber -Force -Scope CurrentUser -Repository PSGallery -Confirm:$false -SkipPublisherCheck -AcceptLicense
      }
      catch {
        Write-Error $_.Exception.Message
        Write-Log -Message "Unable to install module: $ModuleName" -Level 'ERROR'
      }
    }
}

function Import-ModuleIfNotImported {
<#
.SYNOPSIS

    Imports a PowerShell module if it is not already imported.
.DESCRIPTION
    This function checks if a specified PowerShell module is already imported. If the module is not found, it attempts to import it. The function handles errors during import and logs messages accordingly.
.PARAMETER ModuleName
    The name of the PowerShell module to be imported.
.EXAMPLE
    Import-ModuleIfNotImported -ModuleName "Az.Accounts"
    This example imports the Az.Accounts module if it is not already imported.
#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$ModuleName
    )

    if (-not (Get-Module -Name $ModuleName)) {
      try {
        Write-Log -Message "Importing module: $ModuleName" -Level 'DEBUG'
        Import-Module -Name $ModuleName
      }
      catch {
        Write-Error $_.Exception.Message
        Write-Log -Message "Unable to import module: $ModuleName" -Level 'ERROR'
      }
    }
}

function Invoke-FabricRest {
<#
.SYNOPSIS
    Invokes a REST API call to the Fabric API with retry logic.
.DESCRIPTION
    This function invokes a REST API call to the Fabric API with retry logic. It handles throttling and long-running operations. The function retrieves the Fabric access token and constructs the request URI based on the provided endpoint. It supports GET, POST, PUT, and DELETE methods.
.PARAMETER Method
    The HTTP method to use for the request. Default is GET. Other options are POST, PUT, and DELETE.
.PARAMETER Endpoint
    The API endpoint to call. This is a required parameter.
.PARAMETER Payload
    The payload to send with the request. This is an optional parameter.
.PARAMETER RetryCount
    The number of retry attempts in case of throttling. Default is 3.
.PARAMETER RetryDelaySeconds
    The delay in seconds between retry attempts. Default is 30 seconds.
.EXAMPLE
    Invoke-FabricRest -Method 'GET' -Endpoint 'workspaces'
    This example retrieves a list of workspaces from the Fabric API.
.EXAMPLE
    Invoke-FabricRest -Method 'POST' -Endpoint 'workspaces' -Payload @{ displayName = 'MyWorkspace' }
    This example creates a new workspace in the Fabric API with the specified display name.
#>

    param (
      [Parameter(Mandatory = $false)]
      [string]$Method = 'GET',

      [Parameter(Mandatory = $true)]
      [string]$Endpoint,

      [Parameter(Mandatory = $false)]
      [object]$Payload,

      [Parameter(Mandatory = $false)]
      [int]$RetryCount = 3,

      [Parameter(Mandatory = $false)]
      [int]$RetryDelaySeconds = 30
    )

    try {
      # Retrieve the Fabric access token
      try {
        $secureAccessToken = (Get-AzAccessToken -WarningAction SilentlyContinue -AsSecureString -ResourceUrl 'https://api.fabric.microsoft.com').Token
      }
      catch {
        Write-Log -Message "Failed to retrieve access token." -Level 'ERROR'
      }

      $uri = "https://api.fabric.microsoft.com/v1/$Endpoint"
      $attempt = 0
      $response = $null
      $responseHeaders = $null
      $statusCode = $null

      while ($attempt -lt $RetryCount) {
        try {
          if ($Payload) {
            $body = $Payload | ConvertTo-Json -Depth 10 -Compress
            $response = Invoke-RestMethod -Authentication Bearer -Token $secureAccessToken -Uri $uri -Method $Method -ContentType 'application/json' -Body $body -ResponseHeadersVariable responseHeaders -StatusCodeVariable statusCode
          }
          else {
            $response = Invoke-RestMethod -Authentication Bearer -Token $secureAccessToken -Uri $uri -Method $Method -ResponseHeadersVariable responseHeaders -StatusCodeVariable statusCode
          }

          break
        }
        catch {
          $statusCode = $_.Exception.Response.StatusCode.value__

          if ($statusCode -eq 429) {
            $retryAfter = $_.Exception.Response.Headers.RetryAfter.Delta.TotalSeconds

            $retryDelaySeconds = $RetryDelaySeconds
            if ($retryAfter) {
              $retryDelaySeconds = $retryAfter
            }

            Write-Log -Message "Throttled. Waiting for $retryDelaySeconds seconds before retrying..." -Level 'DEBUG'
            Start-Sleep -Seconds $retryDelaySeconds

            $attempt++
          }
          else {
            throw $_
          }
        }
      }

      if ($attempt -ge $RetryCount) {
        Write-Log -Message "Maximum retry attempts reached. Request failed." -Level 'ERROR'
      }

      if ($statusCode -eq 200 -or $statusCode -eq 201) {
        return [PSCustomObject]@{
          Response = $response
          Headers  = $responseHeaders
        }
      }

      if ($statusCode -eq 202 -and $responseHeaders.Location -and $responseHeaders['x-ms-operation-id']) {
        $operationId = [string]$responseHeaders['x-ms-operation-id']
        Write-Log -Message "Long Running Operation initiated. Operation ID: $operationId" -Level 'DEBUG'
        $result = Get-LroResult -OperationId $operationId

        return [PSCustomObject]@{
          Response = $result.Response
          Headers  = $result.Headers
        }
      }
    }
    catch {
      Write-Log -Message $_.Exception.Message -Level 'ERROR'
    }
}

function Get-LroResult {
<#
.SYNOPSIS
    Retrieves the result of a long-running operation using the operation ID.

.DESCRIPTION
    This function retrieves the result of a long-running operation using the operation ID. It checks the status of the operation and waits for it to complete. If the operation fails, it logs an error message.

.PARAMETER OperationId
    The ID of the long-running operation to retrieve the result for.

.EXAMPLE
    Get-LroResult -OperationId '12345678-1234-1234-1234-123456789012'
    This example retrieves the result of a long-running operation using the specified operation ID.
#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$OperationId
    )

    $operationStatus = $null
    while ($operationStatus -ne 'Succeeded') {
      $result = Invoke-FabricRest -Method 'GET' -Endpoint "operations/$OperationId"

      $operationStatus = $result.Response.status

      if ($operationStatus -eq 'Failed') {
        Write-Log -Message "Operation failed. Status: $operationStatus" -Level 'ERROR'
      }

      if ($operationStatus -ne "Succeeded") {
        $retryAfter = [int]$result.Headers['Retry-After'][0]
        Start-Sleep -Seconds $retryAfter
      }
    }

    return Invoke-FabricRest -Method 'GET' -Endpoint "operations/$OperationId/result"
}

function Set-FabricItem {
<#
.SYNOPSIS
    Creates or retrieves a Fabric item (e.g., DataPipeline, Environment, Eventhouse, etc.) in a specified workspace.
.DESCRIPTION
    This function creates or retrieves a Fabric item (e.g., DataPipeline, Environment, Eventhouse, etc.) in a specified workspace. It checks if the item already exists and creates it if it doesn't. The function also validates the input parameters and handles errors.

.PARAMETER DisplayName
    The display name of the item to be created or retrieved.

.PARAMETER WorkspaceId
    The ID of the workspace where the item will be created or retrieved.

.PARAMETER Type
    The type of the item to be created or retrieved. Valid options are DataPipeline, Environment, Eventhouse, Eventstream, GraphQLApi, KQLDashboard, KQLDatabase, KQLQueryset, Lakehouse, MirroredDatabase, MLExperiment, MLModel, Notebook, Reflex, Report, SemanticModel, SparkJobDefinition, SQLDatabase, Warehouse.

.PARAMETER CreationPayload
    The payload to be used for creating the item. This is an optional parameter.

.PARAMETER Definition
    The definition to be used for creating the item. This is an optional parameter.

.EXAMPLE
    Set-FabricItem -DisplayName 'MyDataPipeline' -WorkspaceId '12345678-1234-1234-1234-123456789012' -Type 'DataPipeline'
    This example creates or retrieves a DataPipeline item with the specified display name in the specified workspace.

.EXAMPLE
    Set-FabricItem -DisplayName 'MyEnvironment' -WorkspaceId '12345678-1234-1234-1234-123456789012' -Type 'Environment' -CreationPayload @{}
    This example creates or retrieves an Environment item with the specified display name in the specified workspace using the provided creation payload.
#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$DisplayName,

      [Parameter(Mandatory = $true)]
      [string]$WorkspaceId,

      [Parameter(Mandatory = $true)]
      [string]$Type,

      [Parameter(Mandatory = $false)]
      [object]$CreationPayload,

      [Parameter(Mandatory = $false)]
      [object]$Definition
    )

    switch ($Type) {
      'DataPipeline' {
        $itemEndpoint = 'dataPipelines'
      }
      'Environment' {
        $itemEndpoint = 'environments'
      }
      'Eventhouse' {
        $itemEndpoint = 'eventhouses'
      }
      'Eventstream' {
        $itemEndpoint = 'eventstreams'
      }
      'GraphQLApi' {
        $itemEndpoint = 'GraphQLApis'
      }
      'KQLDashboard' {
        $itemEndpoint = 'kqlDashboards'
      }
      'KQLDatabase' {
        $itemEndpoint = 'kqlDatabases'
      }
      'KQLQueryset' {
        $itemEndpoint = 'kqlQuerysets'
      }
      'Lakehouse' {
        $itemEndpoint = 'lakehouses'
      }
      'MirroredDatabase' {
        $itemEndpoint = 'mirroredDatabases'
      }
      'MLExperiment' {
        $itemEndpoint = 'mlExperiments'
      }
      'MLModel' {
        $itemEndpoint = 'mlModels'
      }
      'Notebook' {
        $itemEndpoint = 'notebooks'
      }
      'Reflex' {
        $itemEndpoint = 'reflexes'
      }
      'Report' {
        $itemEndpoint = 'reports'
      }
      'SemanticModel' {
        $itemEndpoint = 'semanticModels'
      }
      'SparkJobDefinition' {
        $itemEndpoint = 'sparkJobDefinitions'
      }
      'SQLDatabase' {
        $itemEndpoint = 'sqlDatabases'
      }
      'Warehouse' {
        $itemEndpoint = 'warehouses'
      }
      default {
        $itemEndpoint = 'items'
      }
    }

    If ($CreationPayload -and $Definition) {
      Write-Log -Message 'Only one of CreationPayload or Definition is allowed at time.' -Level 'ERROR'
    }

    $definitionRequired = @('Report', 'SemanticModel', 'MirroredDatabase')
    if ($Type -in $definitionRequired -and !$Definition) {
      Write-Log -Message "Definition is required for Type: $Type" -Level 'ERROR'
    }

    $results = Invoke-FabricRest -Method 'GET' -Endpoint "workspaces/$WorkspaceId/$itemEndpoint"
    $result = $results.Response.value | Where-Object { $_.displayName -eq $DisplayName }
    if (!$result) {
      Write-Log -Message "Creating ${Type}: $DisplayName" -Level 'WARN'
      $payload = @{
        displayName = $DisplayName
        description = $DisplayName
      }

      if ($itemEndpoint -eq 'items') {
        $payload['type'] = $Type
      }

      if ($CreationPayload) {
        $payload['creationPayload'] = $CreationPayload
      }

      if ($Definition) {
        $payload['definition'] = $Definition
      }

      $result = (Invoke-FabricRest -Method 'POST' -Endpoint "workspaces/$WorkspaceId/$itemEndpoint" -Payload $payload).Response
    }

    Write-Log -Message "${Type} - Name: $($result.displayName) / ID: $($result.id)"

    return $result
}

function Get-DefinitionPartBase64 {
<#
.SYNOPSIS

    Converts a file to a Base64 string.
.DESCRIPTION
    Converts a file to a Base64 string. It reads the content of the file, replaces specified values, and encodes it in Base64 format.

.PARAMETER Path
    The path to the file to be converted.

.PARAMETER Values
    An object containing key-value pairs to replace in the file content.

.EXAMPLE
    Get-DefinitionPartBase64 -Path 'C:\path\to\file.txt' -Values @{ key = 'oldValue'; value = 'newValue' }
    This example converts the specified file to a Base64 string and replaces 'oldValue' with 'newValue' in the file content.
#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$Path,

      [Parameter(Mandatory = $false)]
      [object]$Values
    )

    if (-not (Test-Path -Path $Path)) {
      Write-Log -Message "File not found: $Path" -Level 'ERROR'
    }

    $content = (Get-Content -Path $Path -Raw).Trim().ToString()

    if ($Values) {
      foreach ($value in $Values) {
        $content = $content.Replace($value.key, $value.value)
      }
    }

    return [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($content))
}

function Set-FabricDomain {
<#
.SYNOPSIS
    Creates or retrieves a Fabric domain in a specified parent domain.
.DESCRIPTION
    This function creates or retrieves a Fabric domain in a specified parent domain. It checks if the domain already exists and creates it if it doesn't. The function also handles errors and logs messages accordingly.
.PARAMETER DisplayName
    The display name of the domain to be created or retrieved.
.PARAMETER ParentDomainId
    The ID of the parent domain for the domain. This is an optional parameter.
.EXAMPLE
    Set-FabricDomain -DisplayName 'MyDomain' -ParentDomainId '12345678-1234-1234-1234-123456789012'
    This example creates or retrieves a Fabric domain with the specified display name in the specified parent domain.

#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$DisplayName,

      [Parameter(Mandatory = $false)]
      [string]$ParentDomainId
    )

    $results = Invoke-FabricRest -Method 'GET' -Endpoint "admin/domains"
    $result = $results.Response.domains | Where-Object { $_.displayName -eq $DisplayName }
    if (!$result) {
      Write-Log -Message "Creating Domain: $DisplayName" -Level 'WARN'
      $payload = @{
        displayName = $DisplayName
        description = $DisplayName
      }

      if ($ParentDomainId) {
        $payload['parentDomainId'] = $ParentDomainId
      }

      $result = (Invoke-FabricRest -Method 'POST' -Endpoint "admin/domains" -Payload $payload).Response
    }

    if ($ParentDomainId) {
      Write-Log -Message "Child Domain - Name: $($result.displayName) / ID: $($result.id)"
    }
    else {
      Write-Log -Message "Parent Domain - Name: $($result.displayName) / ID: $($result.id)"
    }

    return $result
}

function Get-BaseName {
<#
.SYNOPSIS
    Generates a base name based on the provided length or environment variable.
.DESCRIPTION
    This function generates a base name based on the provided length or environment variable. If the environment variable FABRIC_TESTACC_WELLKNOWN_NAME_BASE is set, it uses that value. Otherwise, it generates a random string of the specified length.
.PARAMETER Length
    The length of the random string to be generated. Default is 10. This is an optional parameter.

.EXAMPLE
    Get-BaseName -Length 15
    This example generates a random string of length 15 if the environment variable FABRIC_TESTACC_WELLKNOWN_NAME_BASE is not set.

#>
    param (
      [Parameter(Mandatory = $false)]
      [int]$Length = 10
    )

    $base = $Env:FABRIC_TESTACC_WELLKNOWN_NAME_BASE

    if (!$base) {
      $base = -join ((65..90) + (97..122) | Get-Random -Count $Length | ForEach-Object { [char]$_ })
    }

    return $base
}

  function Get-DisplayName {
<#
.SYNOPSIS
    Generates a display name based on the provided base, prefix, suffix, and separator.
.DESCRIPTION
    This function generates a display name based on the provided base, prefix, suffix, and separator. It concatenates the prefix, base, and suffix with the specified separator. The function also retrieves the base name if not provided.
.PARAMETER Base
    The base name to be used in the display name. This is a required parameter.
.PARAMETER Prefix
    The prefix to be added to the base name. This is an optional parameter.
.PARAMETER Suffix
    The suffix to be added to the base name. This is an optional parameter.
.PARAMETER Separator
    The separator to be used between the prefix, base, and suffix. Default is '_'. This is an optional parameter.
.EXAMPLE
    Get-DisplayName -Base 'MyBaseName' -Prefix 'MyPrefix' -Suffix 'MySuffix' -Separator '-'
    This example generates a display name with the specified base, prefix, suffix, and separator.
#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$Base,

      [Parameter(Mandatory = $false)]
      [string]$Prefix = $Env:FABRIC_TESTACC_WELLKNOWN_NAME_PREFIX,

      [Parameter(Mandatory = $false)]
      [string]$Suffix = $Env:FABRIC_TESTACC_WELLKNOWN_NAME_SUFFIX,

      [Parameter(Mandatory = $false)]
      [string]$Separator = '_'
    )

    $result = $Base

    # add prefix and suffix
    if ($Prefix) {
      $result = "${Prefix}${Separator}${result}"
    }

    if ($Suffix) {
      $result = "${result}${Separator}${Suffix}"
    }

    return $result
  }

  function Set-FabricWorkspace {
<#
.SYNOPSIS
    Creates or retrieves a Fabric workspace in a specified capacity.
.DESCRIPTION
    This function creates or retrieves a Fabric workspace in a specified capacity. It checks if the workspace already exists and creates it if it doesn't. The function also handles errors and logs messages accordingly.
.PARAMETER DisplayName
    The display name of the workspace to be created or retrieved.
.PARAMETER CapacityId
    The ID of the capacity where the workspace will be created or retrieved.
.PARAMETER ParentDomainId
    The ID of the parent domain for the workspace. This is an optional parameter.
.EXAMPLE
    Set-FabricWorkspace -DisplayName 'MyWorkspace' -CapacityId '12345678-1234-1234-1234-123456789012'
    This example creates or retrieves a Fabric workspace with the specified display name in the specified capacity.

#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$DisplayName,

      [Parameter(Mandatory = $true)]
      [string]$CapacityId
    )

    $workspaces = Invoke-FabricRest -Method 'GET' -Endpoint 'workspaces'
    $workspace = $workspaces.Response.value | Where-Object { $_.displayName -eq $DisplayName }
    if (!$workspace) {
      Write-Log -Message "Creating Workspace: $DisplayName" -Level 'WARN'
      $payload = @{
        displayName = $DisplayName
        description = $DisplayName
        capacityId  = $CapacityId
      }
      $workspace = (Invoke-FabricRest -Method 'POST' -Endpoint 'workspaces' -Payload $payload).Response
    }

    return $workspace
  }

  function Set-FabricWorkspaceCapacity {
<#
.SYNOPSIS
    Assigns a Fabric workspace to a specified capacity.
.DESCRIPTION
    This function assigns a Fabric workspace to a specified capacity. It checks if the workspace is already assigned to the specified capacity and assigns it if not. The function also handles errors and logs messages accordingly.
.PARAMETER WorkspaceId
    The ID of the Fabric workspace to be assigned to the capacity.
.PARAMETER CapacityId
    The ID of the capacity to which the workspace will be assigned.
.EXAMPLE
    Set-FabricWorkspaceCapacity -WorkspaceId '12345678-1234-1234-1234-123456789012' -CapacityId '87654321-4321-4321-4321-210987654321'
    This example assigns the specified workspace to the specified capacity.
#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$WorkspaceId,

      [Parameter(Mandatory = $true)]
      [string]$CapacityId
    )

    $workspace = Invoke-FabricRest -Method 'GET' -Endpoint "workspaces/$WorkspaceId"
    if ($workspace.Response.capacityId -ne $CapacityId) {
      Write-Log -Message "Assigning Workspace to Capacity ID: $CapacityId" -Level 'WARN'
      $payload = @{
        capacityId = $CapacityId
      }
      _ = (Invoke-FabricRest -Method 'POST' -Endpoint "workspaces/$WorkspaceId/assignToCapacity" -Payload $payload).Response
      $workspace.Response.capacityId = $CapacityId
    }

    return $workspace.Response
  }

  function Set-FabricWorkspaceRoleAssignment {
<#
.SYNOPSIS
    Assigns a Service Principal Name (SPN) to a Fabric workspace with the Admin role.
.DESCRIPTION
    This function assigns a Service Principal Name (SPN) to a Fabric workspace with the Admin role. It checks if the SPN is already assigned to the workspace and assigns it if not. The function also handles errors and logs messages accordingly.
.PARAMETER WorkspaceId
    The ID of the Fabric workspace where the SPN will be assigned.
.PARAMETER SPN
    The Service Principal Name (SPN) to be assigned to the workspace. This should be an object containing the Id and DisplayName of the SPN.
.EXAMPLE
    Set-FabricWorkspaceRoleAssignment -WorkspaceId '12345678-1234-1234-1234-123456789012' -SPN $spn
    This example assigns the specified SPN to the Fabric workspace with the specified ID.

#>
    param (
      [Parameter(Mandatory = $true)]
      [string]$WorkspaceId,

      [Parameter(Mandatory = $true)]
      [object]$SPN
    )

    $results = Invoke-FabricRest -Method 'GET' -Endpoint "workspaces/$WorkspaceId/roleAssignments"
    $result = $results.Response.value | Where-Object { $_.id -eq $SPN.Id }
    if (!$result) {
      Write-Log -Message "Assigning SPN to Workspace: $($SPN.DisplayName)" -Level 'WARN'
      $payload = @{
        principal = @{
          id   = $SPN.Id
          type = 'ServicePrincipal'
        }
        role      = 'Admin'
      }
      $result = (Invoke-FabricRest -Method 'POST' -Endpoint "workspaces/$WorkspaceId/roleAssignments" -Payload $payload).Response
    }
  }

  function Set-FabricGatewayVirtualNetwork {
<#
.SYNOPSIS
    Creates or retrieves a Virtual Network gateway in the Fabric API.
.DESCRIPTION
    This function creates or retrieves a Virtual Network gateway in the Fabric API. It checks if the gateway already exists and creates it if it doesn't. The function also validates the input parameters and handles errors.
.PARAMETER DisplayName
    The display name of the gateway to be created or retrieved.
.PARAMETER CapacityId
    The ID of the capacity to be used for the gateway.
.PARAMETER InactivityMinutesBeforeSleep
    The inactivity time (in minutes) before the gateway goes to auto-sleep. Allowed values: 30, 60, 90, 120, 150, 240, 360, 480, 720, 1440.
.PARAMETER NumberOfMemberGateways
    The number of member gateways (between 1 and 7).
.PARAMETER SubscriptionId
    The Azure subscription ID where the gateway will be created.
.PARAMETER ResourceGroupName
    The name of the Azure Resource Group where the gateway will be created.
.PARAMETER VirtualNetworkName
    The name of the Azure Virtual Network where the gateway will be created.
.PARAMETER SubnetName
    The name of the subnet where the gateway will be created.
.EXAMPLE
    Set-FabricGatewayVirtualNetwork -DisplayName 'MyGateway' -CapacityId '12345678-1234-1234-1234-123456789012' -InactivityMinutesBeforeSleep 30 -NumberOfMemberGateways 2 -SubscriptionId '12345678-1234-1234-1234-123456789012' -ResourceGroupName 'MyResourceGroup' -VirtualNetworkName 'MyVNet' -SubnetName 'MySubnet'
    This example creates or retrieves a Virtual Network gateway with the specified parameters.

#>
    [CmdletBinding()]
    param(
      [Parameter(Mandatory = $true)]
      [string]$DisplayName,

      [Parameter(Mandatory = $true)]
      [string]$CapacityId,

      # Inactivity time (in minutes) before the gateway goes to auto-sleep.
      # Allowed values: 30, 60, 90, 120, 150, 240, 360, 480, 720, 1440.
      [Parameter(Mandatory = $true)]
      [ValidateSet(30, 60, 90, 120, 150, 240, 360, 480, 720, 1440)]
      [int]$InactivityMinutesBeforeSleep,

      # Number of member gateways (between 1 and 7).
      [Parameter(Mandatory = $true)]
      [ValidateRange(1, 7)]
      [int]$NumberOfMemberGateways,

      # Azure virtual network details:
      [Parameter(Mandatory = $true)]
      [string]$SubscriptionId,

      [Parameter(Mandatory = $true)]
      [string]$ResourceGroupName,

      [Parameter(Mandatory = $true)]
      [string]$VirtualNetworkName,

      [Parameter(Mandatory = $true)]
      [string]$SubnetName
    )

    # Attempt to check for an existing gateway with the same display name.
    $existingGateways = Invoke-FabricRest -Method 'GET' -Endpoint "gateways"
    $result = $existingGateways.Response.value | Where-Object { $_.displayName -eq $DisplayName }
    if (!$result) {
      # Construct the payload for creating a Virtual Network gateway.
      # Refer to the API documentation for details on the request format :contentReference[oaicite:1]{index=1} and the Virtual Network Azure Resource :contentReference[oaicite:2]{index=2}.
      $payload = @{
        type                         = "VirtualNetwork"
        displayName                  = $DisplayName
        capacityId                   = $CapacityId
        inactivityMinutesBeforeSleep = $InactivityMinutesBeforeSleep
        numberOfMemberGateways       = $NumberOfMemberGateways
        virtualNetworkAzureResource  = @{
          subscriptionId     = $SubscriptionId
          resourceGroupName  = $ResourceGroupName
          virtualNetworkName = $VirtualNetworkName
          subnetName         = $SubnetName
        }
      }

      Write-Log -Message "Creating Virtual Network Gateway: $DisplayName" -Level 'WARN'
      $newGateway = Invoke-FabricRest -Method 'POST' -Endpoint "gateways" -Payload $payload
      $result = $newGateway.Response
    }

    Write-Log -Message "Gateway Virtual Network - Name: $($result.displayName) / ID: $($result.id)"
    return $result
  }


  function Set-AzureVirtualNetwork {
<#
.SYNOPSIS
    Creates or retrieves an Azure Virtual Network (VNet) with a specified subnet and delegation.
.DESCRIPTION
    This function creates or retrieves an Azure Virtual Network (VNet) with a specified subnet and delegation. It checks if the VNet already exists and creates it if it doesn't. The function also checks for the existence of the subnet and adds it if necessary.
    It assigns the "Network Contributor" role to the current user on the VNet.

.PARAMETER ResourceGroupName
    The name of the Azure Resource Group where the VNet will be created or retrieved.

.PARAMETER VNetName
    The name of the Azure Virtual Network.

.PARAMETER Location
    The Azure region where the VNet will be created.

.PARAMETER AddressPrefixes
    The address prefixes for the VNet.

.PARAMETER SubnetName
    The name of the subnet to be created or retrieved.

.PARAMETER SubnetAddressPrefixes
    The address prefixes for the subnet.

.EXAMPLE
    Set-AzureVirtualNetwork -ResourceGroupName 'MyResourceGroup' -VNetName 'MyVNet' -Location 'East US' -AddressPrefixes '
    Create a new Azure Virtual Network with the specified parameters.

#>
    param(
      [Parameter(Mandatory = $true)]
      [string]$ResourceGroupName,

      [Parameter(Mandatory = $true)]
      [string]$VNetName,

      [Parameter(Mandatory = $true)]
      [string]$Location,

      [Parameter(Mandatory = $true)]
      [string[]]$AddressPrefixes,

      [Parameter(Mandatory = $true)]
      [string]$SubnetName,

      [Parameter(Mandatory = $true)]
      [string[]]$SubnetAddressPrefixes
    )

    # Attempt to get the existing Virtual Network
    try {
      $vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -ErrorAction Stop
    }
    catch {
      # VNet does not exist, so create it
      Write-Log -Message "Creating VNet: $VNetName in Resource Group: $ResourceGroupName" -Level 'WARN'
      $subnetConfig = New-AzVirtualNetworkSubnetConfig `
        -Name $SubnetName `
        -AddressPrefix $SubnetAddressPrefixes `

      $subnetConfig = Add-AzDelegation `
        -Name 'PowerPlatformVnetAccess' `
        -ServiceName 'Microsoft.PowerPlatform/vnetaccesslinks' `
        -Subnet $subnetConfig

      $vnet = New-AzVirtualNetwork `
        -Name $VNetName `
        -ResourceGroupName $ResourceGroupName `
        -Location $Location `
        -AddressPrefix $AddressPrefixes `
        -Subnet $subnetConfig

      # Commit creation
      $vnet = $vnet | Set-AzVirtualNetwork
      Write-Log -Message "Created VNet: $VNetName" -Level 'INFO'
    }

    # If the VNet already exists, check for the subnet
    $subnet = $vnet.Subnets | Where-Object { $_.Name -eq $SubnetName }
    if (-not $subnet) {
      # Subnet does not exist; add one with the delegation
      Write-Log -Message "Adding subnet '$SubnetName' with delegation 'Microsoft.PowerPlatform/vnetaccesslinks' to VNet '$VNetName'." -Level 'WARN'
      $subnetConfig = New-AzVirtualNetworkSubnetConfig `
        -Name $SubnetName `
        -AddressPrefix $SubnetAddressPrefixes `

      $subnetConfig = Add-AzDelegation `
        -Name 'PowerPlatformVnetAccess' `
        -ServiceName 'Microsoft.PowerPlatform/vnetaccesslinks' `
        -Subnet $subnetConfig

      $vnet = $vnet | Set-AzVirtualNetwork
    }
    else {
      # Subnet exists; ensure it has the correct delegation
      $existingDelegation = $subnet.Delegations | Where-Object { $_.ServiceName -eq 'Microsoft.PowerPlatform/vnetaccesslinks' }
      if (-not $existingDelegation) {
        Write-Log -Message "Subnet '$SubnetName' found but missing delegation to 'Microsoft.PowerPlatform/vnetaccesslinks'. Adding Microsoft.PowerPlatform/vnetaccesslinks delegation..." -Level 'WARN'

        $subnetConfig = Add-AzDelegation `
          -Name 'PowerPlatformVnetAccess' `
          -ServiceName 'Microsoft.PowerPlatform/vnetaccesslinks' `
          -Subnet $subnet

        $vnet = $vnet | Set-AzVirtualNetwork
        Write-Log -Message "Added missing delegation to subnet '$SubnetName'." -Level 'INFO'
      }
    }
    Write-Log -Message "Az Virtual Network - Name: $($vnet.Name)"

    $userPrincipalName = $azContext.Account.Id
    $principal = Get-AzADUser -UserPrincipalName $userPrincipalName

    $existingAssignment = Get-AzRoleAssignment -Scope $vnet.Id -ObjectId $principal.Id -ErrorAction SilentlyContinue | Where-Object {
      $_.RoleDefinitionName -eq "Network Contributor"
    }

    Write-Log "Assigning Network Contributor role to the principal on the virtual network $($VNetName)"
    if (!$existingAssignment) {
      New-AzRoleAssignment -ObjectId $principal.Id -RoleDefinitionName "Network Contributor" -Scope $vnet.Id
    }

    return $vnet
  }

  function Invoke-DontRunThisCode {

<#
.SYNOPSIS
    This function is used to set up the environment for the script. It installs required modules, imports the .env file, and logs in to Azure and Azure DevOps.
.DESCRIPTION
    This function is used to set up the environment for the script. It installs required modules, imports the .env file, and logs in to Azure and Azure DevOps. It also checks if the required environment variables are set and logs in to Azure if not already logged in.
    It retrieves the Fabric Capacity ID and logs in to Azure DevOps using the provided access token. The function also retrieves the Service Principal Name (SPN) if provided and logs messages accordingly.
.PARAMETER None
    This function does not take any parameters.
.EXAMPLE
    Invoke-DontRunThisCode
    This example sets up the environment for the script by installing required modules, importing the .env file, and logging in to Azure and Azure DevOps.  It also retrieves the Fabric Capacity ID and logs in to Azure DevOps using the provided access token.
#>

  # Define an array of modules to install
  $modules = @('Az.Accounts', 'Az.Resources', 'Az.Fabric', 'pwsh-dotenv', 'ADOPS', 'Az.Network')

  # Loop through each module and install if not installed
  foreach ($module in $modules) {
    Install-ModuleIfNotInstalled -ModuleName $module
    Import-ModuleIfNotImported -ModuleName $module
  }

  # Import the .env file into the environment variables
  if (Test-Path -Path './wellknown.env') {
    Import-Dotenv -Path ./wellknown.env -AllowClobber
  }

  # if (!$Env:FABRIC_TESTACC_WELLKNOWN_ENTRA_TENANT_ID -or # !$Env:FABRIC_TESTACC_WELLKNOWN_AZURE_SUBSCRIPTION_ID -or # !$Env:FABRIC_TESTACC_WELLKNOWN_FABRIC_CAPACITY_NAME -or # !$Env:FABRIC_TESTACC_WELLKNOWN_AZDO_ORGANIZATION_NAME -or # !$Env:FABRIC_TESTACC_WELLKNOWN_NAME_PREFIX -or # !$Env:FABRIC_TESTACC_WELLKNOWN_AZURE_RESOURCE_GROUP_NAME -or # !$Env:FABRIC_TESTACC_WELLKNOWN_AZURE_LOCATION) {
  #   Write-Log -Message 'FABRIC_TESTACC_WELLKNOWN_ENTRA_TENANT_ID, # FABRIC_TESTACC_WELLKNOWN_AZURE_SUBSCRIPTION_ID, FABRIC_TESTACC_WELLKNOWN_FABRIC_CAPACITY_NAME, # FABRIC_TESTACC_WELLKNOWN_AZDO_ORGANIZATION_NAME and FABRIC_TESTACC_WELLKNOWN_NAME_PREFIX and # FABRIC_TESTACC_WELLKNOWN_AZURE_RESOURCE_GROUP_NAME and FABRIC_TESTACC_WELLKNOWN_AZURE_LOCATION # are required environment variables.' -Level 'ERROR'
  # }

  # Check if already logged in to Azure, if not then login
  $azContext = Get-AzContext
  if (!$azContext -or $azContext.Tenant.Id -ne $Env:FABRIC_TESTACC_WELLKNOWN_ENTRA_TENANT_ID -or $azContext.Subscription.Id -ne $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_SUBSCRIPTION_ID) {
    Write-Log -Message 'Logging in to Azure.' -Level 'DEBUG'
    Connect-AzAccount -Tenant $Env:FABRIC_TESTACC_WELLKNOWN_ENTRA_TENANT_ID -SubscriptionId $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_SUBSCRIPTION_ID -UseDeviceAuthentication
    $azContext = Get-AzContext
    # Disconnect-AzAccount
  }
  # $currentUser = Get-AzADUser -SignedIn

  # Logged in to Azure DevOps
  Write-Log -Message 'Logging in to Azure DevOps.' -Level 'DEBUG'
  $secureAccessToken = (Get-AzAccessToken -WarningAction SilentlyContinue -AsSecureString -ResourceUrl '499b84ac-1321-427f-aa17-267ca6975798').Token
  $unsecureAccessToken = $secureAccessToken | ConvertFrom-SecureString -AsPlainText
  $azdoContext = Connect-ADOPS -TenantId $azContext.Tenant.Id -Organization $Env:FABRIC_TESTACC_WELLKNOWN_AZDO_ORGANIZATION_NAME -OAuthToken $unsecureAccessToken

  $SPN = $null
  if ($Env:FABRIC_TESTACC_WELLKNOWN_SPN_NAME) {
    $SPN = Get-AzADServicePrincipal -DisplayName $Env:FABRIC_TESTACC_WELLKNOWN_SPN_NAME
  }

  $wellKnown = @{}

  # Get Fabric Capacity ID
  $capacities = Invoke-FabricRest -Method 'GET' -Endpoint 'capacities'
  $capacity = $capacities.Response.value | Where-Object { $_.displayName -eq $Env:FABRIC_TESTACC_WELLKNOWN_FABRIC_CAPACITY_NAME }
  if (!$capacity) {
    Write-Log -Message "Fabric Capacity: $($Env:FABRIC_TESTACC_WELLKNOWN_FABRIC_CAPACITY_NAME)"
  }
  Write-Log -Message "Fabric Capacity - Name: $($Env:FABRIC_TESTACC_WELLKNOWN_FABRIC_CAPACITY_NAME) / ID: $($capacity.id)"
  $wellKnown['Capacity'] = @{
    id          = $capacity.id
    displayName = $capacity.displayName
    sku         = $capacity.sku
  }

  $itemNaming = @{
    'Dashboard'             = 'dash'
    'Datamart'              = 'dm'
    'DataPipeline'          = 'dp'
    'Environment'           = 'env'
    'Eventhouse'            = 'eh'
    'Eventstream'           = 'es'
    'GraphQLApi'            = 'gql'
    'KQLDashboard'          = 'kqldash'
    'KQLDatabase'           = 'kqldb'
    'KQLQueryset'           = 'kqlqs'
    'Lakehouse'             = 'lh'
    'MirroredDatabase'      = 'mdb'
    'MirroredWarehouse'     = 'mwh'
    'MLExperiment'          = 'mle'
    'MLModel'               = 'mlm'
    'Notebook'              = 'nb'
    'PaginatedReport'       = 'prpt'
    'Reflex'                = 'rx'
    'Report'                = 'rpt'
    'SemanticModel'         = 'sm'
    'SparkJobDefinition'    = 'sjd'
    'SQLDatabase'           = 'sqldb'
    'SQLEndpoint'           = 'sqle'
    'Warehouse'             = 'wh'
    'WorkspaceDS'           = 'wsds'
    'WorkspaceRS'           = 'wsrs'
    'DomainParent'          = 'parent'
    'DomainChild'           = 'child'
    'EntraServicePrincipal' = 'sp'
    'EntraGroup'            = 'grp'
    'AzDOProject'           = 'proj'
    'VirtualNetwork01'      = 'vnet01'
    'VirtualNetwork02'      = 'vnet02'
    'VirtualNetworkSubnet'  = 'subnet'
    'GatewayVirtualNetwork' = 'gvnet'
  }

  $baseName = Get-BaseName
  $Env:FABRIC_TESTACC_WELLKNOWN_NAME_BASE = $baseName

  # Save env vars wellknown.env file
  $envVarNames = @(
    'FABRIC_TESTACC_WELLKNOWN_ENTRA_TENANT_ID',
    'FABRIC_TESTACC_WELLKNOWN_AZURE_SUBSCRIPTION_ID',
    'FABRIC_TESTACC_WELLKNOWN_AZURE_RESOURCE_GROUP_NAME'
    'FABRIC_TESTACC_WELLKNOWN_AZURE_LOCATION',
    'FABRIC_TESTACC_WELLKNOWN_FABRIC_CAPACITY_NAME',
    'FABRIC_TESTACC_WELLKNOWN_AZDO_ORGANIZATION_NAME',
    'FABRIC_TESTACC_WELLKNOWN_NAME_PREFIX',
    'FABRIC_TESTACC_WELLKNOWN_NAME_SUFFIX',
    'FABRIC_TESTACC_WELLKNOWN_NAME_BASE',
    'FABRIC_TESTACC_WELLKNOWN_SPN_NAME'
  )

  $envVars = $envVarNames | ForEach-Object {
    $envVarName = $_
    if (Test-Path "Env:${envVarName}") {
      $value = (Get-ChildItem "Env:${envVarName}").Value
      "$envVarName=`"$value`""
    }
  }

  $envVars -join "`n" | Set-Content -Path './wellknown.env' -Force -NoNewline -Encoding utf8

  $displayName = Get-DisplayName -Base $baseName

  # Create WorkspaceRS if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['WorkspaceRS'])"
  $workspace = Set-FabricWorkspace -DisplayName $displayNameTemp -CapacityId $capacity.id

  # Assign WorkspaceDS to Capacity if not already assigned or assigned to a different capacity
  $workspace = Set-FabricWorkspaceCapacity -WorkspaceId $workspace.id -CapacityId $capacity.id

  Write-Log -Message "WorkspaceRS - Name: $($workspace.displayName) / ID: $($workspace.id)"
  $wellKnown['WorkspaceRS'] = @{
    id          = $workspace.id
    displayName = $workspace.displayName
    description = $workspace.description
  }

  # Assign SPN to WorkspaceRS if not already assigned
  if ($SPN) {
    Set-FabricWorkspaceRoleAssignment -WorkspaceId $workspace.id -SPN $SPN
  }

  # Create WorkspaceDS if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['WorkspaceDS'])"
  $workspace = Set-FabricWorkspace -DisplayName $displayNameTemp -CapacityId $capacity.id

  # Assign WorkspaceDS to Capacity if not already assigned or assigned to a different capacity
  $workspace = Set-FabricWorkspaceCapacity -WorkspaceId $workspace.id -CapacityId $capacity.id

  Write-Log -Message "WorkspaceDS - Name: $($workspace.displayName) / ID: $($workspace.id)"
  $wellKnown['WorkspaceDS'] = @{
    id          = $workspace.id
    displayName = $workspace.displayName
    description = $workspace.description
  }

  # Assign SPN to WorkspaceRS if not already assigned
  if ($SPN) {
    Set-FabricWorkspaceRoleAssignment -WorkspaceId $workspace.id -SPN $SPN
  }

  # Define an array of item types to create
  $itemTypes = @('DataPipeline', 'Environment', 'Eventhouse', 'Eventstream', 'GraphQLApi', 'KQLDashboard', 'KQLQueryset', 'Lakehouse', 'MLExperiment', 'MLModel', 'Notebook', 'Reflex', 'SparkJobDefinition', 'SQLDatabase', 'Warehouse')

  # Loop through each item type and create if not exists
  foreach ($itemType in $itemTypes) {

    $displayNameTemp = "${displayName}_$($itemNaming[$itemType])"
    $item = Set-FabricItem -DisplayName $displayNameTemp -WorkspaceId $workspace.id -Type $itemType
    $wellKnown[$itemType] = @{
      id          = $item.id
      displayName = $item.displayName
      description = $item.description
    }
  }

  # Create KQLDatabase if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['KQLDatabase'])"
  $creationPayload = @{
    databaseType           = 'ReadWrite'
    parentEventhouseItemId = $wellKnown['Eventhouse'].id
  }
  $kqlDatabase = Set-FabricItem -DisplayName $displayNameTemp -WorkspaceId $workspace.id -Type 'KQLDatabase' -CreationPayload $creationPayload
  $wellKnown['KQLDatabase'] = @{
    id          = $kqlDatabase.id
    displayName = $kqlDatabase.displayName
    description = $kqlDatabase.description
  }

  # Create MirroredDatabase if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['MirroredDatabase'])"
  $definition = @{
    parts = @(
      @{
        path        = "mirroring.json"
        payload     = Get-DefinitionPartBase64 -Path 'internal/testhelp/fixtures/mirrored_database/mirroring.json.tmpl' -Values @(@{ key = '{{ .DEFAULT_SCHEMA }}'; value = 'dbo' })
        payloadType = 'InlineBase64'
      }
    )
  }
  $mirroredDatabase = Set-FabricItem -DisplayName $displayNameTemp -WorkspaceId $workspace.id -Type 'MirroredDatabase' -Definition $definition
  $wellKnown['MirroredDatabase'] = @{
    id          = $mirroredDatabase.id
    displayName = $mirroredDatabase.displayName
    description = $mirroredDatabase.description
  }

  # Create SemanticModel if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['SemanticModel'])"
  $definition = @{
    parts = @(
      @{
        path        = 'definition.pbism'
        payload     = Get-DefinitionPartBase64 -Path 'internal/testhelp/fixtures/semantic_model_tmsl/definition.pbism'
        payloadType = 'InlineBase64'
      }
      @{
        path        = 'model.bim'
        payload     = Get-DefinitionPartBase64 -Path 'internal/testhelp/fixtures/semantic_model_tmsl/model.bim.tmpl' -Values @(@{ key = '{{ .ColumnName }}'; value = 'ColumnTest1' })
        payloadType = 'InlineBase64'
      }
    )
  }
  $semanticModel = Set-FabricItem -DisplayName $displayNameTemp -WorkspaceId $workspace.id -Type 'SemanticModel' -Definition $definition
  $wellKnown['SemanticModel'] = @{
    id          = $semanticModel.id
    displayName = $semanticModel.displayName
    description = $semanticModel.description
  }

  # Create Report if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['Report'])"
  $definition = @{
    parts = @(
      @{
        path        = 'definition.pbir'
        payload     = Get-DefinitionPartBase64 -Path 'internal/testhelp/fixtures/report_pbir_legacy/definition.pbir.tmpl' -Values @(@{ key = '{{ .SemanticModelID }}'; value = $semanticModel.id })
        payloadType = 'InlineBase64'
      },
      @{
        path        = 'report.json'
        payload     = Get-DefinitionPartBase64 -Path 'internal/testhelp/fixtures/report_pbir_legacy/report.json'
        payloadType = 'InlineBase64'
      },
      @{
        path        = 'StaticResources/SharedResources/BaseThemes/CY24SU10.json'
        payload     = Get-DefinitionPartBase64 -Path 'internal/testhelp/fixtures/report_pbir_legacy/StaticResources/SharedResources/BaseThemes/CY24SU10.json'
        payloadType = 'InlineBase64'
      }
      @{
        path        = 'StaticResources/RegisteredResources/fabric_48_color10148978481469717.png'
        payload     = Get-DefinitionPartBase64 -Path 'internal/testhelp/fixtures/report_pbir_legacy/StaticResources/RegisteredResources/fabric_48_color10148978481469717.png'
        payloadType = 'InlineBase64'
      }
    )
  }
  $report = Set-FabricItem -DisplayName $displayNameTemp -WorkspaceId $workspace.id -Type 'Report' -Definition $definition
  $wellKnown['Report'] = @{
    id          = $report.id
    displayName = $report.displayName
    description = $report.description
  }

  # Create Parent Domain if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['DomainParent'])"
  $parentDomain = Set-FabricDomain -DisplayName $displayNameTemp
  $wellKnown['DomainParent'] = @{
    id          = $parentDomain.id
    displayName = $parentDomain.displayName
    description = $parentDomain.description
  }

  # Create Child Domain if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['DomainChild'])"
  $childDomain = Set-FabricDomain -DisplayName $displayNameTemp -ParentDomainId $parentDomain.id
  $wellKnown['DomainChild'] = @{
    id          = $childDomain.id
    displayName = $childDomain.displayName
    description = $childDomain.description
  }

  $results = Invoke-FabricRest -Method 'GET' -Endpoint "workspaces/$($workspace.id)/lakehouses/$($wellKnown['Lakehouse']['id'])/tables"
  $result = $results.Response.data | Where-Object { $_.name -eq 'publicholidays' }
  if (!$result) {
    Write-Log -Message "!!! Please go to the Lakehouse and manually run 'Start with sample data' to populate the data !!!" -Level 'ERROR' -Stop $false
    Write-Log -Message "Lakehouse: https://app.fabric.microsoft.com/groups/$($workspace.id)/lakehouses/$($wellKnown['Lakehouse']['id'])" -Level 'WARN'
  }
  $wellKnown['Lakehouse']['tableName'] = 'publicholidays'

  $displayNameTemp = "${displayName}_$($itemNaming['Dashboard'])"
  $results = Invoke-FabricRest -Method 'GET' -Endpoint "workspaces/$($workspace.id)/dashboards"
  $result = $results.Response.value | Where-Object { $_.displayName -eq $displayNameTemp }
  if (!$result) {
    Write-Log -Message "!!! Please create a Dashboard manually (with Display Name: ${displayNameTemp}), and update details in the well-known file !!!" -Level 'ERROR' -Stop $false
    Write-Log -Message "Workspace: https://app.fabric.microsoft.com/groups/$($workspace.id)" -Level 'WARN'
  }
  $wellKnown['Dashboard'] = @{
    id          = if ($result) { $result.id } else { '00000000-0000-0000-0000-000000000000' }
    displayName = if ($result) { $result.displayName } else { $displayNameTemp }
    description = if ($result) { $result.description } else { '' }
  }

  $displayNameTemp = "${displayName}_$($itemNaming['Datamart'])"
  $results = Invoke-FabricRest -Method 'GET' -Endpoint "workspaces/$($workspace.id)/datamarts"
  $result = $results.Response.value | Where-Object { $_.displayName -eq $displayNameTemp }
  if (!$result) {
    Write-Log -Message "!!! Please create a Datamart manually (with Display Name: ${displayNameTemp}), and update details in the well-known file !!!" -Level 'ERROR' -Stop $false
    Write-Log -Message "Workspace: https://app.fabric.microsoft.com/groups/$($workspace.id)" -Level 'WARN'
  }
  $wellKnown['Datamart'] = @{
    id          = if ($result) { $result.id } else { '00000000-0000-0000-0000-000000000000' }
    displayName = if ($result) { $result.displayName } else { $displayNameTemp }
    description = if ($result) { $result.description } else { '' }
  }

  # Create SP if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['EntraServicePrincipal'])"
  $entraSp = Get-AzADServicePrincipal -DisplayName $displayNameTemp
  if (!$entraSp) {
    Write-Log -Message "Creating Service Principal: $displayNameTemp" -Level 'WARN'
    $entraApp = New-AzADApplication -DisplayName $displayNameTemp
    $entraSp = New-AzADServicePrincipal -ApplicationId $entraApp.AppId
  }
  Write-Log -Message "Service Principal - Name: $($entraSp.DisplayName) / ID: $($entraSp.id)"
  $wellKnown['Principal'] = @{
    id    = $entraSp.Id
    type  = 'ServicePrincipal'
    name  = $entraSp.DisplayName
    appId = $entraSp.AppId
  }

  # Create Group if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['EntraGroup'])"
  $entraGroup = Get-AzADGroup -DisplayName $displayNameTemp
  if (!$entraGroup) {
    Write-Log -Message "Creating Group: $displayNameTemp" -Level 'WARN'
    $entraGroup = New-AzADGroup -DisplayName $displayNameTemp -MailNickname $displayNameTemp -SecurityEnabled
    # New-AzADGroupOwner -GroupId $entraGroup.Id -OwnerId $currentUser.Id
  }
  Write-Log -Message "Group - Name: $($entraGroup.DisplayName) / ID: $($entraGroup.Id)"
  $wellKnown['Group'] = @{
    type = 'Group'
    id   = $entraGroup.Id
    name = $entraGroup.DisplayName
  }

  # Create AzDO Project if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['AzDOProject'])"
  $azdoProject = Get-ADOPSProject -Name $displayNameTemp
  if (!$azdoProject) {
    Write-Log -Message "Creating AzDO Project: $displayNameTemp" -Level 'WARN'
    $azdoProject = New-ADOPSProject -Name $displayNameTemp -Visibility Private -Wait
  }
  Write-Log -Message "AzDO Project - Name: $($azdoProject.name) / ID: $($azdoProject.id)"

  # Create AzDO Repository if not exists
  $azdoRepo = Get-ADOPSRepository -Project $azdoProject.name -Repository 'test'
  if (!$azdoRepo) {
    Write-Log -Message "Creating AzDO Repository: test" -Level 'WARN'
    $azdoRepo = New-ADOPSRepository -Project $azdoProject.name -Name 'test'
    Initialize-ADOPSRepository -RepositoryId $azdoRepo.id | Out-Null
  }
  Write-Log -Message "AzDO Repository - Name: $($azdoRepo.name) / ID: $($azdoRepo.id)"
  $wellKnown['AzDO'] = @{
    organizationName = $azdoContext.Organization
    projectId        = $azdoProject.id
    projectName      = $azdoProject.name
    repositoryId     = $azdoRepo.id
    repositoryName   = $azdoRepo.name
  }

  if ($SPN) {
    $body = @{
      originId = $SPN.Id
    }
    $bodyJson = $body | ConvertTo-Json
    $azdoSPN = Invoke-ADOPSRestMethod -Uri "https://vssps.dev.azure.com/$($azdoContext.Organization)/_apis/graph/serviceprincipals?api-version=7.2-preview.1" -Method Post -Body $bodyJson
    $result = Set-ADOPSGitPermission -ProjectId $azdoProject.id -RepositoryId $azdoRepo.id -Descriptor $azdoSPN.descriptor -Allow 'GenericContribute', 'PullRequestContribute', 'CreateBranch', 'CreateTag', 'GenericRead'
  }

  # Register the Microsoft.PowerPlatform resource provider
  Write-Log -Message "Registering Microsoft.PowerPlatform resource provider" -Level 'WARN'
  Register-AzResourceProvider -ProviderNamespace "Microsoft.PowerPlatform"

  # Create Azure Virtual Network 1 if not exists
  $vnetName = "${displayName}_$($itemNaming['VirtualNetwork01'])"
  $addrRange = "10.10.0.0/16"
  $subName = "${displayName}_$($itemNaming['VirtualNetworkSubnet'])"
  $subRange = "10.10.1.0/24"

  $vnet = Set-AzureVirtualNetwork `
    -ResourceGroupName $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_RESOURCE_GROUP_NAME `
    -VNetName $vnetName `
    -Location $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_LOCATION `
    -AddressPrefixes $addrRange `
    -SubnetName $subName `
    -SubnetAddressPrefixes $subRange

  $wellKnown['VirtualNetwork01'] = @{
    name              = $vnet.Name
    resourceGroupName = $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_RESOURCE_GROUP_NAME
    subnetName        = $subName
    subscriptionId    = $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_SUBSCRIPTION_ID
  }


  # Create Azure Virtual Network 2 if not exists
  $vnetName = "${displayName}_$($itemNaming['VirtualNetwork02'])"
  $addrRange = "10.10.0.0/16"
  $subName = "${displayName}_$($itemNaming['VirtualNetworkSubnet'])"
  $subRange = "10.10.1.0/24"

  $vnet = Set-AzureVirtualNetwork `
    -ResourceGroupName $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_RESOURCE_GROUP_NAME `
    -VNetName $vnetName `
    -Location $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_LOCATION `
    -AddressPrefixes $addrRange `
    -SubnetName $subName `
    -SubnetAddressPrefixes $subRange

  $wellKnown['VirtualNetwork02'] = @{
    name              = $vnet.Name
    resourceGroupName = $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_RESOURCE_GROUP_NAME
    subnetName        = $subName
    subscriptionId    = $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_SUBSCRIPTION_ID
  }

  # Create Fabric Gateway Virtual Network if not exists
  $displayNameTemp = "${displayName}_$($itemNaming['GatewayVirtualNetwork'])"
  $inactivityMinutesBeforeSleep = 30
  $numberOfMemberGateways = 1

  $gateway = Set-FabricGatewayVirtualNetwork `
    -DisplayName $displayNameTemp `
    -CapacityId $capacity.id `
    -InactivityMinutesBeforeSleep $inactivityMinutesBeforeSleep `
    -NumberOfMemberGateways $numberOfMemberGateways `
    -SubscriptionId $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_SUBSCRIPTION_ID `
    -ResourceGroupName $Env:FABRIC_TESTACC_WELLKNOWN_AZURE_RESOURCE_GROUP_NAME `
    -VirtualNetworkName $wellKnown['VirtualNetwork01'].name `
    -SubnetName $wellKnown['VirtualNetwork01'].subnetName

  $wellKnown['GatewayVirtualNetwork'] = @{
    id          = $gateway.id
    displayName = $gateway.displayName
    type        = $gateway.type
  }

  # Save wellknown.json file
  $wellKnownJson = $wellKnown | ConvertTo-Json
  $wellKnownJson
  $wellKnownJson | Set-Content -Path './internal/testhelp/fixtures/.wellknown.json' -Force -NoNewline -Encoding utf8
}
