#!/usr/bin/env python3
"""Generate both complete database scripts deterministically from the manifest."""
import hashlib
import json
import os
import re
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
manifest = json.loads((ROOT / "database/migration_manifest.json").read_text(encoding="utf-8"))
required = {"ordem", "arquivo", "versao", "descricao", "modulo", "presente_no_script_completop", "status", "observacoes"}
migration_root = ROOT / "database/migrations"
actual = {path.name for path in migration_root.glob("*.sql")}
entries = manifest.get("migrations", [])
known: set[str] = set()
parts: list[str] = []
included: list[str] = []

orders = [entry.get("ordem") for entry in entries]
if len(orders) != len(set(orders)):
    raise SystemExit("Manifesto inválido: ordens duplicadas.")
for entry in entries:
    missing = required - set(entry)
    if missing:
        raise SystemExit(f"Contrato inválido em {entry.get('arquivo', '?')}: {sorted(missing)}")
    filename = entry["arquivo"]
    if filename in known:
        raise SystemExit(f"Migration duplicada: {filename}")
    known.add(filename)
    if filename not in actual:
        raise SystemExit(f"Migration ausente: {filename}")
extra = actual - known
if extra:
    raise SystemExit(f"Migration excedente no diretório: {sorted(extra)}")

for entry in sorted(entries, key=lambda item: item["ordem"]):
    if not entry["presente_no_script_completop"]:
        continue
    filename = entry["arquivo"]
    text = (migration_root / filename).read_text(encoding="utf-8").replace("\r\n", "\n").replace("\r", "\n")
    text = "\n".join(line for line in text.splitlines() if line.strip().upper() not in {"BEGIN;", "COMMIT;"}).strip() + "\n"
    if re.search(r"\bSET\s+(LOCAL\s+)?search_path\b", text, re.I):
        raise SystemExit(f"search_path proibido em {filename}")
    if re.search(r"(^|\s)(public|integra|dbo)\.", text, re.I):
        raise SystemExit(f"Schema proibido em {filename}")
    parts.append(f"-- >>> {filename}\n{text}\n-- <<< {filename}\n")
    included.append(filename)

body = "BEGIN;\n\n" + "\n".join(parts) + "\nCOMMIT;\n"
checksum = hashlib.sha256(body.encode()).hexdigest()
source_epoch = os.getenv("SOURCE_DATE_EPOCH")
if source_epoch:
    generated_at = datetime.fromtimestamp(int(source_epoch), timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
else:
    generated_at = manifest["generatedAtUtc"]
header = f'''-- Produto: IntegraRP
-- Versão: {manifest["gerado_para"]}
-- Data UTC: {generated_at}
-- PostgreSQL: 16
-- Schema: integrarp
-- Checksum SHA-256 do corpo transacional: {checksum}
-- Contrato: {manifest["contrato"]}
-- Número de migrations: {len(included)}
-- Instruções: executar via psql -X "$POSTGRES_URI" --set ON_ERROR_STOP=1 --file database/script_completop.sql.
-- Aviso: este script não cria usuário com senha nem armazena credenciais.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

'''
content = header + body
for filename in ("script_completop.sql", "scriptcompleto.sql"):
    (ROOT / "database" / filename).write_bytes(content.encode("utf-8"))
artifact_version = manifest["gerado_para"].replace(".", "")
log = ROOT / "artifacts" / artifact_version / "database/script_completop_generation.log"
log.parent.mkdir(parents=True, exist_ok=True)
log.write_text(f"Script gerado: database/script_completop.sql\nChecksum corpo: {checksum}\nMigrations incluídas:\n" + "\n".join(included) + "\n", encoding="utf-8", newline="\n")
print(f"Script {manifest['gerado_para']} gerado com {len(included)} migrations; SHA-256 {checksum}")
