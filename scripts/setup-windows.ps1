$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
dotnet restore
Write-Host "Configure a variável ConnectionStrings__IntegraRP se seu PostgreSQL local usar credenciais diferentes."
