# Script completo do banco

`database/scriptcompleto.sql` é a fonte única consolidada para criação/evolução do banco IntegraRP.

Regras v1.6: usar somente schema `integrarp`, criar `pgcrypto`, manter `schema_migrations`, usar `CREATE TABLE IF NOT EXISTS`, `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS`, `CREATE OR REPLACE FUNCTION`, `CREATE OR REPLACE VIEW`, blocos `DO` para constraints e recriação explícita de triggers.

Validação local Windows:

```powershell
scripts/db-reset-local.ps1
scripts/db-validate-scriptcompleto.ps1
```

A validação aplica o script duas vezes para provar idempotência e verifica tabelas críticas, views e objetos v1.6.
