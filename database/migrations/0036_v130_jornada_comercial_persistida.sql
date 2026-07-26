-- Produto: IntegraRP
-- Versao: v1.30
-- PostgreSQL: 16
-- Schema: integrarp
-- Contrato: v1.30-jornada-comercial-persistida
-- Instrucao: migration aditiva e idempotente; nao cria senha fixa.
CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.cliente (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text NOT NULL,
    documento_normalizado text NULL,
    email text NULL,
    telefone text NULL,
    status text NOT NULL DEFAULT 'ativo',
    row_version bigint NOT NULL DEFAULT 1,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    excluido_em timestamptz NULL,
    correlation_id text NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (id)
);
ALTER TABLE integrarp.cliente ADD COLUMN IF NOT EXISTS documento_normalizado text;
ALTER TABLE integrarp.cliente ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
ALTER TABLE integrarp.cliente ADD COLUMN IF NOT EXISTS excluido_em timestamptz NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_tenant_documento ON integrarp.cliente(tenant_id, documento_normalizado) WHERE documento_normalizado IS NOT NULL AND excluido_em IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_tenant_id ON integrarp.cliente(tenant_id, id);

CREATE TABLE IF NOT EXISTS integrarp.produto_categoria (
    id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL,
    status text NOT NULL DEFAULT 'ativo', row_version bigint NOT NULL DEFAULT 1, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL, correlation_id text NULL, CONSTRAINT pk_produto_categoria PRIMARY KEY(id)
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_categoria_tenant_codigo ON integrarp.produto_categoria(tenant_id, codigo) WHERE excluido_em IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_categoria_tenant_id ON integrarp.produto_categoria(tenant_id, id);

CREATE TABLE IF NOT EXISTS integrarp.produto (
    id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, sku text NOT NULL, categoria_id uuid NOT NULL, nome text NOT NULL, preco numeric(18,2) NOT NULL DEFAULT 0, estoque_minimo numeric(18,3) NOT NULL DEFAULT 0,
    status text NOT NULL DEFAULT 'ativo', row_version bigint NOT NULL DEFAULT 1, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL, correlation_id text NULL, CONSTRAINT pk_produto PRIMARY KEY(id)
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_tenant_sku ON integrarp.produto(tenant_id, sku) WHERE excluido_em IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_tenant_id ON integrarp.produto(tenant_id, id);

CREATE TABLE IF NOT EXISTS integrarp.estoque_saldo (id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, produto_id uuid NOT NULL, local_codigo text NOT NULL, saldo_fisico numeric(18,3) NOT NULL DEFAULT 0, saldo_reservado numeric(18,3) NOT NULL DEFAULT 0, row_version bigint NOT NULL DEFAULT 1, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), CONSTRAINT pk_estoque_saldo PRIMARY KEY(id));
CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_saldo_tenant_produto_local ON integrarp.estoque_saldo(tenant_id, produto_id, local_codigo);
CREATE TABLE IF NOT EXISTS integrarp.estoque_movimento (id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, produto_id uuid NOT NULL, tipo text NOT NULL, quantidade numeric(18,3) NOT NULL, local_codigo text NOT NULL, motivo text NOT NULL, usuario_id uuid NOT NULL, idempotency_key text NOT NULL, correlation_id text NULL, criado_em timestamptz NOT NULL DEFAULT now(), CONSTRAINT pk_estoque_movimento PRIMARY KEY(id));
CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_movimento_tenant_idempotency ON integrarp.estoque_movimento(tenant_id, idempotency_key);
CREATE TABLE IF NOT EXISTS integrarp.estoque_reserva (id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, produto_id uuid NOT NULL, quantidade numeric(18,3) NOT NULL, status text NOT NULL DEFAULT 'ativa', idempotency_key text NOT NULL, correlation_id text NULL, criado_em timestamptz NOT NULL DEFAULT now(), CONSTRAINT pk_estoque_reserva PRIMARY KEY(id));
CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_reserva_tenant_idempotency ON integrarp.estoque_reserva(tenant_id, idempotency_key);

CREATE TABLE IF NOT EXISTS integrarp.pedido (id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, numero text NOT NULL, cliente_id uuid NOT NULL, status text NOT NULL DEFAULT 'rascunho', total numeric(18,2) NOT NULL DEFAULT 0, row_version bigint NOT NULL DEFAULT 1, idempotency_key text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL, correlation_id text NULL, CONSTRAINT pk_pedido PRIMARY KEY(id));
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_tenant_id ON integrarp.pedido(tenant_id, id);
CREATE TABLE IF NOT EXISTS integrarp.pedido_item (id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NOT NULL, produto_id uuid NOT NULL, quantidade numeric(18,3) NOT NULL, preco_unitario numeric(18,2) NOT NULL, desconto numeric(18,2) NOT NULL DEFAULT 0, total numeric(18,2) NOT NULL, idempotency_key text NULL, criado_em timestamptz NOT NULL DEFAULT now(), CONSTRAINT pk_pedido_item PRIMARY KEY(id));
CREATE TABLE IF NOT EXISTS integrarp.pedido_historico_status (id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NOT NULL, status_anterior text NULL, status_novo text NOT NULL, usuario_id uuid NOT NULL, correlation_id text NULL, criado_em timestamptz NOT NULL DEFAULT now(), CONSTRAINT pk_pedido_historico_status PRIMARY KEY(id));

CREATE TABLE IF NOT EXISTS integrarp.tarefa_operacional (id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, setor_id uuid NULL, responsavel_usuario_id uuid NULL, titulo text NOT NULL, status text NOT NULL DEFAULT 'aberta', prioridade text NOT NULL DEFAULT 'normal', sla_minutos integer NULL, vencimento_em timestamptz NULL, checklist_resposta_json jsonb NOT NULL DEFAULT '[]'::jsonb, row_version bigint NOT NULL DEFAULT 1, correlation_id text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), CONSTRAINT pk_tarefa_operacional PRIMARY KEY(id));
CREATE UNIQUE INDEX IF NOT EXISTS ux_tarefa_operacional_tenant_id ON integrarp.tarefa_operacional(tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_tarefa_operacional_tenant_pedido ON integrarp.tarefa_operacional(tenant_id, pedido_id) WHERE pedido_id IS NOT NULL;

CREATE TABLE IF NOT EXISTS integrarp.auditoria_evento (id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NULL, entidade text NOT NULL, entidade_id uuid NULL, acao text NOT NULL, antes_json jsonb NULL, depois_json jsonb NULL, ip_address text NULL, user_agent text NULL, correlation_id text NULL, criado_em timestamptz NOT NULL DEFAULT now(), origem text NOT NULL DEFAULT 'api', CONSTRAINT pk_auditoria_evento PRIMARY KEY(id));
CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tipo text NOT NULL, payload_json jsonb NOT NULL DEFAULT '{}'::jsonb, status text NOT NULL DEFAULT 'pendente', tentativas integer NOT NULL DEFAULT 0, erro_resumido text NULL, correlation_id text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), CONSTRAINT pk_outbox_evento PRIMARY KEY(id));
CREATE TABLE IF NOT EXISTS integrarp.worker_tenant_job_lock (tenant_id uuid NOT NULL, job_name text NOT NULL, locked_until timestamptz NOT NULL, correlation_id text NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), CONSTRAINT pk_worker_tenant_job_lock PRIMARY KEY(tenant_id, job_name));
CREATE TABLE IF NOT EXISTS integrarp.worker_dead_letter (id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, job_name text NOT NULL, reason text NOT NULL, correlation_id text NULL, criado_em timestamptz NOT NULL DEFAULT now(), CONSTRAINT pk_worker_dead_letter PRIMARY KEY(id));
