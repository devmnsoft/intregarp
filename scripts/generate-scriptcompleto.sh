#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MIGRATIONS="$ROOT/database/migrations"
MANIFEST="$ROOT/database/migration_manifest.json"
OUT="$ROOT/database/scriptcompleto.sql"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

python3 - "$MIGRATIONS" "$MANIFEST" "$OUT" <<'PY'
import hashlib, json, pathlib, re, sys
migrations=pathlib.Path(sys.argv[1]); manifest=pathlib.Path(sys.argv[2]); out=pathlib.Path(sys.argv[3])
data=json.loads(manifest.read_text(encoding='utf-8'))
data['gerado_para']='v1.15'
entries=data.get('migrations', [])
files=sorted(p.name for p in migrations.glob('*.sql'))
manifest_files=[e.get('arquivo') for e in entries]
missing=[f for f in files if f not in manifest_files]
absent=[f for f in manifest_files if f and not (migrations/f).exists()]
prefixes={}
for f in files:
    prefix=f.split('_',1)[0]
    prefixes.setdefault(prefix,[]).append(f)
allowed_duplicate_prefixes={'0014','0020','0021'}
dups={k:v for k,v in prefixes.items() if len(v)>1 and k not in allowed_duplicate_prefixes}
if missing or absent or dups:
    raise SystemExit(f'manifest mismatch missing={missing} absent={absent} duplicate_prefix={dups}')
for i,e in enumerate(entries, start=1):
    e['ordem']=i
    e['presente_no_scriptcompleto']=True
    e.setdefault('status','versionada')
manifest.write_text(json.dumps(data, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
allowed=re.compile(r'\bintegrarp\.', re.I)
for p in migrations.glob('*.sql'):
    txt=p.read_text(encoding='utf-8')
    forbidden=re.findall(r'\b(public|integra)\.', txt, flags=re.I)
    if forbidden:
        raise SystemExit(f'{p.name}: schema não permitido: {forbidden}')
parts=['-- IntegraRP scriptcompleto gerado deterministicamente para v1.15', 'CREATE SCHEMA IF NOT EXISTS integrarp;']
for name in files:
    txt=(migrations/name).read_text(encoding='utf-8').strip()
    parts.append(f"\n-- =====================================================================\n-- Migration: {name}\n-- =====================================================================\n{txt}\n")
body='\n'.join(parts)+'\n'
checksum=hashlib.sha256(body.encode('utf-8')).hexdigest()
out.write_text(f'-- checksum_sha256: {checksum}\n'+body, encoding='utf-8')
print(checksum)
PY

if command -v psql >/dev/null 2>&1 && [[ -n "${DATABASE_URL:-}" ]]; then
  psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$OUT"
  psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$OUT"
else
  echo "psql/DATABASE_URL ausente; geração concluída sem validação PostgreSQL." >&2
fi
