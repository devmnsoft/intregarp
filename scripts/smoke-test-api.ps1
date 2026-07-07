param([string]$ApiUrl='http://localhost:5000')
$ErrorActionPreference='Stop'
Invoke-RestMethod "$ApiUrl/api/health"
Invoke-WebRequest "$ApiUrl/swagger/index.html" -UseBasicParsing | Out-Null
Invoke-RestMethod "$ApiUrl/api/validation/release-candidate/status"
