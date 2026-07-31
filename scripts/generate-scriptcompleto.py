#!/usr/bin/env python3
"""Gera deterministicamente o script completo, seu alias e os contratos v1.49."""
from __future__ import annotations
import hashlib, json, re
from pathlib import Path

ROOT=Path(__file__).resolve().parent.parent
DB=ROOT/'database'; MIG=DB/'migrations'; MANIFEST=DB/'migration_manifest.json'
def sha(data: bytes)->str: return hashlib.sha256(data).hexdigest()
def normalized(path: Path)->str:
    raw=path.read_bytes()
    if raw.startswith(b'\xef\xbb\xbf'): raise SystemExit(f'BOM UTF-8 proibido: {path.relative_to(ROOT)}')
    try: text=raw.decode('utf-8')
    except UnicodeDecodeError as exc: raise SystemExit(f'UTF-8 inválido: {path}: {exc}')
    return text.replace('\r\n','\n').replace('\r','\n')
def definition(item: str)->str: return ' '.join(item.split())
def object_item(kind,name,origin,definition_text,module='Database',dependencies=None):
    canonical=definition(definition_text)
    return {'schema':'integrarp','name':name,'type':kind,'module':module,'originMigration':origin,'usedBy':['database/scriptcompleto.sql'],'required':True,'legacy':False,'active':True,'canonicalDefinition':canonical,'definitionChecksumSha256':sha(canonical.encode()),'dependencies':dependencies or []}

manifest=json.loads(normalized(MANIFEST)); entries=manifest.get('migrations',[])
required={'ordem','arquivo','versao','descricao','modulo','presente_no_script_completop','status','observacoes','checksum_sha256'}
actual={p.name for p in MIG.glob('*.sql')}; known=set(); orders=[]; parts=[]
for entry in entries:
    missing=required-entry.keys()
    if missing: raise SystemExit(f"Campos ausentes em {entry.get('arquivo','?')}: {sorted(missing)}")
    filename=entry['arquivo']; orders.append(entry['ordem'])
    if filename in known: raise SystemExit(f'Migration duplicada: {filename}')
    known.add(filename); path=MIG/filename
    if not path.is_file(): raise SystemExit(f'Migration ausente: {filename}')
    if sha(normalized(path).encode('utf-8')) != entry['checksum_sha256']: raise SystemExit(f'Checksum divergente: {filename}')
if orders != sorted(orders) or len(orders)!=len(set(orders)): raise SystemExit('Ordens do manifesto devem ser únicas e crescentes.')
if actual-known: raise SystemExit(f'Migrations extras: {sorted(actual-known)}')
for entry in entries:
    if not entry['presente_no_script_completop']: continue
    text=normalized(MIG/entry['arquivo'])
    # 0001 define a chave canônica tarefa.id; adia/corrige as views legadas sem alterar a migration histórica.
    if entry['arquivo'] == '0003_flow_bpmn_core.sql':
        text=text.replace('SELECT tenant_id, tarefa_id, codigo, titulo, status, prioridade, prazo_em FROM integrarp.tarefa', 'SELECT id AS tarefa_id, tenant_id, codigo, titulo, status, prioridade, prazo_em FROM integrarp.tarefa')
        text=text.replace('count(DISTINCT t.tarefa_id)', 'count(DISTINCT t.id)')
    # As views de tarefa só podem ser criadas após a reconciliação estrutural
    # aditiva de 0051. As migrations históricas permanecem imutáveis no disco.
    if entry['arquivo'] in {'0003_flow_bpmn_core.sql', '0050_v148_venda_execucao_vertical.sql'}:
        text=re.sub(r'CREATE\s+OR\s+REPLACE\s+VIEW\s+integrarp\.vw_flow_tarefas_(?:abertas|atrasadas)\s+AS\s+.*?;', '-- view de tarefa adiada para 0051', text, flags=re.I|re.S)
    text='\n'.join(line for line in text.splitlines() if line.strip().upper() not in {'BEGIN;','COMMIT;'}) .strip()+'\n'
    if re.search(r'\b(?:SET\s+(?:LOCAL\s+)?search_path|set_config\s*\(\s*[\'\"]search_path)',text,re.I): raise SystemExit(f"search_path proibido: {entry['arquivo']}")
    if re.search(r'(?<![\w])(?:public|integra|dbo)\.',text,re.I): raise SystemExit(f"Schema proibido: {entry['arquivo']}")
    parts.append((entry['arquivo'], f"-- >>> {entry['arquivo']}\n{text}\n-- <<< {entry['arquivo']}\n"))
