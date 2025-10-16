# Direct web execution for MS Teams Uninstaller
# This script can be executed directly from GitHub without parameter issues

# Check if parameters were passed via command line arguments
$WhatIf = $args -contains "-WhatIf" -or $args -contains "-whatif"
$Force = $args -contains "-Force" -or $args -contains "-force"
$UserProfile = $null

# Parse UserProfile from arguments
for ($i = 0; $i -lt $args.Length; $i++) {
    if ($args[$i] -eq "-UserProfile" -and $i + 1 -lt $args.Length) {
        $UserProfile = $args[$i + 1]
        break
    }
}

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
    
    # Build parameter array for direct execution
    $params = @()
    if ($UserProfile) { $params += "-UserProfile"; $params += $UserProfile }
    if ($Force) { $params += "-Force" }
    if ($WhatIf) { $params += "-WhatIf" }
    
    # Execute the script with parameters
    & $tempPath @params
}
catch {
    Write-Error "Failed to download or execute script: $($_.Exception.Message)"
}
