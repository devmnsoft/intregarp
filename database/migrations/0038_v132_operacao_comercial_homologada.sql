-- Produto: IntegraRP
-- Versao: v1.32
-- PostgreSQL: 16
-- Schema: integrarp
-- Contrato: operacao-comercial-homologada
-- Migration aditiva e idempotente. Nao cria senha fixa.

ALTER TABLE integrarp.cliente ADD COLUMN IF NOT EXISTS documento_original text;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS subtotal numeric(18,2) NOT NULL DEFAULT 0;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS desconto_total numeric(18,2) NOT NULL DEFAULT 0;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS excluido_em timestamptz;
ALTER TABLE integrarp.pedido_item ADD COLUMN IF NOT EXISTS preco_tabela numeric(18,2);
UPDATE integrarp.pedido SET subtotal = total + desconto_total WHERE subtotal = 0 AND total <> 0;
ALTER TABLE integrarp.pedido_item ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();
ALTER TABLE integrarp.estoque_reserva ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
ALTER TABLE integrarp.tarefa_evidencia ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
ALTER TABLE integrarp.worker_dead_letter ADD COLUMN IF NOT EXISTS tentativas integer NOT NULL DEFAULT 1;
ALTER TABLE integrarp.worker_dead_letter ADD COLUMN IF NOT EXISTS resolvido_em timestamptz;

CREATE UNIQUE INDEX IF NOT EXISTS ux_usuario_tenant_id_v132 ON integrarp.usuario(tenant_id,id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_setor_tenant_id_v132 ON integrarp.setor(tenant_id,id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_movimento_idempotency_v132 ON integrarp.estoque_movimento(tenant_id,idempotency_key);
CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_reserva_idempotency_v132 ON integrarp.estoque_reserva(tenant_id,idempotency_key);
CREATE INDEX IF NOT EXISTS ix_worker_dead_letter_pending_v132 ON integrarp.worker_dead_letter(tenant_id,job_name,criado_em) WHERE resolvido_em IS NULL;

DO $migration$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='ck_pedido_totais_v132') THEN
        ALTER TABLE integrarp.pedido ADD CONSTRAINT ck_pedido_totais_v132 CHECK(subtotal >= 0 AND desconto_total >= 0 AND total >= 0 AND desconto_total <= subtotal) NOT VALID;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='ck_estoque_saldo_disponivel_v132') THEN
        ALTER TABLE integrarp.estoque_saldo ADD CONSTRAINT ck_estoque_saldo_disponivel_v132 CHECK(saldo_fisico >= saldo_reservado AND saldo_reservado >= 0) NOT VALID;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_evidencia_tarefa_tenant_v132') THEN
        ALTER TABLE integrarp.tarefa_evidencia ADD CONSTRAINT fk_evidencia_tarefa_tenant_v132 FOREIGN KEY(tenant_id,tarefa_id) REFERENCES integrarp.tarefa_operacional(tenant_id,id) NOT VALID;
    END IF;
END
$migration$;
ALTER TABLE integrarp.pedido VALIDATE CONSTRAINT ck_pedido_totais_v132;
ALTER TABLE integrarp.estoque_saldo VALIDATE CONSTRAINT ck_estoque_saldo_disponivel_v132;
ALTER TABLE integrarp.tarefa_evidencia VALIDATE CONSTRAINT fk_evidencia_tarefa_tenant_v132;
