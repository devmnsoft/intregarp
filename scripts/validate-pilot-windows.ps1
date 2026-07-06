$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

Write-Host '== IntegraRP Piloto v1.0: validação Windows =='
dotnet restore
dotnet build --no-restore
dotnet test --no-build

if (Test-Path 'apps/IntegraRP.Mobile/package.json') {
    Push-Location 'apps/IntegraRP.Mobile'
    npm install
    npm run typecheck
    Pop-Location
}

Write-Host 'Valide manualmente após subir serviços:'
Write-Host '- API: http://localhost:7001/api/health/live'
Write-Host '- Ready: http://localhost:7001/api/health/ready'
Write-Host '- Swagger: http://localhost:7001/swagger'
Write-Host '- Web: http://localhost:5001'
