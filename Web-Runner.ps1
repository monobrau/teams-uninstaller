# Web-executable Teams Uninstaller
# This script can be run directly from GitHub with proper parameter handling

param(
    [string]$UserProfile,
    [switch]$Force,
    [switch]$WhatIf
)

# Download the main script from GitHub
$scriptUrl = "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1"
$tempPath = "$env:TEMP\TeamsUninstaller.ps1"

try {
    Write-Host "Downloading Teams Uninstaller from GitHub..." -ForegroundColor Green
    $response = Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing -ErrorAction Stop
    $response.Content | Out-File -FilePath $tempPath -Encoding UTF8 -Force
    
    Write-Host "Script downloaded successfully!" -ForegroundColor Green
    Write-Host "Target: Teams versions older than 1.7x" -ForegroundColor Cyan
    Write-Host ""
    
    # Execute the script with parameters
    & $tempPath -UserProfile $UserProfile -Force:$Force -WhatIf:$WhatIf
}
catch {
    Write-Error "Failed to download or execute script: $($_.Exception.Message)"
}
