$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
docker compose -f docker-compose.yml -f docker-compose.pilot.yml down -v
docker compose -f docker-compose.yml -f docker-compose.pilot.yml up -d --build
