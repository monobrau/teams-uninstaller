# One-liner for Force mode
$url="https://raw.githubusercontent.com/monobrau/teams-uninstaller/main/Web-Simple.ps1"; $script=iwr $url -UseBasicParsing; iex $script.Content -Force
