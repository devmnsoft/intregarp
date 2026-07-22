-- IntegraRP v1.24 - fundação de produção, autenticação Web e UX
-- PostgreSQL 16; schema integrarp; migration idempotente e aditiva.

ALTER TABLE IF EXISTS integrarp.usuario
    ADD COLUMN IF NOT EXISTS ultima_tentativa_invalida_em timestamptz;

UPDATE integrarp.usuario
   SET tentativas_invalidas = GREATEST(COALESCE(tentativas_invalidas, 0), COALESCE(failed_login_count, 0))
 WHERE EXISTS (
       SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'integrarp' AND table_name = 'usuario' AND column_name = 'failed_login_count')
   AND COALESCE(failed_login_count, 0) > COALESCE(tentativas_invalidas, 0);

UPDATE integrarp.usuario
   SET bloqueado_ate = lockout_until
 WHERE EXISTS (
       SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'integrarp' AND table_name = 'usuario' AND column_name = 'lockout_until')
   AND lockout_until IS NOT NULL
   AND (bloqueado_ate IS NULL OR lockout_until > bloqueado_ate);

UPDATE integrarp.usuario
   SET ultima_tentativa_invalida_em = last_failed_login_at
 WHERE EXISTS (
       SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'integrarp' AND table_name = 'usuario' AND column_name = 'last_failed_login_at')
   AND last_failed_login_at IS NOT NULL
   AND ultima_tentativa_invalida_em IS NULL;

ALTER TABLE IF EXISTS integrarp.usuario_credencial
    ADD COLUMN IF NOT EXISTS security_stamp uuid NOT NULL DEFAULT gen_random_uuid();

CREATE TABLE IF NOT EXISTS integrarp.auth_login_tentativa (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid,
    usuario_id uuid,
    email_normalizado text NOT NULL,
    sucesso boolean NOT NULL DEFAULT false,
    ip text,
    user_agent text,
    motivo text,
    correlation_id text,
    criado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE IF EXISTS integrarp.auth_login_tentativa
    ADD COLUMN IF NOT EXISTS user_agent text,
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS reason text,
    ADD COLUMN IF NOT EXISTS correlation_id text;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'auth_login_tentativa' AND column_name = 'reason') THEN
        UPDATE integrarp.auth_login_tentativa
           SET motivo = COALESCE(motivo, reason)
         WHERE motivo IS NULL AND reason IS NOT NULL;
        ALTER TABLE integrarp.auth_login_tentativa ALTER COLUMN reason DROP NOT NULL;
    END IF;
END $$;

INSERT INTO integrarp.auth_login_tentativa (id, tenant_id, usuario_id, email_normalizado, sucesso, ip, user_agent, motivo, correlation_id, criado_em)
SELECT a.id, a.tenant_id, a.usuario_id, a.email_normalizado, a.success, a.ip_address::text, NULL::text, a.failure_reason, a.correlation_id, a.criado_em
  FROM integrarp.auth_login_attempt a
 WHERE EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'integrarp' AND table_name = 'auth_login_attempt' AND table_type = 'BASE TABLE')
   AND NOT EXISTS (SELECT 1 FROM integrarp.auth_login_tentativa t WHERE t.id = a.id);

CREATE INDEX IF NOT EXISTS ix_auth_login_tentativa_lookup
    ON integrarp.auth_login_tentativa (tenant_id, email_normalizado, criado_em DESC);

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'integrarp' AND table_name = 'usuario')
       AND NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_usuario_tenant_id_id') THEN
        ALTER TABLE integrarp.usuario
            ADD CONSTRAINT uq_usuario_tenant_id_id UNIQUE (tenant_id, id);
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'integrarp' AND table_name = 'auth_password_history')
       AND NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_auth_password_history_usuario') THEN
        ALTER TABLE integrarp.auth_password_history
            ADD CONSTRAINT fk_auth_password_history_usuario
            FOREIGN KEY (tenant_id, usuario_id) REFERENCES integrarp.usuario (tenant_id, id);
    END IF;
END $$;

CREATE OR REPLACE VIEW integrarp.vw_dashboard_operacional AS
SELECT
    t.id AS tenant_id,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('aberto','em_andamento','andamento','processando')), 0)::integer AS pedidos_em_andamento,
    COALESCE((SELECT count(*) FROM integrarp.tarefa tf WHERE tf.tenant_id = t.id AND tf.prazo_em < now() AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_vencidas,
    COALESCE((SELECT count(*) FROM integrarp.processo_instancia fi WHERE fi.tenant_id = t.id AND lower(COALESCE(fi.status, '')) IN ('ativo','ativa','em_andamento','running')), 0)::integer AS processos_ativos,
    COALESCE((SELECT count(*) FROM integrarp.outbox_evento oe WHERE oe.tenant_id = t.id AND lower(COALESCE(oe.status, '')) IN ('erro','failed','falha')), 0)::integer AS outbox_com_erro,
    now() AS atualizado_em
FROM integrarp.tenant t;
