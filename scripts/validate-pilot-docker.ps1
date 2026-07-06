$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

docker compose -f docker-compose.yml -f docker-compose.pilot.yml build
docker compose -f docker-compose.yml -f docker-compose.pilot.yml up -d postgres integrarp-api integrarp-web integrarp-worker
Start-Sleep -Seconds 15

Invoke-WebRequest -UseBasicParsing http://localhost:7001/api/health/live | Out-Null
Invoke-WebRequest -UseBasicParsing http://localhost:7001/api/health/ready | Out-Null
Invoke-WebRequest -UseBasicParsing http://localhost:7001/swagger | Out-Null
Invoke-WebRequest -UseBasicParsing http://localhost:5001 | Out-Null

docker compose -f docker-compose.yml -f docker-compose.pilot.yml ps
