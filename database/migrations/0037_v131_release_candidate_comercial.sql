-- Produto: IntegraRP
-- Versao: v1.31
-- PostgreSQL: 16
-- Schema: integrarp
-- Contrato: v1.31-release-candidate-comercial
-- Migration somente aditiva. Nao cria senha fixa e nao altera migrations historicas.

CREATE SCHEMA IF NOT EXISTS integrarp;

ALTER TABLE integrarp.cliente
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS excluido_em timestamptz;

ALTER TABLE integrarp.produto_categoria
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS excluido_em timestamptz;

ALTER TABLE integrarp.produto
    ADD COLUMN IF NOT EXISTS categoria_id uuid,
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS excluido_em timestamptz;

ALTER TABLE integrarp.pedido
    ADD COLUMN IF NOT EXISTS numero text,
    ADD COLUMN IF NOT EXISTS cliente_id uuid,
    ADD COLUMN IF NOT EXISTS observacoes text,
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;

ALTER TABLE integrarp.pedido_item
    ADD COLUMN IF NOT EXISTS pedido_id uuid,
    ADD COLUMN IF NOT EXISTS produto_id uuid,
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;

ALTER TABLE integrarp.estoque_saldo
    ADD COLUMN IF NOT EXISTS prioridade_local integer NOT NULL DEFAULT 100,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;

ALTER TABLE integrarp.estoque_reserva
    ADD COLUMN IF NOT EXISTS local_codigo text NOT NULL DEFAULT 'principal',
    ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();

ALTER TABLE integrarp.tarefa_operacional
    ADD COLUMN IF NOT EXISTS checklist_definicao_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    ADD COLUMN IF NOT EXISTS checklist_resposta_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    ADD COLUMN IF NOT EXISTS assumido_em timestamptz,
    ADD COLUMN IF NOT EXISTS iniciado_em timestamptz,
    ADD COLUMN IF NOT EXISTS concluido_em timestamptz,
    ADD COLUMN IF NOT EXISTS cancelado_em timestamptz,
    ADD COLUMN IF NOT EXISTS motivo_cancelamento text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;

ALTER TABLE integrarp.auditoria_evento
    ADD COLUMN IF NOT EXISTS sessao_id uuid;

ALTER TABLE integrarp.outbox_evento
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS max_tentativas integer NOT NULL DEFAULT 8,
    ADD COLUMN IF NOT EXISTS proxima_tentativa_em timestamptz,
    ADD COLUMN IF NOT EXISTS processado_em timestamptz;

CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_tenant_id ON integrarp.cliente (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_categoria_tenant_id ON integrarp.produto_categoria (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_tenant_id ON integrarp.produto (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_tenant_id ON integrarp.pedido (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_item_tenant_id ON integrarp.pedido_item (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_tarefa_operacional_tenant_id ON integrarp.tarefa_operacional (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_tenant_numero ON integrarp.pedido (tenant_id, numero);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_tenant_idempotency ON integrarp.pedido (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_item_tenant_idempotency ON integrarp.pedido_item (tenant_id, pedido_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_outbox_tenant_idempotency ON integrarp.outbox_evento (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE INDEX IF NOT EXISTS ix_outbox_claim ON integrarp.outbox_evento (tenant_id, status, proxima_tentativa_em, criado_em);

DO $migration$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_tarefa_operacional_prioridade_v131') THEN
        ALTER TABLE integrarp.tarefa_operacional ADD CONSTRAINT ck_tarefa_operacional_prioridade_v131
            CHECK (prioridade IN ('baixa', 'normal', 'alta', 'urgente')) NOT VALID;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_outbox_evento_status_v131') THEN
        ALTER TABLE integrarp.outbox_evento ADD CONSTRAINT ck_outbox_evento_status_v131
            CHECK (status IN ('pendente', 'processando', 'processado', 'erro', 'nao_configurado', 'dead_letter')) NOT VALID;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_produto_categoria_tenant_v131') THEN
        ALTER TABLE integrarp.produto ADD CONSTRAINT fk_produto_categoria_tenant_v131
            FOREIGN KEY (tenant_id, categoria_id) REFERENCES integrarp.produto_categoria (tenant_id, id) NOT VALID;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pedido_cliente_tenant_v131') THEN
        ALTER TABLE integrarp.pedido ADD CONSTRAINT fk_pedido_cliente_tenant_v131
            FOREIGN KEY (tenant_id, cliente_id) REFERENCES integrarp.cliente (tenant_id, id) NOT VALID;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pedido_item_pedido_tenant_v131') THEN
        ALTER TABLE integrarp.pedido_item ADD CONSTRAINT fk_pedido_item_pedido_tenant_v131
            FOREIGN KEY (tenant_id, pedido_id) REFERENCES integrarp.pedido (tenant_id, id) NOT VALID;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pedido_item_produto_tenant_v131') THEN
        ALTER TABLE integrarp.pedido_item ADD CONSTRAINT fk_pedido_item_produto_tenant_v131
            FOREIGN KEY (tenant_id, produto_id) REFERENCES integrarp.produto (tenant_id, id) NOT VALID;
    END IF;
END
$migration$;

ALTER TABLE integrarp.tarefa_operacional VALIDATE CONSTRAINT ck_tarefa_operacional_prioridade_v131;
ALTER TABLE integrarp.outbox_evento VALIDATE CONSTRAINT ck_outbox_evento_status_v131;
ALTER TABLE integrarp.produto VALIDATE CONSTRAINT fk_produto_categoria_tenant_v131;
ALTER TABLE integrarp.pedido VALIDATE CONSTRAINT fk_pedido_cliente_tenant_v131;
ALTER TABLE integrarp.pedido_item VALIDATE CONSTRAINT fk_pedido_item_pedido_tenant_v131;
ALTER TABLE integrarp.pedido_item VALIDATE CONSTRAINT fk_pedido_item_produto_tenant_v131;
