-- IntegraRP v1.25 - Core Comercial, UX Premium e Operação Intuitiva
-- PostgreSQL 16; schema integrarp; migration aditiva, idempotente.

ALTER TABLE IF EXISTS integrarp.auth_sessao
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS last_refreshed_at timestamptz;

ALTER TABLE IF EXISTS integrarp.auth_login_tentativa
    ADD COLUMN IF NOT EXISTS user_agent text,
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS correlation_id text;


CREATE TABLE IF NOT EXISTS integrarp.auditoria_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NULL,
    entidade text NOT NULL,
    entidade_id uuid NULL,
    acao text NOT NULL,
    dados_json jsonb NULL,
    detalhes jsonb NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS ix_auditoria_evento_tenant_criado
    ON integrarp.auditoria_evento (tenant_id, criado_em DESC);

CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    tipo text NULL,
    tipo_evento text NULL,
    canal text NULL,
    payload jsonb NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    status text NOT NULL DEFAULT 'pendente',
    tentativas integer NOT NULL DEFAULT 0,
    max_tentativas integer NOT NULL DEFAULT 5,
    proxima_tentativa_em timestamptz NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    processado_em timestamptz NULL,
    erro text NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS ix_outbox_evento_tenant_status_criado
    ON integrarp.outbox_evento (tenant_id, status, criado_em);

CREATE TABLE IF NOT EXISTS integrarp.worker_tenant_job_lock (
    tenant_id uuid NOT NULL,
    job_name text NOT NULL,
    locked_until timestamptz NOT NULL,
    locked_by text NOT NULL DEFAULT 'integrarp-worker',
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

DO $$
BEGIN
    IF to_regclass('integrarp.v125_audit_evento') IS NOT NULL THEN
        INSERT INTO integrarp.auditoria_evento (id, tenant_id, usuario_id, entidade, entidade_id, acao, detalhes, correlation_id, criado_em)
        SELECT id, tenant_id, usuario_id, entidade, entidade_id, acao, detalhes, correlation_id, criado_em
          FROM integrarp.v125_audit_evento
        ON CONFLICT (id) DO NOTHING;
        IF NOT EXISTS (SELECT 1 FROM integrarp.v125_audit_evento) THEN
            DROP TABLE integrarp.v125_audit_evento;
        END IF;
    END IF;
    IF to_regclass('integrarp.v125_outbox_evento') IS NOT NULL THEN
        INSERT INTO integrarp.outbox_evento (id, tenant_id, tipo, tipo_evento, payload, payload_json, status, tentativas, proxima_tentativa_em, correlation_id, criado_em, processado_em)
        SELECT id, tenant_id, tipo, tipo, payload, payload, status, tentativas, proxima_tentativa_em, correlation_id, criado_em, processado_em
          FROM integrarp.v125_outbox_evento
        ON CONFLICT (id) DO NOTHING;
        IF NOT EXISTS (SELECT 1 FROM integrarp.v125_outbox_evento) THEN
            DROP TABLE integrarp.v125_outbox_evento;
        END IF;
    END IF;
    IF to_regclass('integrarp.v125_worker_lock') IS NOT NULL THEN
        INSERT INTO integrarp.worker_tenant_job_lock (tenant_id, job_name, locked_until, correlation_id, atualizado_em)
        SELECT tenant_id, job_name, locked_until, correlation_id, updated_at FROM integrarp.v125_worker_lock
        ON CONFLICT (tenant_id, job_name) DO UPDATE SET locked_until = EXCLUDED.locked_until, correlation_id = EXCLUDED.correlation_id, atualizado_em = EXCLUDED.atualizado_em;
        IF NOT EXISTS (SELECT 1 FROM integrarp.v125_worker_lock) THEN
            DROP TABLE integrarp.v125_worker_lock;
        END IF;
    END IF;
    IF to_regclass('integrarp.v125_dashboard_agregado') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM integrarp.v125_dashboard_agregado) THEN
        DROP TABLE integrarp.v125_dashboard_agregado;
    END IF;
END $$;

CREATE OR REPLACE VIEW integrarp.vw_dashboard_operacional AS
SELECT
    t.id AS tenant_id,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('aberto','em_andamento','andamento','processando','confirmado','em_separacao')), 0)::integer AS pedidos_em_andamento,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('rascunho','aguardando_confirmacao')), 0)::integer AS pedidos_aguardando_confirmacao,
    COALESCE((SELECT count(*) FROM integrarp.tarefa tf WHERE tf.tenant_id = t.id AND tf.prazo_em < now() AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_vencidas,
    COALESCE((SELECT count(*) FROM integrarp.outbox_evento oe WHERE oe.tenant_id = t.id AND lower(COALESCE(oe.status, '')) IN ('erro','failed','falha')), 0)::integer AS outbox_com_erro,
    now() AS atualizado_em
FROM integrarp.tenant t;
