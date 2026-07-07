# Database script completo

O arquivo `/database/scriptcompleto.sql` é o script único de criação/evolução. Ele deve ser idempotente, usar somente schema `integrarp`, criar `pgcrypto`, manter `integrarp.schema_migrations`, usar `CREATE TABLE IF NOT EXISTS`, `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS`, `CREATE OR REPLACE FUNCTION`, `CREATE OR REPLACE VIEW` e triggers recriadas por `DROP TRIGGER IF EXISTS` seguido de `CREATE TRIGGER`.

## v1.3
A v1.3 adiciona `integrarp.v13_funcionalidade_status`, `integrarp.v13_recommended_action`, `integrarp.v13_demo_execucao` e as views de validação `integrarp.vw_v13_*`.
