param([string]$ApiBaseUrl="http://localhost:8080")
$ErrorActionPreference="Stop"
Invoke-RestMethod "$ApiBaseUrl/api/validation/worker/status" | Out-Null
