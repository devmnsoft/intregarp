param([string]$WebBaseUrl="http://localhost:8081")
$ErrorActionPreference="Stop"
Invoke-WebRequest "$WebBaseUrl" -UseBasicParsing | Out-Null
