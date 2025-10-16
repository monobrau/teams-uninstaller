#Requires -Version 5.1
<#
.SYNOPSIS
    Uninstalls older versions of Microsoft Teams from user profiles

.DESCRIPTION
    This script identifies and uninstalls older versions of Microsoft Teams that are installed
    in user profiles. It supports both per-user and machine-wide installations.

.PARAMETER UserProfile
    Specific user profile to target. If not specified, processes all user profiles.

.PARAMETER WhatIf
    Shows what would be uninstalled without actually performing the uninstall.

.PARAMETER Force
    Forces uninstallation without prompting for confirmation.

.PARAMETER LogPath
    Path to log file. Defaults to script directory with timestamp.

.EXAMPLE
    .\Uninstall-TeamsVersions.ps1 -WhatIf
    Shows what would be uninstalled without actually doing it.

.EXAMPLE
    .\Uninstall-TeamsVersions.ps1 -UserProfile "C:\Users\jdoe" -Force
    Uninstalls Teams from specific user profile without prompting.

.EXAMPLE
    .\Uninstall-TeamsVersions.ps1 -Force
    Uninstalls Teams from all user profiles without prompting.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$UserProfile,
    
    [Parameter(Mandatory = $false)]
    [switch]$Force,
    
    [Parameter(Mandatory = $false)]
    [string]$LogPath = "$PSScriptRoot\TeamsUninstall_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
)

# Initialize logging
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Write-Host $logEntry
    Add-Content -Path $LogPath -Value $logEntry
}

# Check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Get Teams installation paths for a specific user
function Get-TeamsInstallations {
    param(
        [string]$ProfilePath
    )
    
    $installations = @()
    
    # Common Teams installation paths
    $teamsPaths = @(
        "$ProfilePath\AppData\Local\Microsoft\Teams",
        "$ProfilePath\AppData\Local\Microsoft\Teams\current",
        "$ProfilePath\AppData\Roaming\Microsoft\Teams",
        "$ProfilePath\AppData\Local\Microsoft\Teams\Update.exe"
    )
    
    foreach ($path in $teamsPaths) {
        if (Test-Path $path) {
            $version = "Unknown"
            $exePath = ""
            
            # Try to get version from Teams.exe
            $teamsExe = Get-ChildItem -Path $path -Filter "Teams.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($teamsExe) {
                try {
                    $versionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($teamsExe.FullName)
                    $version = $versionInfo.FileVersion
                    $exePath = $teamsExe.FullName
                }
                catch {
                    Write-Log "Could not get version info for $($teamsExe.FullName)" "WARN"
                }
            }
            
            $installations += [PSCustomObject]@{
                Path = $path
                Version = $version
                ExePath = $exePath
                Type = if ($path -like "*Update.exe") { "Updater" } else { "Application" }
            }
        }
    }
    
    return $installations
}

# Uninstall Teams for a specific user
function Remove-TeamsInstallation {
    param(
        [string]$ProfilePath,
        [string]$ProfileName
    )
    
    Write-Log "Processing user profile: $ProfileName ($ProfilePath)"
    
    $installations = Get-TeamsInstallations -ProfilePath $ProfilePath
    
    if ($installations.Count -eq 0) {
        Write-Log "No Teams installations found for $ProfileName" "INFO"
        return
    }
    
    foreach ($installation in $installations) {
        Write-Log "Found Teams installation: $($installation.Path) (Version: $($installation.Version))" "INFO"
        
        if ($PSCmdlet.ShouldProcess($installation.Path, "Remove Teams installation")) {
            try {
                # Stop Teams processes
                Write-Log "Stopping Teams processes for $ProfileName" "INFO"
                Get-Process -Name "Teams" -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "$ProfilePath\*" } | Stop-Process -Force -ErrorAction SilentlyContinue
                Get-Process -Name "TeamsMachineInstaller" -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "$ProfilePath\*" } | Stop-Process -Force -ErrorAction SilentlyContinue
                
                # Remove Teams directory
                if (Test-Path $installation.Path) {
                    Write-Log "Removing directory: $($installation.Path)" "INFO"
                    Remove-Item -Path $installation.Path -Recurse -Force -ErrorAction SilentlyContinue
                }
                
                # Remove registry entries
                $regPaths = @(
                    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*Teams*",
                    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run\Teams*",
                    "HKCU:\Software\Microsoft\Teams"
                )
                
                foreach ($regPath in $regPaths) {
                    try {
                        if (Test-Path $regPath) {
                            Write-Log "Removing registry entry: $regPath" "INFO"
                            Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
                        }
                    }
                    catch {
                        Write-Log "Could not remove registry entry $regPath : $($_.Exception.Message)" "WARN"
                    }
                }
                
                Write-Log "Successfully removed Teams installation: $($installation.Path)" "INFO"
            }
            catch {
                Write-Log "Error removing Teams installation $($installation.Path) : $($_.Exception.Message)" "ERROR"
            }
        }
    }
}

# Main execution
Write-Log "Starting Teams uninstaller script" "INFO"
Write-Log "Log file: $LogPath" "INFO"

# Check if running as administrator
if (-not (Test-Administrator)) {
    Write-Log "WARNING: Not running as administrator. Some operations may fail." "WARN"
}

# Get user profiles to process
$profilesToProcess = @()

if ($UserProfile) {
    if (Test-Path $UserProfile) {
        $profilesToProcess += [PSCustomObject]@{
            Path = $UserProfile
            Name = Split-Path $UserProfile -Leaf
        }
    }
    else {
        Write-Log "Specified user profile path does not exist: $UserProfile" "ERROR"
        exit 1
    }
}
else {
    # Get all user profiles
    $userProfiles = Get-ChildItem -Path "C:\Users" -Directory -ErrorAction SilentlyContinue
    foreach ($profile in $userProfiles) {
        $profilesToProcess += [PSCustomObject]@{
            Path = $profile.FullName
            Name = $profile.Name
        }
    }
}

Write-Log "Found $($profilesToProcess.Count) user profiles to process" "INFO"

# Process each profile
foreach ($profile in $profilesToProcess) {
    Remove-TeamsInstallation -ProfilePath $profile.Path -ProfileName $profile.Name
}

Write-Log "Teams uninstaller script completed" "INFO"
Write-Log "Log saved to: $LogPath" "INFO"
