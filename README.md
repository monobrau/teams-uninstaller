# Microsoft Teams Uninstaller

A PowerShell script designed to uninstall older versions of Microsoft Teams from user profiles on Windows systems.

## Overview

This script helps system administrators clean up older versions of Microsoft Teams that may be installed in user profiles. It can target specific user profiles or process all user profiles on the system.

## Features

- **Comprehensive Detection**: Finds Teams installations in various user profile locations
- **Version Identification**: Attempts to identify installed Teams versions
- **Process Management**: Stops running Teams processes before removal
- **Registry Cleanup**: Removes Teams-related registry entries
- **Logging**: Detailed logging with timestamps
- **Safety Features**: WhatIf mode for testing, confirmation prompts
- **Flexible Targeting**: Can target specific users or all users

## Prerequisites

- Windows PowerShell 5.1 or later
- Administrator privileges (recommended for full functionality)
- Access to user profile directories

## Usage

### Basic Usage

```powershell
# Show what would be uninstalled (dry run)
.\Uninstall-TeamsVersions.ps1 -WhatIf

# Uninstall from all user profiles with confirmation
.\Uninstall-TeamsVersions.ps1

# Uninstall from all user profiles without confirmation
.\Uninstall-TeamsVersions.ps1 -Force
```

### Targeting Specific Users

```powershell
# Target a specific user profile
.\Uninstall-TeamsVersions.ps1 -UserProfile "C:\Users\jdoe" -WhatIf

# Force uninstall from specific user
.\Uninstall-TeamsVersions.ps1 -UserProfile "C:\Users\jdoe" -Force
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

## What the Script Does

1. **Scans** user profile directories for Teams installations
2. **Identifies** Teams versions where possible
3. **Stops** running Teams processes
4. **Removes** Teams directories and files
5. **Cleans** registry entries
6. **Logs** all operations with timestamps

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

### Example 1: Dry Run on All Users
```powershell
.\Uninstall-TeamsVersions.ps1 -WhatIf
```

### Example 2: Force Uninstall All Users
```powershell
.\Uninstall-TeamsVersions.ps1 -Force
```

### Example 3: Target Specific User
```powershell
.\Uninstall-TeamsVersions.ps1 -UserProfile "C:\Users\jdoe" -Force
```

### Example 4: Custom Log Location
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

## Version History

- **v1.0**: Initial release with basic uninstall functionality

## Support

For issues or questions:
1. Check the log file for error details
2. Verify you have appropriate permissions
3. Test with `-WhatIf` parameter first

## License

This script is provided as-is for administrative use. Use at your own risk and test thoroughly in your environment.
