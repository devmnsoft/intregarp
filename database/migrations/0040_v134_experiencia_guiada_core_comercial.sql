-- IntegraRP v1.34 - experiencia guiada e operacao comercial
-- PostgreSQL 16. Migration aditiva, idempotente e restrita ao schema integrarp.

CREATE TABLE IF NOT EXISTS integrarp.pedido_numeracao (
    tenant_id uuid NOT NULL,
    ano smallint NOT NULL,
    proximo_numero bigint NOT NULL DEFAULT 1,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    row_version bigint NOT NULL DEFAULT 1,
    CONSTRAINT pk_pedido_numeracao PRIMARY KEY (tenant_id, ano),
    CONSTRAINT ck_pedido_numeracao_ano CHECK (ano BETWEEN 2000 AND 9999),
    CONSTRAINT ck_pedido_numeracao_proximo CHECK (proximo_numero > 0),
    CONSTRAINT ck_pedido_numeracao_row_version CHECK (row_version > 0)
);

CREATE TABLE IF NOT EXISTS integrarp.usuario_preferencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NOT NULL,
    chave text NOT NULL,
    valor jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    row_version bigint NOT NULL DEFAULT 1,
    CONSTRAINT ck_usuario_preferencia_chave CHECK (length(btrim(chave)) BETWEEN 1 AND 120),
    CONSTRAINT ck_usuario_preferencia_valor CHECK (jsonb_typeof(valor) = 'object'),
    CONSTRAINT ck_usuario_preferencia_row_version CHECK (row_version > 0),
    CONSTRAINT ux_usuario_preferencia_tenant_usuario_chave UNIQUE (tenant_id, usuario_id, chave)
);

CREATE TABLE IF NOT EXISTS integrarp.notificacao_usuario (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NOT NULL,
    tipo text NOT NULL,
    titulo text NOT NULL,
    mensagem text NOT NULL,
    icone text,
    url text,
    prioridade text NOT NULL DEFAULT 'normal',
    lida_em timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    correlation_id text NOT NULL,
    row_version bigint NOT NULL DEFAULT 1,
    CONSTRAINT ck_notificacao_usuario_tipo CHECK (length(btrim(tipo)) BETWEEN 1 AND 80),
    CONSTRAINT ck_notificacao_usuario_titulo CHECK (length(btrim(titulo)) BETWEEN 1 AND 180),
    CONSTRAINT ck_notificacao_usuario_mensagem CHECK (length(btrim(mensagem)) BETWEEN 1 AND 2000),
    CONSTRAINT ck_notificacao_usuario_prioridade CHECK (prioridade IN ('baixa', 'normal', 'alta', 'urgente')),
    CONSTRAINT ck_notificacao_usuario_correlation CHECK (length(btrim(correlation_id)) BETWEEN 1 AND 160),
    CONSTRAINT ck_notificacao_usuario_row_version CHECK (row_version > 0)
);

CREATE INDEX IF NOT EXISTS ix_usuario_preferencia_tenant_usuario
    ON integrarp.usuario_preferencia (tenant_id, usuario_id);
CREATE INDEX IF NOT EXISTS ix_notificacao_usuario_pendentes
    ON integrarp.notificacao_usuario (tenant_id, usuario_id, criado_em DESC)
    WHERE lida_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_notificacao_usuario_correlation
    ON integrarp.notificacao_usuario (tenant_id, correlation_id);

COMMENT ON TABLE integrarp.pedido_numeracao IS 'Sequencia anual de pedidos isolada por tenant.';
COMMENT ON TABLE integrarp.usuario_preferencia IS 'Preferencias persistentes, incluindo progresso do onboarding, por tenant e usuario.';
COMMENT ON TABLE integrarp.notificacao_usuario IS 'Notificacoes internas persistentes e enderecadas por tenant e usuario.';
