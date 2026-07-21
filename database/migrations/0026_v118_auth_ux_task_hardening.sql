CREATE SCHEMA IF NOT EXISTS integrarp;

ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS tentativas_invalidas integer NOT NULL DEFAULT 0;
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS bloqueado_ate timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.usuario_credencial ADD COLUMN IF NOT EXISTS security_stamp text NOT NULL DEFAULT gen_random_uuid()::text;

ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS ip text NULL;
ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS user_agent text NULL;
ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS correlation_id text NULL;
ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS revoked_at timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS revocation_reason text NULL;
ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();

ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS family_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS replaced_by_hash text NULL;
ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS used_at timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS revoked_at timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS revocation_reason text NULL;
ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();
UPDATE integrarp.auth_refresh_token SET family_id = COALESCE(family_id, sessao_id) WHERE family_id IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_auth_refresh_token_hash ON integrarp.auth_refresh_token (token_hash);
CREATE INDEX IF NOT EXISTS ix_auth_refresh_token_family ON integrarp.auth_refresh_token (family_id) WHERE revoked_at IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.auth_password_reset (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, token_hash text NOT NULL,
    expires_at timestamptz NOT NULL, consumed_at timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL,
    CONSTRAINT fk_auth_password_reset_usuario FOREIGN KEY (tenant_id, usuario_id) REFERENCES integrarp.usuario (tenant_id, id)
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_auth_password_reset_hash ON integrarp.auth_password_reset (token_hash);
CREATE INDEX IF NOT EXISTS ix_auth_password_reset_usuario ON integrarp.auth_password_reset (tenant_id, usuario_id) WHERE consumed_at IS NULL AND excluido_em IS NULL;

ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS cancelamento_motivo text NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS formulario_schema_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS checklist_schema_json jsonb NOT NULL DEFAULT '[]'::jsonb;

CREATE TABLE IF NOT EXISTS integrarp.tarefa_historico (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tarefa_id uuid NOT NULL, usuario_id uuid NULL,
    status_anterior text NULL, status_novo text NOT NULL, motivo text NULL, correlation_id text NULL, criado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL,
    CONSTRAINT fk_tarefa_historico_tarefa FOREIGN KEY (tenant_id, tarefa_id) REFERENCES integrarp.tarefa_operacional (tenant_id, id)
);
CREATE INDEX IF NOT EXISTS ix_tarefa_historico_tarefa ON integrarp.tarefa_historico (tenant_id, tarefa_id, criado_em DESC) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.tarefa_arquivo_evidencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tarefa_id uuid NOT NULL, usuario_id uuid NOT NULL,
    nome_original text NOT NULL, nome_fisico text NOT NULL, content_type text NOT NULL, extensao text NOT NULL, tamanho_bytes bigint NOT NULL, sha256 text NOT NULL,
    storage_provider text NOT NULL DEFAULT 'local', metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL,
    CONSTRAINT fk_tarefa_arquivo_tarefa FOREIGN KEY (tenant_id, tarefa_id) REFERENCES integrarp.tarefa_operacional (tenant_id, id)
);
CREATE INDEX IF NOT EXISTS ix_tarefa_arquivo_tarefa ON integrarp.tarefa_arquivo_evidencia (tenant_id, tarefa_id) WHERE excluido_em IS NULL;