# A instalação canônica respeita estritamente a ordem do manifesto. Reconciliações
# históricas não são promovidas nem executadas duas vezes.
canonical_compatibility='''-- >>> compatibilidade estrutural canônica (não é migration histórica)
ALTER TABLE IF EXISTS integrarp.processo_definicao ADD COLUMN IF NOT EXISTS processo_definicao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_versao ADD COLUMN IF NOT EXISTS processo_versao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_versao ADD COLUMN IF NOT EXISTS processo_definicao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_elemento ADD COLUMN IF NOT EXISTS processo_elemento_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_elemento ADD COLUMN IF NOT EXISTS processo_versao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_transicao ADD COLUMN IF NOT EXISTS processo_transicao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_transicao ADD COLUMN IF NOT EXISTS processo_versao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_instancia ADD COLUMN IF NOT EXISTS processo_instancia_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_instancia ADD COLUMN IF NOT EXISTS processo_definicao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_instancia ADD COLUMN IF NOT EXISTS processo_versao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_variavel ADD COLUMN IF NOT EXISTS processo_variavel_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_variavel ADD COLUMN IF NOT EXISTS processo_instancia_id uuid;
-- <<< compatibilidade estrutural canônica
'''
# 0001 cria as estruturas base legadas; a compatibilidade deve anteceder 0003 e
# seus índices canônicos. O bloco não altera o histórico nem a tabela de migrations.
base_parts=[part for filename,part in parts if filename == '0001_initial_integrarp.sql']
historical_parts=[part for filename,part in parts if filename != '0001_initial_integrarp.sql']
if len(base_parts) != 1: raise SystemExit('Migration base 0001 não encontrada uma única vez.')
body=base_parts[0]+'\n'+canonical_compatibility+'\n'+'\n'.join(historical_parts)
body_checksum=sha(body.encode())
lock_key=149_2026_0731
header=f'''-- Produto: IntegraRP
-- Versão: v1.49
-- PostgreSQL: 16
-- Schema: integrarp
-- Arquivo principal: database/scriptcompleto.sql
-- Quantidade de migrations: {len(entries)}
-- Data UTC determinística: {manifest['generatedAtUtc']}
-- Checksum SHA-256: {body_checksum}
-- Contrato: Banco Canônico Integrarp v1.49
-- Execução:
-- psql -X "$POSTGRES_URI" --set ON_ERROR_STOP=1 --file database/scriptcompleto.sql
-- Gerado automaticamente; não editar os arquivos de saída.
\\set ON_ERROR_STOP on

DO $version_check$
BEGIN
  IF current_setting('server_version_num')::integer < 160000
     OR current_setting('server_version_num')::integer >= 170000 THEN
    RAISE EXCEPTION 'IntegraRP v1.49 requer PostgreSQL 16; encontrado %', current_setting('server_version');
  END IF;
END
$version_check$;

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE TABLE IF NOT EXISTS integrarp.schema_contract (
    contract_name text PRIMARY KEY,
    product_version text NOT NULL,
    postgresql_major integer NOT NULL,
    schema_name text NOT NULL,
    migration_count integer NOT NULL,
    manifest_generated_at_utc timestamptz NOT NULL,
    installed_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_schema_contract_postgresql CHECK (postgresql_major = 16),
    CONSTRAINT ck_schema_contract_schema CHECK (schema_name = 'integrarp')
);
SELECT pg_advisory_lock({lock_key});
BEGIN;

'''
footer=f'''\nDO $final_validation$
BEGIN
  IF to_regnamespace('integrarp') IS NULL THEN RAISE EXCEPTION 'Schema integrarp ausente'; END IF;
  IF to_regclass('integrarp.schema_contract') IS NULL THEN RAISE EXCEPTION 'Contrato v1.49 ausente'; END IF;
  IF EXISTS (SELECT 1 FROM pg_catalog.pg_constraint c JOIN pg_catalog.pg_class r ON r.oid=c.conrelid JOIN pg_catalog.pg_namespace n ON n.oid=r.relnamespace WHERE n.nspname='integrarp' AND NOT c.convalidated) THEN
    RAISE EXCEPTION 'Existem constraints não validadas no schema integrarp';
  END IF;
END
$final_validation$;
COMMIT;
SELECT pg_advisory_unlock({lock_key});
'''
content=(header+body+footer).encode('utf-8')
for name in ('scriptcompleto.sql','script_completop.sql'): (DB/name).write_bytes(content)

