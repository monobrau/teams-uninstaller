# One-liner web execution for MS Teams Uninstaller
# This script can be executed directly from GitHub

# Download and execute the web launcher with parameters
$script = Invoke-WebRequest "https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Launcher.ps1" -UseBasicParsing
& ([scriptblock]::Create($script.Content)) -WhatIf
