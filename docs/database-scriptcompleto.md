# Script completo do banco

`database/scriptcompleto.sql` é a fonte única consolidada para criação/evolução do banco IntegraRP.

Regras v1.7: usar somente schema `integrarp`, criar `pgcrypto`, manter `schema_migrations`, usar `CREATE TABLE IF NOT EXISTS`, `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS`, `CREATE OR REPLACE FUNCTION`, `CREATE OR REPLACE VIEW`, blocos `DO` para constraints e recriação explícita de triggers.

Validação local Windows:

```powershell
scripts/db-reset-local.ps1
scripts/db-validate-scriptcompleto.ps1
```

A validação aplica o script duas vezes para provar idempotência e verifica tabelas críticas, views, constraints, triggers, seeds demo e objetos v1.7.

## Execução esperada

Execute contra PostgreSQL com `ON_ERROR_STOP=1`. O script completo pode ser reaplicado e o workflow `database-validation` deve provar a segunda execução sem erro.

## Atualização v1.8

O `database/scriptcompleto.sql` recebeu a migration `0020_v18_produto_funcional_cruds_telas_jornada`, com objetos idempotentes no schema `integrarp` para auditoria funcional de telas, catálogo de templates, validação por módulo e view de dashboard operacional.
