$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
$env:ASPNETCORE_ENVIRONMENT = 'Development'
$env:IntegraRP__RunMigrations = 'true'
dotnet run --project src/IntegraRP.Api/IntegraRP.Api.csproj --urls http://localhost:7001
