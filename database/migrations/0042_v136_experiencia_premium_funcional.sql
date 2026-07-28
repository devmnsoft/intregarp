-- IntegraRP v1.36 - integridade multi-tenant e notificacoes operacionais
-- PostgreSQL 16; aditiva, idempotente e sem transacao de topo.

CREATE UNIQUE INDEX IF NOT EXISTS ux_usuario_tenant_id ON integrarp.usuario (tenant_id, id);

ALTER TABLE integrarp.notificacao_usuario ADD COLUMN IF NOT EXISTS idempotency_key text;
ALTER TABLE integrarp.notificacao_usuario ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();
ALTER TABLE integrarp.notificacao_usuario ADD COLUMN IF NOT EXISTS expira_em timestamptz;
ALTER TABLE integrarp.notificacao_usuario ADD COLUMN IF NOT EXISTS dados_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.notificacao_usuario ADD COLUMN IF NOT EXISTS origem text NOT NULL DEFAULT 'sistema';
ALTER TABLE integrarp.notificacao_usuario ADD COLUMN IF NOT EXISTS lida_por_usuario_id uuid;

DO $migration$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_usuario_preferencia_usuario') THEN
        ALTER TABLE integrarp.usuario_preferencia DROP CONSTRAINT fk_usuario_preferencia_usuario;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_usuario_preferencia_usuario_tenant') THEN
        ALTER TABLE integrarp.usuario_preferencia ADD CONSTRAINT fk_usuario_preferencia_usuario_tenant
            FOREIGN KEY (tenant_id, usuario_id) REFERENCES integrarp.usuario(tenant_id, id) ON DELETE CASCADE;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_notificacao_usuario_usuario') THEN
        ALTER TABLE integrarp.notificacao_usuario DROP CONSTRAINT fk_notificacao_usuario_usuario;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_notificacao_usuario_usuario_tenant') THEN
        ALTER TABLE integrarp.notificacao_usuario ADD CONSTRAINT fk_notificacao_usuario_usuario_tenant
            FOREIGN KEY (tenant_id, usuario_id) REFERENCES integrarp.usuario(tenant_id, id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_notificacao_usuario_lida_por_tenant') THEN
        ALTER TABLE integrarp.notificacao_usuario ADD CONSTRAINT fk_notificacao_usuario_lida_por_tenant
            FOREIGN KEY (tenant_id, lida_por_usuario_id) REFERENCES integrarp.usuario(tenant_id, id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_pedido_numeracao_tenant') THEN
        ALTER TABLE integrarp.pedido_numeracao ADD CONSTRAINT fk_pedido_numeracao_tenant
            FOREIGN KEY (tenant_id) REFERENCES integrarp.tenant(id) ON DELETE CASCADE;
    END IF;
END
$migration$;

CREATE UNIQUE INDEX IF NOT EXISTS ux_notificacao_usuario_idempotency
    ON integrarp.notificacao_usuario (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE INDEX IF NOT EXISTS ix_notificacao_usuario_nao_lida
    ON integrarp.notificacao_usuario (tenant_id, usuario_id, criado_em DESC) WHERE lida_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_notificacao_usuario_prioridade_data
    ON integrarp.notificacao_usuario (tenant_id, prioridade, criado_em DESC);
CREATE INDEX IF NOT EXISTS ix_notificacao_usuario_expiracao
    ON integrarp.notificacao_usuario (tenant_id, expira_em) WHERE expira_em IS NOT NULL;
CREATE INDEX IF NOT EXISTS ix_notificacao_usuario_deep_link
    ON integrarp.notificacao_usuario (tenant_id, url) WHERE url IS NOT NULL;
