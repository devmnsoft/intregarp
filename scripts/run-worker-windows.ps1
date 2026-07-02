$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
dotnet run --project src\IntegraRP.Worker\IntegraRP.Worker.csproj
