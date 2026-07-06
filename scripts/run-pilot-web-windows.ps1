$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
$env:ASPNETCORE_ENVIRONMENT = 'Development'
$env:IntegraRP__ApiBaseUrl = 'http://localhost:7001'
dotnet run --project src/IntegraRP.Web/IntegraRP.Web.csproj --urls http://localhost:5001
