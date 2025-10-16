# Simple ScreenConnect PowerShell Command
# Copy this entire block into ScreenConnect's PowerShell command window

# Set execution policy and download/run Teams uninstaller
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; $url = "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1"; $temp = "$env:TEMP\TeamsUninstaller.ps1"; try { Write-Host "Downloading Teams Uninstaller from GitHub..." -ForegroundColor Green; Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $temp; Write-Host "Script downloaded successfully. Running in WhatIf mode..." -ForegroundColor Green; & $temp -WhatIf } catch { Write-Error "Failed to download or execute script: $($_.Exception.Message)" }
