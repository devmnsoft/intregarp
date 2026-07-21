-- IntegraRP v1.25 - Core Comercial, UX Premium e Operação Intuitiva
-- PostgreSQL 16; schema integrarp; migration aditiva, idempotente e sem search_path.

ALTER TABLE IF EXISTS integrarp.auth_sessao
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS last_refreshed_at timestamptz;

ALTER TABLE IF EXISTS integrarp.auth_login_tentativa
    ADD COLUMN IF NOT EXISTS user_agent text,
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS correlation_id text;

CREATE TABLE IF NOT EXISTS integrarp.v125_audit_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NULL,
    entidade text NOT NULL,
    entidade_id uuid NULL,
    acao text NOT NULL,
    detalhes jsonb NOT NULL DEFAULT '{}'::jsonb,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ix_v125_audit_evento_tenant_criado
    ON integrarp.v125_audit_evento (tenant_id, criado_em DESC);

CREATE TABLE IF NOT EXISTS integrarp.v125_outbox_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    tipo text NOT NULL,
    payload jsonb NOT NULL,
    status text NOT NULL DEFAULT 'pendente',
    tentativas integer NOT NULL DEFAULT 0,
    proxima_tentativa_em timestamptz NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    processado_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_v125_outbox_evento_tenant_status
    ON integrarp.v125_outbox_evento (tenant_id, status, criado_em);

CREATE TABLE IF NOT EXISTS integrarp.v125_dashboard_agregado (
    tenant_id uuid PRIMARY KEY,
    pedidos_em_andamento integer NOT NULL DEFAULT 0,
    pedidos_aguardando_confirmacao integer NOT NULL DEFAULT 0,
    tarefas_vencidas integer NOT NULL DEFAULT 0,
    tarefas_para_hoje integer NOT NULL DEFAULT 0,
    estoque_critico integer NOT NULL DEFAULT 0,
    reservas_pendentes integer NOT NULL DEFAULT 0,
    processos_ativos integer NOT NULL DEFAULT 0,
    outbox_com_erro integer NOT NULL DEFAULT 0,
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integrarp.v125_worker_lock (
    tenant_id uuid NOT NULL,
    job_name text NOT NULL,
    locked_until timestamptz NOT NULL,
    correlation_id text NULL,
    updated_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, job_name)
);
