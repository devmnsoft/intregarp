#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/database/migration_manifest.json"
OUT="$ROOT/database/script_completop.sql"
LEGACY="$ROOT/database/scriptcompleto.sql"
LOG="$ROOT/artifacts/v119/database/script_completop_generation.log"
mkdir -p "$(dirname "$LOG")"
python3 - <<'PY' "$ROOT" "$MANIFEST" "$OUT" "$LEGACY" "$LOG"
import json, re, sys, hashlib
from pathlib import Path
root, manifest_path, out, legacy, log = map(Path, sys.argv[1:])
manifest=json.loads(manifest_path.read_text())
req={"ordem","arquivo","versao","descricao","modulo","presente_no_script_completop","status","observacoes"}
files={p.name for p in (root/'database/migrations').glob('*.sql')}
seen=[]
for e in manifest.get('migrations',[]):
    if set(e.keys())!=req: raise SystemExit(f"Contrato inválido: {e}")
    if e['arquivo'] not in files: raise SystemExit(f"Migration ausente: {e['arquivo']}")
    seen.append(e['arquivo'])
extra=files-set(seen)
if extra: raise SystemExit(f"Migration excedente no diretório: {sorted(extra)}")
parts=[]; included=[]
for e in sorted(manifest['migrations'], key=lambda x:x['ordem']):
    if not e['presente_no_script_completop']: continue
    text=(root/'database/migrations'/e['arquivo']).read_text().replace('\r\n','\n')
    # remove only top-level BEGIN/COMMIT lines
    lines=text.splitlines()
    lines=[ln for ln in lines if ln.strip().upper() not in ('BEGIN;','COMMIT;')]
    text='\n'.join(lines).strip()+"\n"
    if re.search(r'(^|\s)public\.', text, re.I): raise SystemExit(f"Schema public proibido em {e['arquivo']}")
    parts.append(f"-- >>> {e['arquivo']}\n{text}\n-- <<< {e['arquivo']}\n")
    included.append(e['arquivo'])
body="BEGIN;\nSET LOCAL search_path = integrarp, pg_catalog;\n\n"+"\n".join(parts)+"\nCOMMIT;\n"
checksum=hashlib.sha256(body.encode()).hexdigest()
header=f"""-- Produto: IntegraRP\n-- Versão: v1.19\n-- Data de geração: 2026-07-21\n-- Schema: integrarp\n-- Checksum SHA-256 do corpo transacional: {checksum}\n-- Instruções: executar no pgAdmin Query Tool ou via psql com ON_ERROR_STOP=1.\n-- Compatibilidade: PostgreSQL 16; SQL puro sem comandos específicos do psql.\n\nCREATE EXTENSION IF NOT EXISTS pgcrypto;\nCREATE SCHEMA IF NOT EXISTS integrarp;\n\n"""
content=header+body
out.write_text(content); legacy.write_text(content)
log.write_text("Script gerado: database/script_completop.sql\nChecksum corpo: "+checksum+"\nMigrations incluídas:\n"+"\n".join(included)+"\n")
PY
