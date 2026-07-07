param([string]$ApiUrl='http://localhost:5000')
$ErrorActionPreference='Stop'
Invoke-RestMethod "$ApiUrl/api/validation/worker/status"
