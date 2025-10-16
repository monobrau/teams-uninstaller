# ScreenConnect One-Liner for MS Teams Uninstaller
# Copy and paste this entire block into ScreenConnect's PowerShell command

# One-liner to download and execute MS Teams Uninstaller from GitHub
$url = "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1"; $temp = "$env:TEMP\TeamsUninstaller.ps1"; if (-not (Test-Path (Split-Path $temp))) { New-Item -Path (Split-Path $temp) -ItemType Directory -Force | Out-Null }; try { Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $temp; & $temp -WhatIf } catch { Write-Error "Failed to download or execute script: $($_.Exception.Message)" }
