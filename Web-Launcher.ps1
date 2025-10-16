#Requires -Version 5.1
<#
.SYNOPSIS
    Web-runnable launcher for MS Teams Uninstaller

.DESCRIPTION
    This script can be executed directly from a web URL using PowerShell's Invoke-Expression
    or by downloading and running. It downloads the latest Teams uninstaller from GitHub
    and executes it with the specified parameters. The uninstaller targets Teams versions
    older than 1.7x.

.PARAMETER UserProfile
    Target specific user profile (optional)

.PARAMETER Force
    Execute without confirmation prompts

.PARAMETER WhatIf
    Test mode - show what would be done

.EXAMPLE
    # Execute directly from web URL
    $script = iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing; iex $script.Content

.EXAMPLE
    # Execute with WhatIf mode
    $script = iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing; iex $script.Content -WhatIf

.EXAMPLE
    # Execute with specific user profile
    $script = iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing; iex $script.Content -UserProfile "C:\Users\jdoe" -Force
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$UserProfile,
    
    [Parameter(Mandatory = $false)]
    [switch]$Force,
    
    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

# Configuration
$GitHubUser = "monobrau"
$Repository = "teams-uninstaller"
$Branch = "main"
$ScriptName = "Uninstall-TeamsVersions.ps1"
$GitHubRawUrl = "https://raw.githubusercontent.com/$GitHubUser/$Repository/$Branch/$ScriptName"
$TempPath = "$env:TEMP\TeamsUninstaller"
$LocalScriptPath = Join-Path $TempPath $ScriptName

# Function to display header
function Show-Header {
    Write-Host ""
    Write-Host "=== MS Teams Uninstaller - Web Launcher ===" -ForegroundColor Cyan
    Write-Host "GitHub Repository: $GitHubUser/$Repository" -ForegroundColor Gray
    Write-Host "Script: $ScriptName" -ForegroundColor Gray
    Write-Host "Mode: $(if ($WhatIf) { 'TEST (WhatIf)' } else { 'EXECUTE' })" -ForegroundColor $(if ($WhatIf) { 'Yellow' } else { 'Red' })
    if ($UserProfile) {
        Write-Host "Target User: $UserProfile" -ForegroundColor Gray
    }
    Write-Host ""
}

# Function to download script from GitHub
function Get-TeamsUninstaller {
    param(
        [string]$Url,
        [string]$LocalPath
    )
    
    try {
        Write-Host "Downloading Teams Uninstaller from GitHub..." -ForegroundColor Green
        Write-Host "URL: $Url" -ForegroundColor Gray
        
        # Create temp directory if it doesn't exist
        $tempDir = Split-Path $LocalPath -Parent
        if (-not (Test-Path $tempDir)) {
            New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
        }
        
        # Download the script
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -ErrorAction Stop
        $response.Content | Out-File -FilePath $LocalPath -Encoding UTF8 -Force
        
        Write-Host "Script downloaded successfully!" -ForegroundColor Green
        Write-Host "Local path: $LocalPath" -ForegroundColor Gray
        return $true
    }
    catch {
        Write-Error "Failed to download script from GitHub: $($_.Exception.Message)"
        return $false
    }
}

# Function to validate downloaded script
function Test-DownloadedScript {
    param(
        [string]$ScriptPath
    )
    
    if (-not (Test-Path $ScriptPath)) {
        return $false
    }
    
    # Check if it's a valid PowerShell script
    $content = Get-Content $ScriptPath -Raw
    if ($content -match "#Requires -Version" -and $content -match "function.*Teams") {
        return $true
    }
    
    return $false
}

# Function to execute the Teams uninstaller
function Invoke-TeamsUninstaller {
    param(
        [string]$ScriptPath,
        [hashtable]$Parameters
    )
    
    try {
        Write-Host "Executing Teams Uninstaller..." -ForegroundColor Cyan
        Write-Host "Script: $ScriptPath" -ForegroundColor Gray
        
        # Execute the script with parameters
        & $ScriptPath @Parameters
    }
    catch {
        Write-Error "Failed to execute Teams Uninstaller: $($_.Exception.Message)"
        return $false
    }
    
    return $true
}

# Main execution
Show-Header

# Download the script
$downloadSuccess = Get-TeamsUninstaller -Url $GitHubRawUrl -LocalPath $LocalScriptPath

if (-not $downloadSuccess) {
    Write-Error "Failed to download Teams Uninstaller. Exiting."
    exit 1
}

# Validate downloaded script
if (-not (Test-DownloadedScript -ScriptPath $LocalScriptPath)) {
    Write-Error "Downloaded script validation failed. Exiting."
    exit 1
}

# Prepare parameters for the main script
$scriptParams = @{}

if ($UserProfile) {
    $scriptParams['UserProfile'] = $UserProfile
}

if ($Force) {
    $scriptParams['Force'] = $true
}

if ($WhatIf) {
    $scriptParams['WhatIf'] = $true
}

# Execute the Teams uninstaller
$executeSuccess = Invoke-TeamsUninstaller -ScriptPath $LocalScriptPath -Parameters $scriptParams

if ($executeSuccess) {
    Write-Host ""
    Write-Host "=== Web Launcher completed successfully ===" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "=== Web Launcher completed with errors ===" -ForegroundColor Red
    exit 1
}
