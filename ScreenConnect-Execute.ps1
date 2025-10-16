# ScreenConnect PowerShell Command - ACTUAL EXECUTION
# Copy this entire block into ScreenConnect's PowerShell command window

# Set execution policy and download/run Teams uninstaller with Force
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; $url = "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1"; $temp = "$env:TEMP\TeamsUninstaller.ps1"; try { Write-Host "Downloading Teams Uninstaller from GitHub..." -ForegroundColor Green; Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $temp; Write-Host "Script downloaded successfully. Executing Teams uninstaller..." -ForegroundColor Green; & $temp -Force } catch { Write-Error "Failed to download or execute script: $($_.Exception.Message)" }
