# ScreenConnect Integration Guide

This guide explains how to use the MS Teams Uninstaller with ScreenConnect (ConnectWise Control).

## Quick Start - One-Liner Method

### For Testing (WhatIf mode):
```powershell
$url = "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1"; $temp = "$env:TEMP\TeamsUninstaller.ps1"; if (-not (Test-Path (Split-Path $temp))) { New-Item -Path (Split-Path $temp) -ItemType Directory -Force | Out-Null }; try { Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $temp; & $temp -WhatIf } catch { Write-Error "Failed to download or execute script: $($_.Exception.Message)" }
```

### For Actual Execution:
```powershell
$url = "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1"; $temp = "$env:TEMP\TeamsUninstaller.ps1"; if (-not (Test-Path (Split-Path $temp))) { New-Item -Path (Split-Path $temp) -ItemType Directory -Force | Out-Null }; try { Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $temp; & $temp -Force } catch { Write-Error "Failed to download or execute script: $($_.Exception.Message)" }
```

### For Specific User Profile:
```powershell
$url = "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1"; $temp = "$env:TEMP\TeamsUninstaller.ps1"; $user = "C:\Users\jdoe"; if (-not (Test-Path (Split-Path $temp))) { New-Item -Path (Split-Path $temp) -ItemType Directory -Force | Out-Null }; try { Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $temp; & $temp -UserProfile $user -Force } catch { Write-Error "Failed to download or execute script: $($_.Exception.Message)" }
```

## Advanced Method - Launcher Script

### Step 1: Download the Launcher
```powershell
$launcherUrl = "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Launch-TeamsUninstaller.ps1"
$launcherPath = "$env:TEMP\Launch-TeamsUninstaller.ps1"
Invoke-WebRequest -Uri $launcherUrl -UseBasicParsing -OutFile $launcherPath
```

### Step 2: Execute the Launcher
```powershell
& $launcherPath -WhatIf
```

## ScreenConnect Implementation Steps

### Method 1: Direct PowerShell Command
1. Open ScreenConnect session
2. Navigate to **Commands** → **PowerShell**
3. Copy and paste one of the one-liners above
4. Click **Execute**

### Method 2: Custom Command
1. Go to **Commands** → **Custom Commands**
2. Create new command with these details:
   - **Name**: `MS Teams Uninstaller`
   - **Command**: `powershell.exe`
   - **Arguments**: `-ExecutionPolicy Bypass -Command "& { $url = 'https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1'; $temp = '$env:TEMP\TeamsUninstaller.ps1'; if (-not (Test-Path (Split-Path $temp))) { New-Item -Path (Split-Path $temp) -ItemType Directory -Force | Out-Null }; try { Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $temp; & $temp -WhatIf } catch { Write-Error 'Failed to download or execute script: ' + $_.Exception.Message } }"`
3. Save and assign to appropriate groups

### Method 3: Batch File
1. Create a batch file with this content:
```batch
@echo off
powershell.exe -ExecutionPolicy Bypass -Command "& { $url = 'https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1'; $temp = '$env:TEMP\TeamsUninstaller.ps1'; if (-not (Test-Path (Split-Path $temp))) { New-Item -Path (Split-Path $temp) -ItemType Directory -Force | Out-Null }; try { Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $temp; & $temp -Force } catch { Write-Error 'Failed to download or execute script: ' + $_.Exception.Message } }"
pause
```

## Parameters Reference

| Parameter | Description | Example |
|-----------|-------------|---------|
| `-WhatIf` | Test mode - shows what would be done | `& $temp -WhatIf` |
| `-Force` | Execute without confirmation | `& $temp -Force` |
| `-UserProfile` | Target specific user profile | `& $temp -UserProfile "C:\Users\jdoe" -Force` |

## GitHub Raw URLs

- **Main Script**: https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1
- **Launcher Script**: https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Launch-TeamsUninstaller.ps1

## Troubleshooting

### Common Issues:
1. **Execution Policy**: Use `-ExecutionPolicy Bypass` in PowerShell commands
2. **Network Access**: Ensure the target machine can access GitHub
3. **Permissions**: Run as Administrator for best results
4. **Antivirus**: May block downloaded scripts - add exception if needed

### Error Messages:
- `Failed to download script`: Check network connectivity to GitHub
- `Access denied`: Run as Administrator
- `Execution policy`: Use `-ExecutionPolicy Bypass`

## Security Considerations

- Scripts are downloaded from GitHub over HTTPS
- No persistent installation - runs from temp directory
- Always test with `-WhatIf` first
- Review script source before execution

## Logging

The script creates detailed logs in:
- Default: `%TEMP%\TeamsUninstall_YYYYMMDD_HHMMSS.log`
- Custom: Specify with `-LogPath` parameter

## Best Practices

1. **Always test first** with `-WhatIf` parameter
2. **Run as Administrator** for full functionality
3. **Check logs** after execution
4. **Backup important data** before running
5. **Use specific user targeting** when possible

## Support

For issues or questions:
- Check the generated log files
- Verify network connectivity to GitHub
- Test with `-WhatIf` parameter first
- Review PowerShell execution policy settings