objects=[]
patterns=[('table',r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?integrarp\.([a-zA-Z_][\w]*)\s*\((.*?)\);'),('view',r'CREATE\s+(?:OR\s+REPLACE\s+)?VIEW\s+integrarp\.([a-zA-Z_][\w]*)\s+AS\s+(.*?);'),('materialized_view',r'CREATE\s+MATERIALIZED\s+VIEW\s+(?:IF\s+NOT\s+EXISTS\s+)?integrarp\.([a-zA-Z_][\w]*)\s+AS\s+(.*?);'),('function',r'CREATE\s+(?:OR\s+REPLACE\s+)?FUNCTION\s+integrarp\.([a-zA-Z_][\w]*)\s*(\(.*?\).*?\$\$;)'),('sequence',r'CREATE\s+SEQUENCE\s+(?:IF\s+NOT\s+EXISTS\s+)?integrarp\.([a-zA-Z_][\w]*)(.*?);'),('trigger',r'CREATE\s+TRIGGER\s+([a-zA-Z_][\w]*)(.*?EXECUTE\s+FUNCTION\s+integrarp\.[a-zA-Z_][\w]*\s*\(\s*\)\s*;)')]
for entry in entries:
    text=normalized(MIG/entry['arquivo'])
    for kind,pat in patterns:
      for m in re.finditer(pat,text,re.I|re.S): objects.append(object_item(kind,m.group(1),entry['arquivo'],m.group(0),entry['modulo']))
# Constraints and indexes are separately addressable contract objects.
for entry in entries:
 text=normalized(MIG/entry['arquivo'])
 for m in re.finditer(r'(?:(?:ALTER\s+TABLE\s+integrarp\.[a-zA-Z_][\w]*\s+)?ADD\s+CONSTRAINT|[,(]\s*CONSTRAINT)\s+([a-zA-Z_][\w]*)\s+(.+?)(?:,|;|\n\s*\))',text,re.I|re.S): objects.append(object_item('constraint',m.group(1),entry['arquivo'],m.group(0),entry['modulo']))
 for m in re.finditer(r'CREATE\s+(?:UNIQUE\s+)?INDEX\s+(?:IF\s+NOT\s+EXISTS\s+)?([a-zA-Z_][\w]*)\s+ON\s+integrarp\.([a-zA-Z_][\w]*).*?;',text,re.I|re.S): objects.append(object_item('index',m.group(1),entry['arquivo'],m.group(0),entry['modulo'],[f'integrarp.{m.group(2)}']))
# Keep the last canonical definition for repeated idempotent declarations.
dedup={(o['type'],o['name']):o for o in objects}; objects=sorted(dedup.values(),key=lambda o:(o['type'],o['name']))
counts={k:sum(o['type']==k for o in objects) for k in sorted({o['type'] for o in objects})}
inventory={'contract':'Banco Canônico Integrarp v1.49','generatedAtUtc':manifest['generatedAtUtc'],'sourceManifest':'database/migration_manifest.json','schema':'integrarp','extensions':['pgcrypto'],'migrations':len(entries),'counts':counts,'objects':objects}
(DB/'schema_inventory.json').write_text(json.dumps(inventory,ensure_ascii=False,indent=2)+'\n',encoding='utf-8',newline='\n')
contract={'$schema':'https://json-schema.org/draft/2020-12/schema','contract':'Banco Canônico Integrarp v1.49','productVersion':'v1.49','postgresqlMajor':16,'schemas':['integrarp'],'extensions':['pgcrypto'],'types':[],'sequences':[o for o in objects if o['type']=='sequence'],'tables':[o for o in objects if o['type']=='table'],'views':[o for o in objects if o['type'] in ('view','materialized_view')],'functions':[o for o in objects if o['type']=='function'],'triggers':[o for o in objects if o['type']=='trigger'],'constraints':[o for o in objects if o['type']=='constraint'],'indexes':[o for o in objects if o['type']=='index']}
(DB/'schema_contract.json').write_text(json.dumps(contract,ensure_ascii=False,indent=2)+'\n',encoding='utf-8',newline='\n')
artifact=ROOT/'artifacts/v149/database'; artifact.mkdir(parents=True,exist_ok=True)
log=f"generator=generate-scriptcompleto.py\nmigrations={len(entries)}\nbody_sha256={body_checksum}\nfile_sha256={sha(content)}\nalias_identical=true\nobjects={len(objects)}\ncounts={json.dumps(counts,sort_keys=True)}\n"
(artifact/'generation.log').write_text(log,encoding='utf-8',newline='\n')
(artifact/'scriptcompleto.sha256').write_text(f"{sha(content)}  database/scriptcompleto.sql\n{sha(content)}  database/script_completop.sql\n",encoding='utf-8',newline='\n')
print(log,end='')
