param([string]$ApiBaseUrl="http://localhost:8080")
$ErrorActionPreference="Stop"
Invoke-RestMethod "$ApiBaseUrl/api/health" | Out-Null
Invoke-WebRequest "$ApiBaseUrl/swagger" -UseBasicParsing | Out-Null
Invoke-RestMethod "$ApiBaseUrl/api/validation/release-candidate/status" | Out-Null
