param([string]$ApiBaseUrl="http://localhost:8080",[string]$WebBaseUrl="http://localhost:8081")
$ErrorActionPreference="Stop"
docker compose down -v
docker compose build
docker compose up -d
Start-Sleep -Seconds 20
docker compose ps
Invoke-RestMethod "$ApiBaseUrl/api/health" | Out-Null
Invoke-WebRequest "$WebBaseUrl" -UseBasicParsing | Out-Null
Invoke-RestMethod "$ApiBaseUrl/api/validation/flow/customer-full-journey" | Out-Null
docker compose logs worker --tail=120
Write-Host "Docker release validation concluída."
