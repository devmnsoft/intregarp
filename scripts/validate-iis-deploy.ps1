param([string]$ApiUrl='http://localhost:5000',[string]$WebUrl='http://localhost:8080')
$ErrorActionPreference='Stop'; Invoke-WebRequest "$ApiUrl/swagger/index.html" -UseBasicParsing | Out-Null; Invoke-WebRequest $WebUrl -UseBasicParsing | Out-Null
