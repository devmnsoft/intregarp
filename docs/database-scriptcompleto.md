# database-scriptcompleto

Documento atualizado para v1.4.

- Runtime padrão: PostgreSQL no schema `integrarp`.
- Script único: `database/scriptcompleto.sql`.
- Migration: `database/migrations/0016_v14_postgres_repositories_operacional.sql`.
- Demo: `GET /api/validation/flow/order-to-billing-demo`.
- Providers externos reais permanecem sandbox/fake até configuração segura de produção.

## v1.5 — Validação real, CRUDs operacionais e jornada completa

A v1.5 acrescenta ao script completo os objetos idempotentes `integrarp.v15_operational_object`, `integrarp.v15_customer_full_journey_check`, `integrarp.v15_worker_queue_health`, as views `integrarp.vw_v15_customer_full_journey` e `integrarp.vw_v15_operational_readiness`, e registra a migration `0017_v15_validacao_real_cruds_qa_deploy` em `integrarp.schema_migrations`. O script permanece executável múltiplas vezes, usa `CREATE TABLE IF NOT EXISTS`, `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS`, `CREATE OR REPLACE FUNCTION`, `CREATE OR REPLACE VIEW`, blocos `DO` para constraints e recriação explícita de triggers.
