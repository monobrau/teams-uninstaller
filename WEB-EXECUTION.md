# Web Execution Guide

This guide shows how to run the MS Teams Uninstaller directly from GitHub without downloading files locally.

## Quick Start

### Test Mode (WhatIf) - Safe to run
```powershell
$url="https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Execute-WhatIf.ps1"; $temp="$env:TEMP\Web-Execute-WhatIf.ps1"; Invoke-WebRequest $url -UseBasicParsing -OutFile $temp; & $temp
```

### Execute Mode - Actually removes Teams
```powershell
$url="https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Execute-Force.ps1"; $temp="$env:TEMP\Web-Execute-Force.ps1"; Invoke-WebRequest $url -UseBasicParsing -OutFile $temp; & $temp
```

## How It Works

1. **Downloads** the latest Teams uninstaller from GitHub
2. **Validates** the downloaded script
3. **Executes** the Teams uninstaller with your parameters
4. **Cleans up** temporary files

## Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `-WhatIf` | Test mode - shows what would be done | `-WhatIf` |
| `-Force` | Execute without confirmation | `-Force` |
| `-UserProfile` | Target specific user profile | `-UserProfile "C:\Users\jdoe"` |

## Usage Examples

### ScreenConnect Integration
Copy and paste this into ScreenConnect's PowerShell command:

```powershell
iex (iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing).Content -WhatIf
```

### Remote Desktop
Run this in PowerShell on any Windows machine:

```powershell
iex (iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing).Content -Force
```

### Batch File
Create a `.bat` file with this content:

```batch
@echo off
powershell -ExecutionPolicy Bypass -Command "iex (iwr 'https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1' -UseBasicParsing).Content -Force"
pause
```

## Security Notes

- Scripts are downloaded over HTTPS from GitHub
- No persistent installation on the system
- Always test with `-WhatIf` first
- Run as Administrator for best results

## Troubleshooting

### Execution Policy Error
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
iex (iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing).Content -WhatIf
```

### Network Issues
Ensure the machine can access:
- `raw.githubusercontent.com`
- Port 443 (HTTPS)

### Permission Issues
Run PowerShell as Administrator for full functionality.

## GitHub Raw URLs

- **Web Launcher**: https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1
- **Main Script**: https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1

## One-Liner Commands

### Test Mode
```powershell
iex (iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing).Content -WhatIf
```

### Execute Mode
```powershell
iex (iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing).Content -Force
```

### Specific User
```powershell
iex (iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing).Content -UserProfile "C:\Users\jdoe" -Force
```
