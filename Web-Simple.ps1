# Simple web-executable Teams Uninstaller
# This script handles parameters correctly when executed from web

param(
    [string]$UserProfile,
    [switch]$Force,
    [switch]$WhatIf
)

# Download the main script from GitHub
$scriptUrl = "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1"
$tempPath = "$env:TEMP\TeamsUninstaller.ps1"

try {
    Write-Host "=== MS Teams Uninstaller - Web Version ===" -ForegroundColor Cyan
    Write-Host "Downloading latest script from GitHub..." -ForegroundColor Green
    
    $response = Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing -ErrorAction Stop
    $response.Content | Out-File -FilePath $tempPath -Encoding UTF8 -Force
    
    Write-Host "Script downloaded successfully!" -ForegroundColor Green
    Write-Host "Target: Teams versions older than 1.7x" -ForegroundColor Yellow
    Write-Host ""
    
    # Build parameter hashtable
    $params = @{}
    if ($UserProfile) { $params['UserProfile'] = $UserProfile }
    if ($Force) { $params['Force'] = $true }
    if ($WhatIf) { $params['WhatIf'] = $true }
    
    # Execute the script with parameters
    & $tempPath @params
}
catch {
    Write-Error "Failed to download or execute script: $($_.Exception.Message)"
}
