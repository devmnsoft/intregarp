-- IntegraRP v1.35 - integridade da experiencia guiada funcional
-- PostgreSQL 16. Migration aditiva e idempotente; migrations 0001 a 0040 permanecem congeladas.

DO $migration$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_pedido_numeracao_tenant') THEN
        ALTER TABLE integrarp.pedido_numeracao
            ADD CONSTRAINT fk_pedido_numeracao_tenant FOREIGN KEY (tenant_id)
            REFERENCES integrarp.tenant(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_usuario_preferencia_tenant') THEN
        ALTER TABLE integrarp.usuario_preferencia
            ADD CONSTRAINT fk_usuario_preferencia_tenant FOREIGN KEY (tenant_id)
            REFERENCES integrarp.tenant(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_usuario_preferencia_usuario') THEN
        ALTER TABLE integrarp.usuario_preferencia
            ADD CONSTRAINT fk_usuario_preferencia_usuario FOREIGN KEY (usuario_id)
            REFERENCES integrarp.usuario(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_notificacao_usuario_tenant') THEN
        ALTER TABLE integrarp.notificacao_usuario
            ADD CONSTRAINT fk_notificacao_usuario_tenant FOREIGN KEY (tenant_id)
            REFERENCES integrarp.tenant(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_notificacao_usuario_usuario') THEN
        ALTER TABLE integrarp.notificacao_usuario
            ADD CONSTRAINT fk_notificacao_usuario_usuario FOREIGN KEY (usuario_id)
            REFERENCES integrarp.usuario(id) ON DELETE CASCADE;
    END IF;
END
$migration$;

CREATE INDEX IF NOT EXISTS ix_usuario_preferencia_onboarding
    ON integrarp.usuario_preferencia (tenant_id, usuario_id, atualizado_em DESC)
    WHERE chave = 'onboarding.v135';
CREATE INDEX IF NOT EXISTS ix_notificacao_usuario_prioridade
    ON integrarp.notificacao_usuario (tenant_id, usuario_id, prioridade, criado_em DESC)
    WHERE lida_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_pedido_numeracao_atualizacao
    ON integrarp.pedido_numeracao (tenant_id, atualizado_em DESC);
