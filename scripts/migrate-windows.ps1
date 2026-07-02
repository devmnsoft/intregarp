$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
$env:IntegraRP__RunMigrations = "true"
dotnet run --project src\IntegraRP.Api\IntegraRP.Api.csproj
