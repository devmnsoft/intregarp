$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$manifestPath = Join-Path $root "database/migration_manifest.json"
$manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
$migrationRoot = Join-Path $root "database/migrations"
$required = @("ordem","arquivo","versao","descricao","modulo","presente_no_script_completop","status","observacoes")
$known = @{}
$parts = [System.Collections.Generic.List[string]]::new()
foreach ($entry in ($manifest.migrations | Sort-Object ordem)) {
  foreach ($property in $required) { if ($null -eq $entry.PSObject.Properties[$property]) { throw "Contrato inválido em $($entry.arquivo): $property ausente." } }
  if ($known.ContainsKey($entry.arquivo)) { throw "Migration duplicada: $($entry.arquivo)" }
  $known[$entry.arquivo] = $true
  $path = Join-Path $migrationRoot $entry.arquivo
  if (-not (Test-Path -LiteralPath $path)) { throw "Migration ausente: $($entry.arquivo)" }
  if (-not $entry.presente_no_script_completop) { continue }
  $text = (Get-Content -Raw -LiteralPath $path) -replace "`r`n?", "`n"
  $text = (($text -split "`n") | Where-Object { $_.Trim().ToUpperInvariant() -notin @("BEGIN;","COMMIT;") }) -join "`n"
  if ($text -match '(?i)\bSET\s+(LOCAL\s+)?search_path\b') { throw "search_path proibido em $($entry.arquivo)" }
  if ($text -match '(?i)(^|\s)(public|integra|dbo)\.') { throw "Schema proibido em $($entry.arquivo)" }
  $parts.Add("-- >>> $($entry.arquivo)`n$($text.Trim())`n-- <<< $($entry.arquivo)`n")
}
$extras = Get-ChildItem -LiteralPath $migrationRoot -Filter '*.sql' | Where-Object { -not $known.ContainsKey($_.Name) }
if ($extras) { throw "Migration excedente: $($extras.Name -join ', ')" }
$body = "BEGIN;`n`n$($parts -join "`n")`nCOMMIT;`n"
$sha = [System.Security.Cryptography.SHA256]::Create()
try { $checksum = [Convert]::ToHexString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($body))).ToLowerInvariant() } finally { $sha.Dispose() }
$generatedAt = [DateTimeOffset]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ')
$header = @"
-- Produto: IntegraRP
-- Versão: $($manifest.gerado_para)
-- Data UTC: $generatedAt
-- PostgreSQL: 16
-- Schema: integrarp
-- Checksum SHA-256 do corpo transacional: $checksum
-- Contrato: $($manifest.contrato)
-- Número de migrations: $($parts.Count)
-- Instruções: executar via psql com ON_ERROR_STOP=1.
-- Aviso: este script não cria usuário com senha nem armazena credenciais.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

"@
$content = ($header -replace "`r`n?", "`n") + $body
$utf8 = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText((Join-Path $root 'database/script_completop.sql'), $content, $utf8)
[IO.File]::WriteAllText((Join-Path $root 'database/scriptcompleto.sql'), $content, $utf8)
Write-Host "Script v1.32 gerado com $($parts.Count) migrations; SHA-256 $checksum"
