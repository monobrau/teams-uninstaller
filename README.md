# Microsoft Teams Uninstaller

A PowerShell script designed to uninstall older versions of Microsoft Teams from user profiles on Windows systems.

## Overview

This script helps system administrators clean up Microsoft Teams versions older than 1.7x that may be installed in user profiles. It can target specific user profiles or process all user profiles on the system. Teams versions 1.7x and newer are preserved.

## Features

- **Version Filtering**: Only removes Teams versions older than 1.7x
- **Comprehensive Detection**: Finds Teams installations in various user profile locations
- **Version Identification**: Attempts to identify installed Teams versions
- **Process Management**: Stops running Teams processes before removal
- **Registry Cleanup**: Removes Teams-related registry entries
- **Logging**: Detailed logging with timestamps
- **Safety Features**: WhatIf mode for testing, confirmation prompts
- **Flexible Targeting**: Can target specific users or all users
- **Web Execution**: Run directly from GitHub without downloading files
- **ScreenConnect Ready**: One-liner commands for remote management tools

## Prerequisites

- Windows PowerShell 5.1 or later
- Administrator privileges (recommended for full functionality)
- Access to user profile directories

## Usage

### 🌐 Web Execution (Recommended)

Run directly from GitHub without downloading files:

```powershell
# Test mode (safe to run)
$script = iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Runner.ps1" -UseBasicParsing; iex $script.Content -WhatIf

# Execute mode (actually removes Teams)
$script = iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Runner.ps1" -UseBasicParsing; iex $script.Content -Force

# Target specific user
$script = iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Runner.ps1" -UseBasicParsing; iex $script.Content -UserProfile "C:\Users\jdoe" -Force
```

### 📁 Local Usage

If you prefer to download and run locally:

```powershell
# Show what would be uninstalled (dry run)
.\Uninstall-TeamsVersions.ps1 -WhatIf

# Uninstall from all user profiles with confirmation
.\Uninstall-TeamsVersions.ps1

# Uninstall from all user profiles without confirmation
.\Uninstall-TeamsVersions.ps1 -Force
```

### 🎯 ScreenConnect Integration

Perfect for remote management tools:

```powershell
# Copy and paste this into ScreenConnect's PowerShell command
$script = iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Runner.ps1" -UseBasicParsing; iex $script.Content -WhatIf
```

### 📋 Batch File Creation

Create a `.bat` file for easy execution:

```batch
@echo off
powershell -ExecutionPolicy Bypass -Command "$script = iwr 'https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Runner.ps1' -UseBasicParsing; iex $script.Content -Force"
pause
```

### Custom Logging

```powershell
# Specify custom log file location
.\Uninstall-TeamsVersions.ps1 -LogPath "C:\Logs\TeamsUninstall.log" -Force
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `UserProfile` | String | No | Specific user profile path to target |
| `Force` | Switch | No | Skip confirmation prompts |
| `WhatIf` | Switch | No | Show what would be done without executing |
| `LogPath` | String | No | Custom log file path (default: timestamped file) |

## Version Filtering

The script only removes Teams versions **older than 1.7x**:

- ✅ **Removes**: Teams 1.6.x and older
- ✅ **Removes**: Teams with unknown/unreadable versions (assumes old)
- ❌ **Preserves**: Teams 1.7.x and newer
- ❌ **Preserves**: Teams 2.x and newer

### Version Examples:
- `1.8.00.21151` → **Preserved** (1.7x or newer)
- `1.6.00.12345` → **Removed** (older than 1.7x)
- `1.7.00.98765` → **Preserved** (1.7x or newer)
- `Unknown` → **Removed** (assumes old)

## What the Script Does

1. **Scans** user profile directories for Teams installations
2. **Identifies** Teams versions where possible
3. **Filters** by version (only processes versions older than 1.7x)
4. **Stops** running Teams processes
5. **Removes** Teams directories and files
6. **Cleans** registry entries
7. **Logs** all operations with timestamps

## Installation Locations Scanned

The script checks these common Teams installation locations:
- `%USERPROFILE%\AppData\Local\Microsoft\Teams`
- `%USERPROFILE%\AppData\Local\Microsoft\Teams\current`
- `%USERPROFILE%\AppData\Roaming\Microsoft\Teams`
- `%USERPROFILE%\AppData\Local\Microsoft\Teams\Update.exe`

## Registry Cleanup

The script removes these registry entries:
- `HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*Teams*`
- `HKCU:\Software\Microsoft\Windows\CurrentVersion\Run\Teams*`
- `HKCU:\Software\Microsoft\Teams`

## Logging

The script creates detailed logs including:
- Timestamp for each operation
- User profile being processed
- Teams installations found
- Operations performed
- Errors encountered

Log files are created in the script directory with format: `TeamsUninstall_YYYYMMDD_HHMMSS.log`

## Examples

### 🌐 Web Execution Examples

#### Test Mode (Safe)
```powershell
iex (iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing).Content -WhatIf
```

#### Execute Mode
```powershell
iex (iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing).Content -Force
```

#### Target Specific User
```powershell
iex (iwr "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing).Content -UserProfile "C:\Users\jdoe" -Force
```

### 📁 Local Execution Examples

#### Dry Run on All Users
```powershell
.\Uninstall-TeamsVersions.ps1 -WhatIf
```

#### Force Uninstall All Users
```powershell
.\Uninstall-TeamsVersions.ps1 -Force
```

#### Target Specific User
```powershell
.\Uninstall-TeamsVersions.ps1 -UserProfile "C:\Users\jdoe" -Force
```

#### Custom Log Location
```powershell
.\Uninstall-TeamsVersions.ps1 -Force -LogPath "C:\Admin\TeamsCleanup.log"
```

## Safety Considerations

- **Always test with `-WhatIf` first** to see what would be removed
- **Backup important data** before running in production
- **Run as Administrator** for best results
- **Review logs** after execution to verify success

## Troubleshooting

### Common Issues

1. **Access Denied**: Run as Administrator
2. **Process Won't Stop**: Teams may be in use; close manually first
3. **Registry Access**: Some registry entries may require elevated privileges

### Log Analysis

Check the generated log file for:
- `[ERROR]` entries for failed operations
- `[WARN]` entries for non-critical issues
- `[INFO]` entries for successful operations

## Quick Start URLs

- **Web Launcher**: https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1
- **Main Script**: https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Uninstall-TeamsVersions.ps1
- **GitHub Repository**: https://github.com/monobrau/teams-uninstaller

## Version History

- **v2.0**: Added web execution capabilities and ScreenConnect integration
- **v1.0**: Initial release with basic uninstall functionality

## Support

For issues or questions:
1. Check the log file for error details
2. Verify you have appropriate permissions
3. Test with `-WhatIf` parameter first

## License

This script is provided as-is for administrative use. Use at your own risk and test thoroughly in your environment.
