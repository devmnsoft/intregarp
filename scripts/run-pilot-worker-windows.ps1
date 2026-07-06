$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
$env:DOTNET_ENVIRONMENT = 'Development'
dotnet run --project src/IntegraRP.Worker/IntegraRP.Worker.csproj
