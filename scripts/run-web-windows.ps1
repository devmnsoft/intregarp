$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
dotnet run --project src\IntegraRP.Web\IntegraRP.Web.csproj
