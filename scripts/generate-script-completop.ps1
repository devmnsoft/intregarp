$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$ManifestPath = Join-Path $Root "database/migration_manifest.json"
$Out = Join-Path $Root "database/script_completop.sql"
$Legacy = Join-Path $Root "database/scriptcompleto.sql"
$Log = Join-Path $Root "artifacts/v120/database/script_completop_generation.log"
New-Item -ItemType Directory -Force -Path (Split-Path $Log) | Out-Null
$manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
$required = @('ordem','arquivo','versao','descricao','modulo','presente_no_script_completop','status','observacoes')
$files = Get-ChildItem (Join-Path $Root 'database/migrations') -Filter *.sql | ForEach-Object Name
$seen = New-Object System.Collections.Generic.List[string]
$parts = New-Object System.Collections.Generic.List[string]
$included = New-Object System.Collections.Generic.List[string]
foreach ($e in $manifest.migrations) {
  foreach ($name in $required) { if (-not ($e.PSObject.Properties.Name -contains $name)) { throw "Contrato inválido: $($e.arquivo): $name" } }
  if ($files -notcontains $e.arquivo) { throw "Migration ausente: $($e.arquivo)" }
  if ($seen -contains $e.arquivo) { throw "Migration duplicada: $($e.arquivo)" }
  $seen.Add($e.arquivo)
}
$extra = $files | Where-Object { $seen -notcontains $_ }
if ($extra) { throw "Migration excedente no diretório: $($extra -join ', ')" }
foreach ($e in ($manifest.migrations | Sort-Object ordem)) {
  if (-not $e.presente_no_script_completop) { continue }
  $path = Join-Path $Root "database/migrations/$($e.arquivo)"
  $lines = (Get-Content $path -Raw).Replace("`r`n","`n").Replace("`r","`n").Split("`n") | Where-Object { $_.Trim().ToUpperInvariant() -notin @('BEGIN;','COMMIT;') }
  $text = (($lines -join "`n").Trim() + "`n")
  if ($text -match '\bSET\s+(LOCAL\s+)?search_path\b') { throw "search_path proibido em $($e.arquivo)" }
  if ($text -match '(^|\s)(public|integra|dbo)\.') { throw "Schema proibido em $($e.arquivo)" }
  if (($text -match '(?m)^\s*VALUES\s*\(') -and ($text -match '(?m)^\s*ON\s+CONFLICT\s*\(version\)')) { throw "Bloco órfão provável em $($e.arquivo)" }
  $parts.Add("-- >>> $($e.arquivo)`n$text`n-- <<< $($e.arquivo)`n")
  $included.Add($e.arquivo)
}
$body = "BEGIN;`n`n" + ($parts -join "`n") + "`nCOMMIT;`n"
$bytes = [Text.Encoding]::UTF8.GetBytes($body)
$sha256 = [System.Security.Cryptography.SHA256]::Create()
try { $hashBytes = $sha256.ComputeHash($bytes) }
finally { $sha256.Dispose() }
$sha = [System.BitConverter]::ToString($hashBytes).Replace('-','').ToLowerInvariant()
$header = "-- Produto: IntegraRP`n-- Versão: v1.20`n-- Data de geração: 2026-07-21`n-- PostgreSQL suportado: 16`n-- Schema: integrarp`n-- Checksum SHA-256 do corpo transacional: $sha`n-- Número de migrations: $($included.Count)`n-- Instruções: executar no pgAdmin Query Tool ou via psql -X `"`$DATABASE_URL`" --set ON_ERROR_STOP=1 --file database/script_completop.sql.`n-- Aviso: este script não cria usuário com senha nem armazena credenciais.`n`nCREATE EXTENSION IF NOT EXISTS pgcrypto;`nCREATE SCHEMA IF NOT EXISTS integrarp;`n`n"
$content = $header + $body
[IO.File]::WriteAllText($Out,$content,[Text.UTF8Encoding]::new($false))
[IO.File]::WriteAllText($Legacy,$content,[Text.UTF8Encoding]::new($false))
[IO.File]::WriteAllText($Log,"Script gerado: database/script_completop.sql`nChecksum corpo: $sha`nMigrations incluídas:`n$($included -join "`n")`n",[Text.UTF8Encoding]::new($false))
