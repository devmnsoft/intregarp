-- IntegraRP v1.27 - Operacao Comercial Executavel, UX Premium e Release Homologada
-- PostgreSQL 16; schema integrarp; migration aditiva e idempotente.


ALTER TABLE IF EXISTS integrarp.auditoria_evento
    ADD COLUMN IF NOT EXISTS antes_json jsonb,
    ADD COLUMN IF NOT EXISTS depois_json jsonb,
    ADD COLUMN IF NOT EXISTS ip text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS atualizado_em timestamptz,
    ADD COLUMN IF NOT EXISTS excluido_em timestamptz;

ALTER TABLE IF EXISTS integrarp.outbox_evento
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS atualizado_em timestamptz,
    ADD COLUMN IF NOT EXISTS excluido_em timestamptz,
    ADD COLUMN IF NOT EXISTS dead_letter_em timestamptz;

ALTER TABLE IF EXISTS integrarp.worker_tenant_job_lock
    ADD COLUMN IF NOT EXISTS started_at timestamptz,
    ADD COLUMN IF NOT EXISTS duration_ms bigint NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS attempts integer NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS integrarp.worker_dead_letter
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS integrarp.pedido_historico_status
    ADD COLUMN IF NOT EXISTS usuario_id uuid,
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS atualizado_em timestamptz,
    ADD COLUMN IF NOT EXISTS excluido_em timestamptz;

ALTER TABLE IF EXISTS integrarp.estoque_movimento
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS usuario_id uuid,
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS integrarp.estoque_reserva
    ADD COLUMN IF NOT EXISTS usuario_id uuid,
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS integrarp.tarefa_operacional
    ADD COLUMN IF NOT EXISTS descricao text,
    ADD COLUMN IF NOT EXISTS setor text,
    ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid,
    ADD COLUMN IF NOT EXISTS prioridade text NOT NULL DEFAULT 'normal',
    ADD COLUMN IF NOT EXISTS sla_minutos integer,
    ADD COLUMN IF NOT EXISTS checklist_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    ADD COLUMN IF NOT EXISTS iniciado_em timestamptz,
    ADD COLUMN IF NOT EXISTS concluido_em timestamptz,
    ADD COLUMN IF NOT EXISTS cancelado_em timestamptz,
    ADD COLUMN IF NOT EXISTS motivo_cancelamento text,
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

CREATE INDEX IF NOT EXISTS ix_pedido_historico_status_pedido ON integrarp.pedido_historico_status (tenant_id, pedido_id, criado_em DESC);
CREATE INDEX IF NOT EXISTS ix_pedido_historico_status_tenant_data ON integrarp.pedido_historico_status (tenant_id, criado_em DESC);
CREATE UNIQUE INDEX IF NOT EXISTS ux_outbox_evento_idempotency ON integrarp.outbox_evento (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_vencimento ON integrarp.tarefa_operacional (tenant_id, vencimento_em) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_estoque_reserva_tenant_status ON integrarp.estoque_reserva (tenant_id, status);

DO $$
BEGIN
    IF to_regclass('integrarp.v125_audit_evento') IS NOT NULL AND to_regclass('integrarp.v125_audit_evento_legacy') IS NULL AND to_regclass('integrarp.auditoria_evento') IS NOT NULL THEN
        EXECUTE 'INSERT INTO integrarp.auditoria_evento (id, tenant_id, usuario_id, entidade, entidade_id, acao, detalhes, correlation_id, criado_em) SELECT id, tenant_id, usuario_id, entidade, entidade_id, acao, detalhes, correlation_id, criado_em FROM integrarp.v125_audit_evento ON CONFLICT (id) DO NOTHING';
        ALTER TABLE integrarp.v125_audit_evento RENAME TO v125_audit_evento_legacy;
    END IF;
    IF to_regclass('integrarp.v125_outbox_evento') IS NOT NULL AND to_regclass('integrarp.v125_outbox_evento_legacy') IS NULL AND to_regclass('integrarp.outbox_evento') IS NOT NULL THEN
        EXECUTE 'INSERT INTO integrarp.outbox_evento (id, tenant_id, tipo, tipo_evento, payload, payload_json, status, tentativas, proxima_tentativa_em, correlation_id, criado_em, processado_em) SELECT id, tenant_id, tipo, tipo, payload, payload, status, tentativas, proxima_tentativa_em, correlation_id, criado_em, processado_em FROM integrarp.v125_outbox_evento ON CONFLICT (id) DO NOTHING';
        ALTER TABLE integrarp.v125_outbox_evento RENAME TO v125_outbox_evento_legacy;
    END IF;
    IF to_regclass('integrarp.v125_worker_lock') IS NOT NULL AND to_regclass('integrarp.v125_worker_lock_legacy') IS NULL AND to_regclass('integrarp.worker_tenant_job_lock') IS NOT NULL THEN
        EXECUTE 'INSERT INTO integrarp.worker_tenant_job_lock (tenant_id, job_name, locked_until, correlation_id, atualizado_em) SELECT tenant_id, job_name, locked_until, correlation_id, updated_at FROM integrarp.v125_worker_lock ON CONFLICT (tenant_id, job_name) DO UPDATE SET locked_until = EXCLUDED.locked_until, correlation_id = EXCLUDED.correlation_id, atualizado_em = EXCLUDED.atualizado_em';
        ALTER TABLE integrarp.v125_worker_lock RENAME TO v125_worker_lock_legacy;
    END IF;
    IF to_regclass('integrarp.v125_dashboard_agregado') IS NOT NULL AND to_regclass('integrarp.v125_dashboard_agregado_legacy') IS NULL THEN
        ALTER TABLE integrarp.v125_dashboard_agregado RENAME TO v125_dashboard_agregado_legacy;
    END IF;
END $$;

CREATE OR REPLACE VIEW integrarp.vw_dashboard_operacional AS
SELECT
    t.id AS tenant_id,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('confirmado','em_separacao','separado','faturamento_pendente','aberto','em_andamento','andamento','processando')), 0)::integer AS pedidos_em_andamento,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('rascunho','aguardando_confirmacao')), 0)::integer AS pedidos_aguardando_confirmacao,
    COALESCE((SELECT count(*) FROM integrarp.tarefa_operacional tf WHERE tf.tenant_id = t.id AND tf.vencimento_em < now() AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_vencidas,
    COALESCE((SELECT count(*) FROM integrarp.tarefa_operacional tf WHERE tf.tenant_id = t.id AND tf.vencimento_em::date = CURRENT_DATE AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_para_hoje,
    COALESCE((SELECT count(*) FROM integrarp.estoque_saldo es JOIN integrarp.produto p ON p.tenant_id = es.tenant_id AND p.id = es.produto_id WHERE es.tenant_id = t.id AND (COALESCE(es.quantidade, 0) - COALESCE(es.reservado, 0)) <= COALESCE(p.estoque_minimo, 0)), 0)::integer AS estoque_critico,
    COALESCE((SELECT count(*) FROM integrarp.estoque_reserva er WHERE er.tenant_id = t.id AND lower(COALESCE(er.status, '')) IN ('pendente','reservado')), 0)::integer AS reservas_pendentes,
    COALESCE((SELECT count(*) FROM integrarp.outbox_evento oe WHERE oe.tenant_id = t.id AND lower(COALESCE(oe.status, '')) IN ('erro','failed','falha')), 0)::integer AS outbox_com_erro,
    now() AS atualizado_em
FROM integrarp.tenant t;
