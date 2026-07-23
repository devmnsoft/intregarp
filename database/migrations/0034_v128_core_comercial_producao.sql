-- IntegraRP v1.28 - Core Comercial em Produção
-- PostgreSQL 16 | schema integrarp | migration aditiva e idempotente

CREATE SCHEMA IF NOT EXISTS integrarp;

ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS setor_id uuid;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS formulario_resposta_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS checklist_resposta_json jsonb NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS vencimento_em timestamptz;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS iniciado_em timestamptz;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS concluido_em timestamptz;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS cancelado_em timestamptz;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS motivo_cancelamento text;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS prioridade integer NOT NULL DEFAULT 3;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS sla_minutos integer;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS correlation_id uuid;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS pedido_id uuid;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS legado_setor_text text;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS legado_checklist_json jsonb;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa_operacional' AND column_name = 'checklist_json') THEN
        EXECUTE 'UPDATE integrarp.tarefa_operacional SET checklist_resposta_json = COALESCE(checklist_resposta_json, checklist_json, ''[]''::jsonb), legado_checklist_json = COALESCE(legado_checklist_json, checklist_json)';
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa_operacional' AND column_name = 'setor') THEN
        EXECUTE 'UPDATE integrarp.tarefa_operacional SET legado_setor_text = COALESCE(legado_setor_text, setor)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.setor') IS NOT NULL THEN
        ALTER TABLE integrarp.tarefa_operacional
            ADD CONSTRAINT fk_tarefa_operacional_setor
            FOREIGN KEY (tenant_id, setor_id) REFERENCES integrarp.setor(tenant_id, id) NOT VALID;
    END IF;
    IF to_regclass('integrarp.usuario') IS NOT NULL THEN
        ALTER TABLE integrarp.tarefa_operacional
            ADD CONSTRAINT fk_tarefa_operacional_responsavel
            FOREIGN KEY (tenant_id, responsavel_usuario_id) REFERENCES integrarp.usuario(tenant_id, id) NOT VALID;
    END IF;
    IF to_regclass('integrarp.pedido') IS NOT NULL THEN
        ALTER TABLE integrarp.tarefa_operacional
            ADD CONSTRAINT fk_tarefa_operacional_pedido
            FOREIGN KEY (tenant_id, pedido_id) REFERENCES integrarp.pedido(tenant_id, id) NOT VALID;
    END IF;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_responsavel ON integrarp.tarefa_operacional (tenant_id, responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_setor ON integrarp.tarefa_operacional (tenant_id, setor_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_status_vencimento ON integrarp.tarefa_operacional (tenant_id, status, vencimento_em);
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_pedido ON integrarp.tarefa_operacional (tenant_id, pedido_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_prioridade ON integrarp.tarefa_operacional (tenant_id, prioridade, vencimento_em);

ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS status_anterior text;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS status_novo text;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS motivo text;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS correlation_id uuid;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS usuario_id uuid;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS excluido_em timestamptz;

DO $$
BEGIN
    ALTER TABLE integrarp.pedido_historico_status
        ADD CONSTRAINT fk_pedido_historico_status_pedido_tenant
        FOREIGN KEY (tenant_id, pedido_id) REFERENCES integrarp.pedido(tenant_id, id) NOT VALID;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

CREATE INDEX IF NOT EXISTS ix_pedido_historico_status_pedido_data ON integrarp.pedido_historico_status (tenant_id, pedido_id, criado_em DESC);
CREATE INDEX IF NOT EXISTS ix_pedido_historico_status_tenant_status ON integrarp.pedido_historico_status (tenant_id, status_novo);

ALTER TABLE integrarp.outbox_evento ADD COLUMN IF NOT EXISTS idempotency_key text;
ALTER TABLE integrarp.outbox_evento ADD COLUMN IF NOT EXISTS max_tentativas integer NOT NULL DEFAULT 5;
ALTER TABLE integrarp.outbox_evento ADD COLUMN IF NOT EXISTS proxima_tentativa_em timestamptz;
ALTER TABLE integrarp.outbox_evento ADD COLUMN IF NOT EXISTS correlation_id uuid;
CREATE INDEX IF NOT EXISTS ix_outbox_evento_tenant_status_proxima ON integrarp.outbox_evento (tenant_id, status, proxima_tentativa_em);
CREATE UNIQUE INDEX IF NOT EXISTS ux_outbox_evento_tenant_idempotency ON integrarp.outbox_evento (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
