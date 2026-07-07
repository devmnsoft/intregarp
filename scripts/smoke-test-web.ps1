param([string]$WebUrl='http://localhost:8080')
$ErrorActionPreference='Stop'
Invoke-WebRequest $WebUrl -UseBasicParsing | Out-Null
