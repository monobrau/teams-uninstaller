# One-liner that works reliably in both PowerShell versions
# Download and execute Web-Final.ps1 with parameters

$url="https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Final.ps1"; $temp="$env:TEMP\Web-Final.ps1"; Invoke-WebRequest $url -UseBasicParsing -OutFile $temp; & $temp -WhatIf
