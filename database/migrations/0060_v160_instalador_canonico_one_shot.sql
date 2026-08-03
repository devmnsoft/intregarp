-- IntegraRP v1.60: reconciliação aditiva do contrato canônico. Preserva todos os dados.
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;
ALTER TABLE IF EXISTS integrarp.tenant ADD COLUMN IF NOT EXISTS slug text;
ALTER TABLE IF EXISTS integrarp.tenant ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'ativo';
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS email text;
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS perfil text;
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'ativo';
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS is_global boolean NOT NULL DEFAULT false;
ALTER TABLE IF EXISTS integrarp.perfil ADD COLUMN IF NOT EXISTS permissoes_json jsonb NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE IF EXISTS integrarp.perfil ADD COLUMN IF NOT EXISTS escopo text NOT NULL DEFAULT 'tenant';
ALTER TABLE IF EXISTS integrarp.permissao ADD COLUMN IF NOT EXISTS codigo text;
ALTER TABLE IF EXISTS integrarp.permissao ADD COLUMN IF NOT EXISTS descricao text;
ALTER TABLE IF EXISTS integrarp.processo_definicao ADD COLUMN IF NOT EXISTS descricao text;
ALTER TABLE IF EXISTS integrarp.processo_definicao ADD COLUMN IF NOT EXISTS processo_definicao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_versao ADD COLUMN IF NOT EXISTS processo_definicao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_versao ADD COLUMN IF NOT EXISTS processo_versao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_elemento ADD COLUMN IF NOT EXISTS processo_elemento_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_elemento ADD COLUMN IF NOT EXISTS processo_versao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_transicao ADD COLUMN IF NOT EXISTS processo_transicao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_transicao ADD COLUMN IF NOT EXISTS processo_versao_id uuid;
ALTER TABLE IF EXISTS integrarp.processo_instancia ADD COLUMN IF NOT EXISTS processo_instancia_id uuid;
ALTER TABLE IF EXISTS integrarp.outbox_evento ADD COLUMN IF NOT EXISTS idempotency_key text;
ALTER TABLE IF EXISTS integrarp.titulo_financeiro ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();
UPDATE integrarp.tenant SET status='ativo' WHERE status IS NULL OR lower(status) IN ('active','enabled');
UPDATE integrarp.usuario SET status='ativo' WHERE status IS NULL OR lower(status) IN ('active','enabled');
CREATE UNIQUE INDEX IF NOT EXISTS ux_v160_tenant_slug_ativo ON integrarp.tenant(lower(slug)) WHERE excluido_em IS NULL AND status='ativo' AND slug IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_v160_usuario_tenant_email ON integrarp.usuario(tenant_id,lower(email)) WHERE excluido_em IS NULL AND email IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_v160_outbox_idempotency ON integrarp.outbox_evento(tenant_id,idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE OR REPLACE VIEW integrarp.vw_v160_schema_health AS
SELECT current_database() database_name, count(*) FILTER (WHERE c.relkind IN ('r','p'))::integer table_count,
       count(*) FILTER (WHERE c.relkind IN ('v','m'))::integer view_count
FROM pg_catalog.pg_class c JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='integrarp';
COMMIT;
