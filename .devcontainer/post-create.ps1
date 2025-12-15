# post-create.ps1

Write-Host "Running DevContainer post-create setup..."

# Ensure scripts can run
Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# Install/update PSResourceGet side-by-side
Write-Host "Installing PSResourceGet..."
Install-Module Microsoft.PowerShell.PSResourceGet -Force -AllowClobber

# Install common modules used in this environment
$requiredModules = @(
    "Pester",
    "Az.Accounts"
)

Write-Host "Installing required modules..."
foreach ($module in $requiredModules) {
    Install-Module $module -Repository PSGallery -Force -SkipPublisherCheck -AllowClobber
}

# Validate installation
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Warning "Module [$module] did NOT install successfully!"
    }
}

# Display installed versions for debugging
Write-Host "Installed module versions:"

Get-Module -ListAvailable |
    Where-Object { $_.Name -in $requiredModules + "Microsoft.PowerShell.PSResourceGet" } |
    Sort-Object Name, Version |
    Format-Table Name, Version, ModuleBase
