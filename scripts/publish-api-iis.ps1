param([string]$Configuration='Release',[string]$Output='C:\inetpub\integrarp-api')
$ErrorActionPreference='Stop'; dotnet publish src/IntegraRP.Api/IntegraRP.Api.csproj -c $Configuration -o $Output
