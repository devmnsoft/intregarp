-- v1.14 - consolidação operacional e segurança real
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

ALTER TABLE integrarp.produto ADD COLUMN IF NOT EXISTS preco_custo numeric NOT NULL DEFAULT 0;
ALTER TABLE integrarp.produto ADD COLUMN IF NOT EXISTS preco_venda numeric NOT NULL DEFAULT 0;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS data_entrega_prevista timestamptz NULL;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS desconto_total numeric NOT NULL DEFAULT 0;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS setor_id uuid NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS descricao text NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS sla_minutos integer NULL;

CREATE TABLE IF NOT EXISTS integrarp.tarefa_comentario (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    tarefa_id uuid NOT NULL,
    author_user_id uuid NOT NULL,
    texto text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.pedido_status_historico (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    pedido_id uuid NOT NULL,
    status_anterior text NULL,
    status_novo text NOT NULL,
    motivo text NULL,
    usuario_id uuid NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS ix_produto_tenant_sku_ativo ON integrarp.produto (tenant_id, sku) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_responsavel ON integrarp.tarefa_operacional (tenant_id, responsavel_usuario_id, setor_id, status) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_comentario_tenant_tarefa ON integrarp.tarefa_comentario (tenant_id, tarefa_id) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_pedido_status_historico_tenant_pedido ON integrarp.pedido_status_historico (tenant_id, pedido_id, criado_em);
