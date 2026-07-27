-- IntegraRP v1.33 - convergencia executavel do schema comercial
-- PostgreSQL 16. Migration aditiva, idempotente e restrita ao schema integrarp.

-- Reconcilia bancos que aplicaram a versão publicada da 0034.
ALTER TABLE integrarp.tarefa_operacional
    ALTER COLUMN prioridade DROP DEFAULT,
    ALTER COLUMN prioridade TYPE text USING CASE prioridade::text
        WHEN '1' THEN 'baixa' WHEN '2' THEN 'normal' WHEN '3' THEN 'normal'
        WHEN '4' THEN 'alta' WHEN '5' THEN 'urgente' ELSE COALESCE(prioridade::text, 'normal') END,
    ALTER COLUMN prioridade SET DEFAULT 'normal',
    ALTER COLUMN prioridade SET NOT NULL;

ALTER TABLE integrarp.tarefa_operacional
    ALTER COLUMN correlation_id TYPE text USING correlation_id::text;
ALTER TABLE integrarp.pedido_historico_status
    ALTER COLUMN correlation_id TYPE text USING correlation_id::text;
ALTER TABLE integrarp.outbox_evento
    ALTER COLUMN correlation_id TYPE text USING correlation_id::text;

-- Reconcilia bancos nos quais a 0037 foi registrada sem todas as colunas canônicas.
ALTER TABLE integrarp.produto ADD COLUMN IF NOT EXISTS categoria_id uuid;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS numero text;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS cliente_id uuid;
ALTER TABLE integrarp.pedido_item ADD COLUMN IF NOT EXISTS pedido_id uuid;
ALTER TABLE integrarp.pedido_item ADD COLUMN IF NOT EXISTS produto_id uuid;

CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_tenant_id ON integrarp.cliente (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_categoria_tenant_id ON integrarp.produto_categoria (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_tenant_id ON integrarp.produto (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_tenant_id ON integrarp.pedido (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_item_tenant_id ON integrarp.pedido_item (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_usuario_tenant_id ON integrarp.usuario (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_setor_tenant_id ON integrarp.setor (tenant_id, id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_tarefa_operacional_tenant_id ON integrarp.tarefa_operacional (tenant_id, id);

DO $migration$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_produto_categoria_tenant_v133') THEN
        ALTER TABLE integrarp.produto ADD CONSTRAINT fk_produto_categoria_tenant_v133
            FOREIGN KEY (tenant_id, categoria_id) REFERENCES integrarp.produto_categoria (tenant_id, id) NOT VALID;
    END IF;
END $migration$;
DO $migration$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pedido_cliente_tenant_v133') THEN
        ALTER TABLE integrarp.pedido ADD CONSTRAINT fk_pedido_cliente_tenant_v133
            FOREIGN KEY (tenant_id, cliente_id) REFERENCES integrarp.cliente (tenant_id, id) NOT VALID;
    END IF;
END $migration$;
DO $migration$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pedido_item_pedido_tenant_v133') THEN
        ALTER TABLE integrarp.pedido_item ADD CONSTRAINT fk_pedido_item_pedido_tenant_v133
            FOREIGN KEY (tenant_id, pedido_id) REFERENCES integrarp.pedido (tenant_id, id) NOT VALID;
    END IF;
END $migration$;
DO $migration$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pedido_item_produto_tenant_v133') THEN
        ALTER TABLE integrarp.pedido_item ADD CONSTRAINT fk_pedido_item_produto_tenant_v133
            FOREIGN KEY (tenant_id, produto_id) REFERENCES integrarp.produto (tenant_id, id) NOT VALID;
    END IF;
END $migration$;

-- VALIDATE é deliberado: dados órfãos interrompem o upgrade, sem exclusão automática.
ALTER TABLE integrarp.produto VALIDATE CONSTRAINT fk_produto_categoria_tenant_v133;
ALTER TABLE integrarp.pedido VALIDATE CONSTRAINT fk_pedido_cliente_tenant_v133;
ALTER TABLE integrarp.pedido_item VALIDATE CONSTRAINT fk_pedido_item_pedido_tenant_v133;
ALTER TABLE integrarp.pedido_item VALIDATE CONSTRAINT fk_pedido_item_produto_tenant_v133;
