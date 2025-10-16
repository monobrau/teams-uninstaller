#Requires -Version 5.1
<#
.SYNOPSIS
    Launcher script for MS Teams Uninstaller - Downloads and runs from GitHub

.DESCRIPTION
    This script downloads the latest version of the MS Teams Uninstaller from GitHub
    and executes it. Perfect for use in ScreenConnect or other remote management tools.

.PARAMETER GitHubUser
    GitHub username (default: monobrau)

.PARAMETER Repository
    Repository name (default: teams-uninstaller)

.PARAMETER Branch
    Branch name (default: main)

.PARAMETER ScriptName
    Script filename (default: Uninstall-TeamsVersions.ps1)

.PARAMETER TempPath
    Temporary directory for downloads (default: $env:TEMP\TeamsUninstaller)

.PARAMETER Force
    Force download even if script already exists locally

.PARAMETER WhatIf
    Show what would be downloaded without executing

.EXAMPLE
    .\Launch-TeamsUninstaller.ps1
    Downloads and runs the latest Teams uninstaller

.EXAMPLE
    .\Launch-TeamsUninstaller.ps1 -WhatIf
    Shows what would be downloaded without executing

.EXAMPLE
    .\Launch-TeamsUninstaller.ps1 -Force
    Forces re-download and execution

.EXAMPLE
    .\Launch-TeamsUninstaller.ps1 -UserProfile "C:\Users\jdoe" -Force
    Downloads and runs with specific user profile targeting
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$GitHubUser = "monobrau",
    
    [Parameter(Mandatory = $false)]
    [string]$Repository = "teams-uninstaller",
    
    [Parameter(Mandatory = $false)]
    [string]$Branch = "main",
    
    [Parameter(Mandatory = $false)]
    [string]$ScriptName = "Uninstall-TeamsVersions.ps1",
    
    [Parameter(Mandatory = $false)]
    [string]$TempPath = "$env:TEMP\TeamsUninstaller",
    
    [Parameter(Mandatory = $false)]
    [switch]$Force,
    
    # Pass-through parameters for the main script
    [Parameter(Mandatory = $false)]
    [string]$UserProfile,
    
    [Parameter(Mandatory = $false)]
    [switch]$PassForce
)

# GitHub Raw URL
$GitHubRawUrl = "https://raw.githubusercontent.com/$GitHubUser/$Repository/$Branch/$ScriptName"

# Create temp directory
if (-not (Test-Path $TempPath)) {
    New-Item -Path $TempPath -ItemType Directory -Force | Out-Null
}

$LocalScriptPath = Join-Path $TempPath $ScriptName

# Function to download script from GitHub
function Get-ScriptFromGitHub {
    param(
        [string]$Url,
        [string]$LocalPath
    )
    
    try {
        Write-Host "Downloading script from GitHub..." -ForegroundColor Green
        Write-Host "URL: $Url" -ForegroundColor Gray
        
        # Use Invoke-WebRequest to download the script
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -ErrorAction Stop
        
        # Save to local file
        $response.Content | Out-File -FilePath $LocalPath -Encoding UTF8 -Force
        
        Write-Host "Script downloaded successfully to: $LocalPath" -ForegroundColor Green
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

# Main execution
Write-Host "=== MS Teams Uninstaller Launcher ===" -ForegroundColor Cyan
Write-Host "GitHub Repository: $GitHubUser/$Repository" -ForegroundColor Gray
Write-Host "Branch: $Branch" -ForegroundColor Gray
Write-Host "Script: $ScriptName" -ForegroundColor Gray
Write-Host ""

# Check if script already exists locally
$scriptExists = Test-Path $LocalScriptPath
$scriptValid = $false

if ($scriptExists) {
    Write-Host "Local script found: $LocalScriptPath" -ForegroundColor Yellow
    $scriptValid = Test-DownloadedScript -ScriptPath $LocalScriptPath
    
    if ($scriptValid) {
        Write-Host "Local script is valid" -ForegroundColor Green
    } else {
        Write-Host "Local script appears to be corrupted" -ForegroundColor Red
    }
}

# Download script if needed
$shouldDownload = $Force -or -not $scriptExists -or -not $scriptValid

if ($shouldDownload) {
    if ($PSCmdlet.ShouldProcess($GitHubRawUrl, "Download script from GitHub")) {
        $downloadSuccess = Get-ScriptFromGitHub -Url $GitHubRawUrl -LocalPath $LocalScriptPath
        
        if (-not $downloadSuccess) {
            Write-Error "Failed to download script. Exiting."
            exit 1
        }
        
        # Validate downloaded script
        if (-not (Test-DownloadedScript -ScriptPath $LocalScriptPath)) {
            Write-Error "Downloaded script validation failed. Exiting."
            exit 1
        }
    } else {
        # WhatIf mode - create a dummy script for testing
        Write-Host "WhatIf mode: Creating dummy script for testing" -ForegroundColor Yellow
        "# Dummy script for WhatIf testing" | Out-File -FilePath $LocalScriptPath -Encoding UTF8
    }
} else {
    Write-Host "Using existing local script" -ForegroundColor Green
}

# Execute the downloaded script
if (Test-Path $LocalScriptPath) {
    Write-Host ""
    Write-Host "Executing Teams Uninstaller..." -ForegroundColor Cyan
    Write-Host "Script Path: $LocalScriptPath" -ForegroundColor Gray
    Write-Host ""
    
    # Build parameters for the main script
    $scriptParams = @{}
    
    if ($UserProfile) {
        $scriptParams['UserProfile'] = $UserProfile
    }
    
    if ($PassForce) {
        $scriptParams['Force'] = $true
    }
    
    if ($WhatIf) {
        $scriptParams['WhatIf'] = $true
    }
    
    try {
        # Execute the script with parameters
        & $LocalScriptPath @scriptParams
    }
    catch {
        Write-Error "Failed to execute Teams Uninstaller: $($_.Exception.Message)"
        exit 1
    }
} else {
    Write-Error "Script not found at: $LocalScriptPath"
    exit 1
}

Write-Host ""
Write-Host "=== Launcher completed ===" -ForegroundColor Cyan
