param([string]$ConnectionString = $env:ConnectionStrings__IntegraRP)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$logDir = Join-Path $repo 'logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$log = Join-Path $logDir 'scriptcompleto-debug.log'
"IntegraRP scriptcompleto debug $(Get-Date -Format o)" | Set-Content $log
if (-not (Get-Command psql -ErrorAction SilentlyContinue)) { "psql não encontrado." | Tee-Object -FilePath $log -Append; exit 2 }
if ([string]::IsNullOrWhiteSpace($ConnectionString)) { $ConnectionString = 'postgresql://postgres:postgres@localhost:5432/postgres' }
$db = 'integrarp_debug'
& psql $ConnectionString -v ON_ERROR_STOP=1 -c "DROP DATABASE IF EXISTS $db;" 2>&1 | Tee-Object -FilePath $log -Append
& psql $ConnectionString -v ON_ERROR_STOP=1 -c "CREATE DATABASE $db;" 2>&1 | Tee-Object -FilePath $log -Append
$target = $ConnectionString -replace '/[^/?]+(\?.*)?$', "/$db`$1"
if ($target -eq $ConnectionString) { $target = "postgresql://postgres:postgres@localhost:5432/$db" }
foreach ($run in 1,2) {
  "Execução $run" | Tee-Object -FilePath $log -Append
  & psql $target -v ON_ERROR_STOP=1 -f (Join-Path $repo 'database/scriptcompleto.sql') 2>&1 | Tee-Object -FilePath $log -Append
  if ($LASTEXITCODE -ne 0) { "Falha na execução $run; ver linha e mensagem acima." | Tee-Object -FilePath $log -Append; exit $LASTEXITCODE }
}
& psql $target -v ON_ERROR_STOP=1 -f (Join-Path $repo 'database/validation/validate_scriptcompleto_v19.sql') 2>&1 | Tee-Object -FilePath $log -Append
exit $LASTEXITCODE
