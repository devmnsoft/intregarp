#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/database/migration_manifest.json"
OUT="$ROOT/database/script_completop.sql"
LEGACY="$ROOT/database/scriptcompleto.sql"
LOG="$ROOT/artifacts/v120/database/script_completop_generation.log"
mkdir -p "$(dirname "$LOG")"
python3 - <<'PY' "$ROOT" "$MANIFEST" "$OUT" "$LEGACY" "$LOG"
import json, re, sys, hashlib
from pathlib import Path
root, manifest_path, out, legacy, log = map(Path, sys.argv[1:])
manifest=json.loads(manifest_path.read_text())
required={"ordem","arquivo","versao","descricao","modulo","presente_no_script_completop","status","observacoes"}
files={p.name for p in (root/'database/migrations').glob('*.sql')}
seen=[]; parts=[]; included=[]
for e in manifest.get('migrations',[]):
    keys=set(e.keys())
    if not required.issubset(keys): raise SystemExit(f"Contrato inválido: {e}")
    if e['arquivo'] not in files: raise SystemExit(f"Migration ausente: {e['arquivo']}")
    if e['arquivo'] in seen: raise SystemExit(f"Migration duplicada: {e['arquivo']}")
    seen.append(e['arquivo'])
extra=files-set(seen)
if extra: raise SystemExit(f"Migration excedente no diretório: {sorted(extra)}")
for e in sorted(manifest['migrations'], key=lambda x:x['ordem']):
    if not e['presente_no_script_completop']: continue
    path=root/'database/migrations'/e['arquivo']
    text=path.read_text().replace('\r\n','\n').replace('\r','\n')
    lines=[ln for ln in text.splitlines() if ln.strip().upper() not in ('BEGIN;','COMMIT;')]
    text='\n'.join(lines).strip()+"\n"
    if re.search(r'\bSET\s+(LOCAL\s+)?search_path\b', text, re.I): raise SystemExit(f"search_path proibido em {e['arquivo']}")
    if re.search(r'(^|\s)(public|integra|dbo)\.', text, re.I): raise SystemExit(f"Schema proibido em {e['arquivo']}")
    if re.search(r'(?m)^\s*VALUES\s*\(', text) and re.search(r'(?m)^\s*ON\s+CONFLICT\s*\(version\)', text): raise SystemExit(f"Bloco órfão provável em {e['arquivo']}")
    parts.append(f"-- >>> {e['arquivo']}\n{text}\n-- <<< {e['arquivo']}\n")
    included.append(e['arquivo'])
body="BEGIN;\n\n"+"\n".join(parts)+"\nCOMMIT;\n"
checksum=hashlib.sha256(body.encode('utf-8')).hexdigest()
header=f"""-- Produto: IntegraRP
-- Versão: v1.24
-- Data de geração: 2026-07-21
-- PostgreSQL: 16
-- Schema: integrarp
-- Checksum SHA-256 do corpo transacional: {checksum}
-- Número de migrations: {len(included)}
-- Instruções: executar no pgAdmin Query Tool ou via psql -X "$DATABASE_URL" --set ON_ERROR_STOP=1 --file database/script_completop.sql.
-- Aviso: este script não cria usuário com senha nem armazena credenciais.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

"""
content=header+body
out.write_text(content, encoding='utf-8', newline='\n')
legacy.write_text(content, encoding='utf-8', newline='\n')
log.write_text("Script gerado: database/script_completop.sql\nChecksum corpo: "+checksum+"\nMigrations incluídas:\n"+"\n".join(included)+"\n", encoding='utf-8')
PY
