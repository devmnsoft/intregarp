#!/usr/bin/env python3
"""Gera e verifica deterministicamente o instalador canônico IntegraRP v1.60.2."""
from pathlib import Path
import hashlib, re
ROOT = Path(__file__).resolve().parent.parent
DB, CANONICAL = ROOT / "database", ROOT / "database" / "canonical"
FILES = [f"{n:02d}_{name}.sql" for n, name in enumerate(("preflight", "schema", "tables", "constraints", "indexes", "functions_triggers", "views", "parameters", "identity_seed", "business_seed", "migration_ledger", "final_validation"), 1)]
CRITICAL = {
 "processo_definicao": {"id","processo_definicao_id","tenant_id","codigo","nome","descricao","modulo_origem","setor_dono_id","status","versao_publicada_id","metadata_json","criado_em","atualizado_em","excluido_em"},
 "usuario": {"id","tenant_id","email","nome","status","senha_hash","bloqueado_ate","excluido_em"},
 "usuario_credencial": {"tenant_id","usuario_id","password_hash"},
 "pedido": {"id","tenant_id","cliente_id","status","valor_total"},
 "produto": {"id","tenant_id","codigo","nome","preco"},
 "tarefa": {"id","tenant_id","titulo","status"},
 "outbox_evento": {"id","tenant_id","tipo","payload_json","status"},
 "faturamento_pendente": {"id","tenant_id","pedido_id","status"},
}
missing = [name for name in FILES if not (CANONICAL / name).is_file()]
if missing: raise SystemExit(f"Fases canônicas ausentes: {missing}")
parts=[]
for name in FILES:
 raw=(CANONICAL/name).read_bytes()
 if raw.startswith(b"\xef\xbb\xbf"): raise SystemExit(f"BOM proibido: {name}")
 try: sql=raw.decode("utf-8")
 except UnicodeDecodeError as exc: raise SystemExit(f"UTF-8 inválido: {name}: {exc}")
 sql=sql.replace("\r\n","\n").replace("\r","\n").rstrip()+"\n"
 if any(line.lstrip().startswith("\\") for line in sql.splitlines()): raise SystemExit(f"Metacomando psql proibido: {name}")
 parts.append(f"-- >>> canonical/{name}\n{sql}-- <<< canonical/{name}\n")
body="\n".join(parts)
for forbidden in ("-- >>> 000", "database/migrations/"):
 if forbidden in body: raise SystemExit(f"Conteúdo histórico proibido: {forbidden}")
tables_sql=(CANONICAL/"03_tables.sql").read_text(encoding="utf-8")
# processo_definicao precisa nascer completo antes do primeiro seed/view Flow.
m=re.search(r"CREATE\s+TABLE\s+IF\s+NOT\s+EXISTS\s+integrarp\.processo_definicao\s*\((.*?)\n\);", tables_sql, re.I|re.S)
process_columns={x.lower() for x in re.findall(r"^\s*([a-z_][a-z0-9_]*)\s+",m.group(1),re.I|re.M)} if m else set()
absent=CRITICAL["processo_definicao"]-process_columns
if absent: raise SystemExit(f"Contrato inicial incompleto integrarp.processo_definicao: {sorted(absent)}")
# Todo INSERT nomeia colunas; cada coluna deve fazer parte do DDL/ALTER canônico.
known={}
for table, definition in re.findall(r"CREATE\s+TABLE\s+IF\s+NOT\s+EXISTS\s+integrarp\.([a-z0-9_]+)\s*\((.*?)\);", body, re.I|re.S):
 known.setdefault(table.lower(),set()).update(x.lower() for x in re.findall(r"(?:^|,)\s*([a-z_][a-z0-9_]*)\s+",definition,re.I|re.M))
for table, changes in re.findall(r"ALTER\s+TABLE(?:\s+IF\s+EXISTS)?\s+integrarp\.([a-z0-9_]+)(.*?);",body,re.I|re.S):
 known.setdefault(table.lower(),set()).update(c.lower() for c in re.findall(r"ADD\s+COLUMN\s+IF\s+NOT\s+EXISTS\s+([a-z0-9_]+)",changes,re.I))
for table, required in CRITICAL.items():
 absent=required-known.get(table,set())
 if absent: raise SystemExit(f"Contrato canônico incompleto integrarp.{table}: {sorted(absent)}")
for table, cols in re.findall(r"INSERT\s+INTO\s+integrarp\.([a-z0-9_]+)\s*\(([^)]+)\)",body,re.I):
 absent={c.strip().lower() for c in cols.split(',')}-known.get(table.lower(),set())
 if absent: raise SystemExit(f"Seed integrarp.{table} usa colunas ausentes: {sorted(absent)}")
template_hash=hashlib.sha256(body.encode()).hexdigest()
body=body.replace("__INSTALLER_SHA256__",template_hash)
header="""-- Produto: IntegraRP\n-- Versão: v1.60.2\n-- PostgreSQL: 16\n-- Contrato: Banco Canônico Integrarp v1.60.2\n-- SQL PostgreSQL puro; execute externamente com ON_ERROR_STOP=1.\n-- Gerado exclusivamente de database/canonical; não editar este artefato.\n\n"""
content=(header+body).encode("utf-8")
for name in ("scriptcompleto.sql","script_completop.sql"): (DB/name).write_bytes(content)
if (DB/"scriptcompleto.sql").read_bytes() != (DB/"script_completop.sql").read_bytes(): raise SystemExit("Aliases gerados divergem")
print(f"canonical_files={len(FILES)}\nsha256={hashlib.sha256(content).hexdigest()}\nalias_identical=true")
