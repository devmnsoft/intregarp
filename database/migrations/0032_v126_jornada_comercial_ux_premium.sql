-- IntegraRP v1.26 - Jornada Comercial Real, UX Premium e Homologação Verde
-- PostgreSQL 16; schema integrarp; migration aditiva, idempotente.

ALTER TABLE IF EXISTS integrarp.auth_login_tentativa
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS reason text,
    ADD COLUMN IF NOT EXISTS user_agent text,
    ADD COLUMN IF NOT EXISTS correlation_id text;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'auth_login_tentativa' AND column_name = 'reason') THEN
        UPDATE integrarp.auth_login_tentativa
           SET motivo = COALESCE(motivo, reason)
         WHERE motivo IS NULL AND reason IS NOT NULL;
        ALTER TABLE integrarp.auth_login_tentativa ALTER COLUMN reason DROP NOT NULL;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'auth_login_attempt' AND column_name = 'failure_reason') THEN
        INSERT INTO integrarp.auth_login_tentativa (id, tenant_id, usuario_id, email_normalizado, sucesso, ip, user_agent, motivo, correlation_id, criado_em)
        SELECT a.id, a.tenant_id, a.usuario_id, a.email_normalizado, a.success, a.ip_address::text, NULL::text, a.failure_reason, a.correlation_id, a.criado_em
          FROM integrarp.auth_login_attempt a
         WHERE NOT EXISTS (SELECT 1 FROM integrarp.auth_login_tentativa t WHERE t.id = a.id);
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_auth_login_tentativa_tenant_sucesso_criado
    ON integrarp.auth_login_tentativa (tenant_id, sucesso, criado_em DESC);

CREATE TABLE IF NOT EXISTS integrarp.pedido_historico_status (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    pedido_id uuid NOT NULL,
    status_anterior text NULL,
    status_novo text NOT NULL,
    usuario_id uuid NULL,
    motivo text NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE IF EXISTS integrarp.estoque_movimento
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS correlation_id text;

ALTER TABLE IF EXISTS integrarp.estoque_reserva
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS correlation_id text;

CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_movimento_idempotency
    ON integrarp.estoque_movimento (tenant_id, idempotency_key)
    WHERE idempotency_key IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_reserva_idempotency
    ON integrarp.estoque_reserva (tenant_id, idempotency_key)
    WHERE idempotency_key IS NOT NULL;

CREATE OR REPLACE VIEW integrarp.vw_dashboard_operacional AS
SELECT
    t.id AS tenant_id,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('confirmado','em_separacao','separado','faturamento_pendente','aberto','em_andamento','andamento','processando')), 0)::integer AS pedidos_em_andamento,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('rascunho','aguardando_confirmacao')), 0)::integer AS pedidos_aguardando_confirmacao,
    COALESCE((SELECT count(*) FROM integrarp.tarefa tf WHERE tf.tenant_id = t.id AND tf.prazo_em < now() AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_vencidas,
    COALESCE((SELECT count(*) FROM integrarp.tarefa tf WHERE tf.tenant_id = t.id AND tf.prazo_em::date = CURRENT_DATE AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_para_hoje,
    COALESCE((SELECT count(*) FROM integrarp.estoque_saldo es JOIN integrarp.produto p ON p.tenant_id = es.tenant_id AND p.id = es.produto_id WHERE es.tenant_id = t.id AND COALESCE(es.quantidade_disponivel, es.quantidade, 0) <= COALESCE(p.estoque_minimo, 0)), 0)::integer AS estoque_critico,
    COALESCE((SELECT count(*) FROM integrarp.estoque_reserva er WHERE er.tenant_id = t.id AND lower(COALESCE(er.status, '')) IN ('pendente','reservado')), 0)::integer AS reservas_pendentes,
    COALESCE((SELECT count(*) FROM integrarp.outbox_evento oe WHERE oe.tenant_id = t.id AND lower(COALESCE(oe.status, '')) IN ('erro','failed','falha')), 0)::integer AS outbox_com_erro,
    now() AS atualizado_em
FROM integrarp.tenant t;
