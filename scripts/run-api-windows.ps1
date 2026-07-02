$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
dotnet run --project src\IntegraRP.Api\IntegraRP.Api.csproj
