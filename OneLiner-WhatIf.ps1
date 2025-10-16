# One-liner for WhatIf mode
$url="https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Simple.ps1"; $script=iwr $url -UseBasicParsing; iex $script.Content -WhatIf
