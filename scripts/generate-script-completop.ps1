$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$ManifestPath = Join-Path $Root "database/migration_manifest.json"
$Out = Join-Path $Root "database/script_completop.sql"
$Legacy = Join-Path $Root "database/scriptcompleto.sql"
$Log = Join-Path $Root "artifacts/v119/database/script_completop_generation.log"
New-Item -ItemType Directory -Force -Path (Split-Path $Log) | Out-Null
$manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
$required = @('ordem','arquivo','versao','descricao','modulo','presente_no_script_completop','status','observacoes')
$files = Get-ChildItem (Join-Path $Root 'database/migrations') -Filter *.sql | ForEach-Object Name
$seen = New-Object System.Collections.Generic.List[string]
$parts = New-Object System.Collections.Generic.List[string]
$included = New-Object System.Collections.Generic.List[string]
foreach ($e in $manifest.migrations) {
  $props = $e.PSObject.Properties.Name | Sort-Object
  if (@($props) -join ',' -ne @($required | Sort-Object) -join ',') { throw "Contrato inválido: $($e.arquivo)" }
  if ($files -notcontains $e.arquivo) { throw "Migration ausente: $($e.arquivo)" }
  $seen.Add($e.arquivo)
}
$extra = $files | Where-Object { $seen -notcontains $_ }
if ($extra) { throw "Migration excedente no diretório: $($extra -join ', ')" }
foreach ($e in ($manifest.migrations | Sort-Object ordem)) {
  if (-not $e.presente_no_script_completop) { continue }
  $path = Join-Path $Root "database/migrations/$($e.arquivo)"
  $lines = (Get-Content $path -Raw).Replace("`r`n","`n").Split("`n") | Where-Object { $_.Trim().ToUpperInvariant() -notin @('BEGIN;','COMMIT;') }
  $text = (($lines -join "`n").Trim() + "`n")
  if ($text -match '(^|\s)public\.') { throw "Schema public proibido em $($e.arquivo)" }
  $parts.Add("-- >>> $($e.arquivo)`n$text`n-- <<< $($e.arquivo)`n")
  $included.Add($e.arquivo)
}
$body = "BEGIN;`nSET LOCAL search_path = integrarp, pg_catalog;`n`n" + ($parts -join "`n") + "`nCOMMIT;`n"
$sha = [System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($body))).Replace('-','').ToLowerInvariant()
$header = "-- Produto: IntegraRP`n-- Versão: v1.19`n-- Data de geração: 2026-07-21`n-- Schema: integrarp`n-- Checksum SHA-256 do corpo transacional: $sha`n-- Instruções: executar no pgAdmin Query Tool ou via psql com ON_ERROR_STOP=1.`n-- Compatibilidade: PostgreSQL 16; SQL puro sem comandos específicos do psql.`n`nCREATE EXTENSION IF NOT EXISTS pgcrypto;`nCREATE SCHEMA IF NOT EXISTS integrarp;`n`n"
$content = $header + $body
[IO.File]::WriteAllText($Out,$content,[Text.UTF8Encoding]::new($false)); [IO.File]::WriteAllText($Legacy,$content,[Text.UTF8Encoding]::new($false))
[IO.File]::WriteAllText($Log,"Script gerado: database/script_completop.sql`nChecksum corpo: $sha`nMigrations incluídas:`n$($included -join "`n")`n",[Text.UTF8Encoding]::new($false))
