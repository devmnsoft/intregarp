param([string]$Configuration='Release',[string]$Output='C:\inetpub\integrarp-web')
$ErrorActionPreference='Stop'; dotnet publish src/IntegraRP.Web/IntegraRP.Web.csproj -c $Configuration -o $Output
