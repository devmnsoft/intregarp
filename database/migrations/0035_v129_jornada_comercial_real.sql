-- IntegraRP v1.29 - jornada comercial real
-- PostgreSQL 16, schema integrarp, migration aditiva e idempotente.
CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE TABLE IF NOT EXISTS integrarp.produto_categoria (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo text NOT NULL,
    nome text NOT NULL,
    status text NOT NULL DEFAULT 'ativo',
    excluido_em timestamptz NULL,
    row_version bigint NOT NULL DEFAULT 1,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_produto_categoria_tenant_codigo UNIQUE (tenant_id, codigo),
    CONSTRAINT ck_produto_categoria_status CHECK (status IN ('ativo','inativo'))
);

CREATE TABLE IF NOT EXISTS integrarp.estoque_saldo (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    produto_id uuid NOT NULL,
    local_codigo text NOT NULL,
    saldo_fisico numeric(18,4) NOT NULL DEFAULT 0,
    saldo_reservado numeric(18,4) NOT NULL DEFAULT 0,
    row_version bigint NOT NULL DEFAULT 1,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_estoque_saldo_tenant_produto_local UNIQUE (tenant_id, produto_id, local_codigo),
    CONSTRAINT ck_estoque_saldo_quantidades CHECK (saldo_fisico >= 0 AND saldo_reservado >= 0 AND saldo_fisico >= saldo_reservado)
);

CREATE TABLE IF NOT EXISTS integrarp.estoque_movimento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    produto_id uuid NOT NULL,
    pedido_id uuid NULL,
    tipo text NOT NULL,
    quantidade numeric(18,4) NOT NULL,
    local_codigo text NOT NULL,
    motivo text NOT NULL,
    usuario_id uuid NOT NULL,
    idempotency_key text NOT NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_estoque_movimento_idempotencia UNIQUE (tenant_id, idempotency_key),
    CONSTRAINT ck_estoque_movimento_tipo CHECK (tipo IN ('entrada','saida','ajuste','reserva','liberacao','baixa','estorno')),
    CONSTRAINT ck_estoque_movimento_quantidade CHECK (quantidade > 0)
);

CREATE TABLE IF NOT EXISTS integrarp.pedido_historico_status (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    pedido_id uuid NOT NULL,
    status_anterior text NULL,
    status_novo text NOT NULL,
    motivo text NULL,
    usuario_id uuid NOT NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integrarp.worker_tenant_job_lock (
    tenant_id uuid NOT NULL,
    job_name text NOT NULL,
    locked_until timestamptz NOT NULL,
    correlation_id text NULL,
    updated_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, job_name)
);

ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS pedido_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS setor_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS checklist_resposta_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS correlation_id text NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS vencimento_em timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ALTER COLUMN prioridade TYPE text USING CASE prioridade::text WHEN '1' THEN 'baixa' WHEN '2' THEN 'normal' WHEN '3' THEN 'normal' WHEN '4' THEN 'alta' WHEN '5' THEN 'urgente' ELSE COALESCE(prioridade::text,'normal') END;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ALTER COLUMN prioridade SET DEFAULT 'normal';
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ALTER COLUMN prioridade SET NOT NULL;
DO $$ BEGIN
  ALTER TABLE integrarp.tarefa_operacional ADD CONSTRAINT ck_tarefa_operacional_prioridade_v129 CHECK (prioridade IN ('baixa','normal','alta','urgente'));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN ALTER TABLE integrarp.setor ADD CONSTRAINT uq_setor_tenant_id_v129 UNIQUE (tenant_id, id); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN ALTER TABLE integrarp.pedido ADD CONSTRAINT uq_pedido_tenant_id_v129 UNIQUE (tenant_id, id); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN ALTER TABLE integrarp.usuario ADD CONSTRAINT uq_usuario_tenant_id_v129 UNIQUE (tenant_id, id); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN ALTER TABLE integrarp.produto ADD CONSTRAINT uq_produto_tenant_id_v129 UNIQUE (tenant_id, id); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN ALTER TABLE integrarp.cliente ADD CONSTRAINT uq_cliente_tenant_id_v129 UNIQUE (tenant_id, id); EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE INDEX IF NOT EXISTS ix_pedido_historico_status_tenant_pedido ON integrarp.pedido_historico_status (tenant_id, pedido_id, criado_em DESC);
CREATE INDEX IF NOT EXISTS ix_estoque_movimento_tenant_produto ON integrarp.estoque_movimento (tenant_id, produto_id, criado_em DESC);
CREATE INDEX IF NOT EXISTS ix_worker_tenant_job_lock_until ON integrarp.worker_tenant_job_lock (locked_until);
