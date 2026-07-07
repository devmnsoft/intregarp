param([string]$Configuration='Release',[string]$Output='C:\Services\IntegraRP.Worker')
$ErrorActionPreference='Stop'; dotnet publish src/IntegraRP.Worker/IntegraRP.Worker.csproj -c $Configuration -o $Output; Write-Host 'Crie/atualize o serviço com sc.exe ou PowerShell New-Service conforme docs.'
