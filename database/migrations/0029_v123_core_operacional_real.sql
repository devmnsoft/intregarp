-- IntegraRP v1.23 - hardening operacional real.
-- Migration aditiva e idempotente; transação controlada pelo Migration Runner/script completo.

ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS lockout_until timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS failed_login_count integer NOT NULL DEFAULT 0;
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS last_failed_login_at timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS security_stamp uuid NOT NULL DEFAULT gen_random_uuid();
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'integrarp' AND table_name = 'usuario')
       AND NOT EXISTS (SELECT 1 FROM pg_constraint WHERE connamespace = 'integrarp'::regnamespace AND conname = 'uq_usuario_tenant_id_id') THEN
        ALTER TABLE integrarp.usuario
            ADD CONSTRAINT uq_usuario_tenant_id_id UNIQUE (tenant_id, id);
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS integrarp.auth_login_attempt (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NULL,
    usuario_id uuid NULL,
    tenant_slug text NULL,
    email_normalizado text NOT NULL,
    success boolean NOT NULL,
    failure_reason text NULL,
    ip_address inet NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS ix_auth_login_attempt_lookup
    ON integrarp.auth_login_attempt (tenant_id, email_normalizado, criado_em DESC);

CREATE TABLE IF NOT EXISTS integrarp.auth_password_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NOT NULL,
    password_hash text NOT NULL,
    security_stamp uuid NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_auth_password_history_usuario FOREIGN KEY (tenant_id, usuario_id) REFERENCES integrarp.usuario (tenant_id, id)
);
CREATE INDEX IF NOT EXISTS ix_auth_password_history_usuario
    ON integrarp.auth_password_history (tenant_id, usuario_id, criado_em DESC);

ALTER TABLE IF EXISTS integrarp.cliente ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;
ALTER TABLE IF EXISTS integrarp.produto ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;
ALTER TABLE IF EXISTS integrarp.pedido ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS integrarp.worker_tenant_job_lock (
    tenant_id uuid NOT NULL,
    job_name text NOT NULL,
    locked_until timestamptz NOT NULL,
    locked_by text NOT NULL,
    correlation_id text NULL,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, job_name)
);

CREATE TABLE IF NOT EXISTS integrarp.worker_dead_letter (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    job_name text NOT NULL,
    payload jsonb NOT NULL DEFAULT '{}'::jsonb,
    erro text NOT NULL,
    attempts integer NOT NULL DEFAULT 0,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS ix_worker_dead_letter_tenant_job
    ON integrarp.worker_dead_letter (tenant_id, job_name, criado_em DESC);

CREATE OR REPLACE VIEW integrarp.vw_dashboard_operacional AS
SELECT
    t.id AS tenant_id,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND COALESCE(p.status, '') NOT IN ('Entregue','Cancelado')), 0) AS pedidos_em_andamento,
    COALESCE((SELECT count(*) FROM integrarp.tarefa_operacional ta WHERE ta.tenant_id = t.id AND ta.excluido_em IS NULL AND ta.status NOT IN ('Concluida','Cancelada','concluida','cancelada') AND ta.vencimento_em < now()), 0) AS tarefas_vencidas,
    COALESCE((SELECT count(*) FROM integrarp.processo_instancia pi WHERE pi.tenant_id = t.id AND COALESCE(pi.status, '') NOT IN ('Concluido','Cancelado')), 0) AS processos_ativos,
    COALESCE((SELECT count(*) FROM integrarp.outbox_evento oe WHERE oe.tenant_id = t.id AND COALESCE(oe.status, '') IN ('erro','falha')), 0) AS outbox_com_erro
FROM integrarp.tenant t
WHERE COALESCE(t.status, '') = 'ativo' AND t.excluido_em IS NULL;
