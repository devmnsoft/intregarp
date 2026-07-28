# Banco de dados IntegraRP v1.40

O arquivo canônico é `database/scriptcompleto.sql`. `database/script_completop.sql` existe somente como alias temporário byte a byte. Requer PostgreSQL 16 e `POSTGRES_URI` configurada externamente.

```bash
psql -X "$POSTGRES_URI" --set ON_ERROR_STOP=1 --file database/scriptcompleto.sql
psql -X "$POSTGRES_URI" --set ON_ERROR_STOP=1 --file database/validate_scriptcompleto.sql
```

Não configure `search_path`: todo SQL de negócio deve qualificar `integrarp.objeto`. Consulte `docs/database/scriptcompleto.md` para instalação limpa, reexecução, validação, rollback e erros; `docs/database/upgrade.md` para upgrade e preservação; e `docs/database/schema-integrarp.md` para o inventário. O Migration Runner continua usando `migration_manifest.json` e rejeita migrations ausentes, extras ou checksums históricos desconhecidos.
