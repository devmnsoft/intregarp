param([string]$ApiUrl='http://localhost:5000',[string]$WebUrl='http://localhost:8080')
$ErrorActionPreference='Stop'
docker compose down -v
docker compose build
docker compose up -d
$deadline=(Get-Date).AddMinutes(3)
do { try { Invoke-RestMethod "$ApiUrl/api/health" -TimeoutSec 5; $ok=$true } catch { Start-Sleep 5 } } until($ok -or (Get-Date) -gt $deadline)
if(-not $ok){ docker compose logs api; throw 'API health falhou' }
Invoke-WebRequest $WebUrl -UseBasicParsing -TimeoutSec 15 | Out-Null
Invoke-RestMethod "$ApiUrl/swagger/index.html" -TimeoutSec 15 | Out-Null
Invoke-RestMethod "$ApiUrl/api/validation/flow/customer-full-journey" -TimeoutSec 30 | Out-Null
docker compose logs worker --tail 100
