# Simple web execution for Force mode
# This script can be executed directly from GitHub

# Download the main script from GitHub
$scriptUrl = "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1"
$tempPath = "$env:TEMP\TeamsUninstaller.ps1"

try {
    Write-Host "=== MS Teams Uninstaller - Web Version ===" -ForegroundColor Cyan
    Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor Gray
    Write-Host "Downloading latest script from GitHub..." -ForegroundColor Green
    
    $response = Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing -ErrorAction Stop
    $response.Content | Out-File -FilePath $tempPath -Encoding UTF8 -Force
    
    Write-Host "Script downloaded successfully!" -ForegroundColor Green
    Write-Host "Target: Teams versions older than 1.7x" -ForegroundColor Yellow
    Write-Host "Mode: EXECUTE (Force)" -ForegroundColor Red
    Write-Host ""
    
    # Execute the script with Force parameter
    & $tempPath -Force
}
catch {
    Write-Error "Failed to download or execute script: $($_.Exception.Message)"
}
