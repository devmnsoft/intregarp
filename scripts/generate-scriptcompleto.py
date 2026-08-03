#!/usr/bin/env python3
"""Gera deterministicamente o instalador limpo somente das fases canônicas v1.60."""
from pathlib import Path
import hashlib
ROOT=Path(__file__).resolve().parent.parent
DB=ROOT/'database'; CANONICAL=DB/'canonical'
FILES=[f'{n:02d}_{name}.sql' for n,name in enumerate([
'preflight','schema','tables','constraints','indexes','functions_triggers','views','parameters','identity_seed','business_seed','migration_ledger','final_validation'],1)]
missing=[x for x in FILES if not (CANONICAL/x).is_file()]
if missing: raise SystemExit(f'Fases canônicas ausentes: {missing}')
parts=[]
for name in FILES:
 raw=(CANONICAL/name).read_bytes()
 if raw.startswith(b'\xef\xbb\xbf'): raise SystemExit(f'BOM proibido: {name}')
 text=raw.decode('utf-8').replace('\r\n','\n').replace('\r','\n').rstrip()+'\n'
 if any(line.lstrip().startswith('\\') for line in text.splitlines()): raise SystemExit(f'Metacomando psql proibido: {name}')
 parts.append(f'-- >>> canonical/{name}\n{text}-- <<< canonical/{name}\n')
body='\n'.join(parts)
# Checksum do template (antes de materializar o próprio checksum) evita ponto fixo impossível.
template_hash=hashlib.sha256(body.encode()).hexdigest()
body=body.replace('__INSTALLER_SHA256__',template_hash)
header='''-- Produto: IntegraRP\n-- Versão: v1.60\n-- PostgreSQL: 16\n-- Contrato: Banco Canônico Integrarp v1.60\n-- SQL PostgreSQL puro; execute externamente com ON_ERROR_STOP=1.\n-- Gerado de database/canonical; não editar este artefato.\n\n'''
content=(header+body).encode()
for name in ('scriptcompleto.sql','script_completop.sql'):(DB/name).write_bytes(content)
print(f'canonical_files={len(FILES)}\nsha256={hashlib.sha256(content).hexdigest()}\nalias_identical=true')
