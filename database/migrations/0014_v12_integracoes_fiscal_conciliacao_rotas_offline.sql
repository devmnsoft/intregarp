CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.schema_migrations (version text PRIMARY KEY, applied_at timestamptz NOT NULL DEFAULT now());

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em() RETURNS trigger AS $$ BEGIN NEW.atualizado_em = now(); RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS integrarp.integracao_conector (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_conector ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_conector_tenant_status ON integrarp.integracao_conector (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_conector_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_conector ADD CONSTRAINT ck_integracao_conector_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_conector_atualizado_em ON integrarp.integracao_conector; CREATE TRIGGER trg_integracao_conector_atualizado_em BEFORE UPDATE ON integrarp.integracao_conector FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_conector_configuracao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_conector_configuracao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_conector_configuracao_tenant_status ON integrarp.integracao_conector_configuracao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_conector_configuracao_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_conector_configuracao ADD CONSTRAINT ck_integracao_conector_configuracao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_conector_configuracao_atualizado_em ON integrarp.integracao_conector_configuracao; CREATE TRIGGER trg_integracao_conector_configuracao_atualizado_em BEFORE UPDATE ON integrarp.integracao_conector_configuracao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_credencial_referencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_credencial_referencia ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_credencial_referencia_tenant_status ON integrarp.integracao_credencial_referencia (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_credencial_referencia_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_credencial_referencia ADD CONSTRAINT ck_integracao_credencial_referencia_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_credencial_referencia_atualizado_em ON integrarp.integracao_credencial_referencia; CREATE TRIGGER trg_integracao_credencial_referencia_atualizado_em BEFORE UPDATE ON integrarp.integracao_credencial_referencia FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_execucao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_execucao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_execucao_tenant_status ON integrarp.integracao_execucao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_execucao_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_execucao ADD CONSTRAINT ck_integracao_execucao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_execucao_atualizado_em ON integrarp.integracao_execucao; CREATE TRIGGER trg_integracao_execucao_atualizado_em BEFORE UPDATE ON integrarp.integracao_execucao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_execucao_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_execucao_log ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_execucao_log_tenant_status ON integrarp.integracao_execucao_log (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_execucao_log_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_execucao_log ADD CONSTRAINT ck_integracao_execucao_log_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_execucao_log_atualizado_em ON integrarp.integracao_execucao_log; CREATE TRIGGER trg_integracao_execucao_log_atualizado_em BEFORE UPDATE ON integrarp.integracao_execucao_log FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_webhook_endpoint (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_webhook_endpoint ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_webhook_endpoint_tenant_status ON integrarp.integracao_webhook_endpoint (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_webhook_endpoint_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_webhook_endpoint ADD CONSTRAINT ck_integracao_webhook_endpoint_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_webhook_endpoint_atualizado_em ON integrarp.integracao_webhook_endpoint; CREATE TRIGGER trg_integracao_webhook_endpoint_atualizado_em BEFORE UPDATE ON integrarp.integracao_webhook_endpoint FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_webhook_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_webhook_evento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_webhook_evento_tenant_status ON integrarp.integracao_webhook_evento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_webhook_evento_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_webhook_evento ADD CONSTRAINT ck_integracao_webhook_evento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_webhook_evento_atualizado_em ON integrarp.integracao_webhook_evento; CREATE TRIGGER trg_integracao_webhook_evento_atualizado_em BEFORE UPDATE ON integrarp.integracao_webhook_evento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_mapeamento_campo (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_mapeamento_campo ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_mapeamento_campo_tenant_status ON integrarp.integracao_mapeamento_campo (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_mapeamento_campo_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_mapeamento_campo ADD CONSTRAINT ck_integracao_mapeamento_campo_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_mapeamento_campo_atualizado_em ON integrarp.integracao_mapeamento_campo; CREATE TRIGGER trg_integracao_mapeamento_campo_atualizado_em BEFORE UPDATE ON integrarp.integracao_mapeamento_campo FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_fila_saida (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_fila_saida ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_fila_saida_tenant_status ON integrarp.integracao_fila_saida (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_fila_saida_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_fila_saida ADD CONSTRAINT ck_integracao_fila_saida_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_fila_saida_atualizado_em ON integrarp.integracao_fila_saida; CREATE TRIGGER trg_integracao_fila_saida_atualizado_em BEFORE UPDATE ON integrarp.integracao_fila_saida FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_fila_entrada (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_fila_entrada ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_fila_entrada_tenant_status ON integrarp.integracao_fila_entrada (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_fila_entrada_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_fila_entrada ADD CONSTRAINT ck_integracao_fila_entrada_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_fila_entrada_atualizado_em ON integrarp.integracao_fila_entrada; CREATE TRIGGER trg_integracao_fila_entrada_atualizado_em BEFORE UPDATE ON integrarp.integracao_fila_entrada FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_configuracao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_configuracao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_configuracao_tenant_status ON integrarp.fiscal_configuracao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_configuracao_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_configuracao ADD CONSTRAINT ck_fiscal_configuracao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_configuracao_atualizado_em ON integrarp.fiscal_configuracao; CREATE TRIGGER trg_fiscal_configuracao_atualizado_em BEFORE UPDATE ON integrarp.fiscal_configuracao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_documento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz,
    xml_fake text,
    danfe_html_fake text,
    pedido_id uuid,
    fatura_id uuid,
    cliente_id uuid
);

ALTER TABLE integrarp.fiscal_documento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_documento_tenant_status ON integrarp.fiscal_documento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_documento_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_documento ADD CONSTRAINT ck_fiscal_documento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_documento_atualizado_em ON integrarp.fiscal_documento; CREATE TRIGGER trg_fiscal_documento_atualizado_em BEFORE UPDATE ON integrarp.fiscal_documento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_documento_item (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_documento_item ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_documento_item_tenant_status ON integrarp.fiscal_documento_item (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_documento_item_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_documento_item ADD CONSTRAINT ck_fiscal_documento_item_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_documento_item_atualizado_em ON integrarp.fiscal_documento_item; CREATE TRIGGER trg_fiscal_documento_item_atualizado_em BEFORE UPDATE ON integrarp.fiscal_documento_item FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_documento_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_documento_evento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_documento_evento_tenant_status ON integrarp.fiscal_documento_evento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_documento_evento_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_documento_evento ADD CONSTRAINT ck_fiscal_documento_evento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_documento_evento_atualizado_em ON integrarp.fiscal_documento_evento; CREATE TRIGGER trg_fiscal_documento_evento_atualizado_em BEFORE UPDATE ON integrarp.fiscal_documento_evento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_emissao_lote (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_emissao_lote ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_emissao_lote_tenant_status ON integrarp.fiscal_emissao_lote (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_emissao_lote_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_emissao_lote ADD CONSTRAINT ck_fiscal_emissao_lote_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_emissao_lote_atualizado_em ON integrarp.fiscal_emissao_lote; CREATE TRIGGER trg_fiscal_emissao_lote_atualizado_em BEFORE UPDATE ON integrarp.fiscal_emissao_lote FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_emissao_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_emissao_log ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_emissao_log_tenant_status ON integrarp.fiscal_emissao_log (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_emissao_log_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_emissao_log ADD CONSTRAINT ck_fiscal_emissao_log_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_emissao_log_atualizado_em ON integrarp.fiscal_emissao_log; CREATE TRIGGER trg_fiscal_emissao_log_atualizado_em BEFORE UPDATE ON integrarp.fiscal_emissao_log FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_cancelamento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_cancelamento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_cancelamento_tenant_status ON integrarp.fiscal_cancelamento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_cancelamento_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_cancelamento ADD CONSTRAINT ck_fiscal_cancelamento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_cancelamento_atualizado_em ON integrarp.fiscal_cancelamento; CREATE TRIGGER trg_fiscal_cancelamento_atualizado_em BEFORE UPDATE ON integrarp.fiscal_cancelamento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_carta_correcao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_carta_correcao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_carta_correcao_tenant_status ON integrarp.fiscal_carta_correcao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_carta_correcao_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_carta_correcao ADD CONSTRAINT ck_fiscal_carta_correcao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_carta_correcao_atualizado_em ON integrarp.fiscal_carta_correcao; CREATE TRIGGER trg_fiscal_carta_correcao_atualizado_em BEFORE UPDATE ON integrarp.fiscal_carta_correcao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_serie (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_serie ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_serie_tenant_status ON integrarp.fiscal_serie (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_serie_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_serie ADD CONSTRAINT ck_fiscal_serie_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_serie_atualizado_em ON integrarp.fiscal_serie; CREATE TRIGGER trg_fiscal_serie_atualizado_em BEFORE UPDATE ON integrarp.fiscal_serie FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_certificado_referencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_certificado_referencia ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_certificado_referencia_tenant_status ON integrarp.fiscal_certificado_referencia (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_certificado_referencia_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_certificado_referencia ADD CONSTRAINT ck_fiscal_certificado_referencia_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_certificado_referencia_atualizado_em ON integrarp.fiscal_certificado_referencia; CREATE TRIGGER trg_fiscal_certificado_referencia_atualizado_em BEFORE UPDATE ON integrarp.fiscal_certificado_referencia FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_provedor (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_provedor ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_provedor_tenant_status ON integrarp.fiscal_provedor (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_provedor_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_provedor ADD CONSTRAINT ck_fiscal_provedor_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_provedor_atualizado_em ON integrarp.fiscal_provedor; CREATE TRIGGER trg_fiscal_provedor_atualizado_em BEFORE UPDATE ON integrarp.fiscal_provedor FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_conta_bancaria (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_conta_bancaria ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_conta_bancaria_tenant_status ON integrarp.financeiro_conta_bancaria (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_conta_bancaria_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_conta_bancaria ADD CONSTRAINT ck_financeiro_conta_bancaria_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_conta_bancaria_atualizado_em ON integrarp.financeiro_conta_bancaria; CREATE TRIGGER trg_financeiro_conta_bancaria_atualizado_em BEFORE UPDATE ON integrarp.financeiro_conta_bancaria FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_extrato_importacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_extrato_importacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_extrato_importacao_tenant_status ON integrarp.financeiro_extrato_importacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_extrato_importacao_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_extrato_importacao ADD CONSTRAINT ck_financeiro_extrato_importacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_extrato_importacao_atualizado_em ON integrarp.financeiro_extrato_importacao; CREATE TRIGGER trg_financeiro_extrato_importacao_atualizado_em BEFORE UPDATE ON integrarp.financeiro_extrato_importacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_extrato_lancamento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_extrato_lancamento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_extrato_lancamento_tenant_status ON integrarp.financeiro_extrato_lancamento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_extrato_lancamento_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_extrato_lancamento ADD CONSTRAINT ck_financeiro_extrato_lancamento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_extrato_lancamento_atualizado_em ON integrarp.financeiro_extrato_lancamento; CREATE TRIGGER trg_financeiro_extrato_lancamento_atualizado_em BEFORE UPDATE ON integrarp.financeiro_extrato_lancamento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_conciliacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_conciliacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_conciliacao_tenant_status ON integrarp.financeiro_conciliacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_conciliacao_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_conciliacao ADD CONSTRAINT ck_financeiro_conciliacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_conciliacao_atualizado_em ON integrarp.financeiro_conciliacao; CREATE TRIGGER trg_financeiro_conciliacao_atualizado_em BEFORE UPDATE ON integrarp.financeiro_conciliacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_conciliacao_item (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_conciliacao_item ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_conciliacao_item_tenant_status ON integrarp.financeiro_conciliacao_item (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_conciliacao_item_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_conciliacao_item ADD CONSTRAINT ck_financeiro_conciliacao_item_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_conciliacao_item_atualizado_em ON integrarp.financeiro_conciliacao_item; CREATE TRIGGER trg_financeiro_conciliacao_item_atualizado_em BEFORE UPDATE ON integrarp.financeiro_conciliacao_item FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_baixa_sugerida (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_baixa_sugerida ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_baixa_sugerida_tenant_status ON integrarp.financeiro_baixa_sugerida (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_baixa_sugerida_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_baixa_sugerida ADD CONSTRAINT ck_financeiro_baixa_sugerida_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_baixa_sugerida_atualizado_em ON integrarp.financeiro_baixa_sugerida; CREATE TRIGGER trg_financeiro_baixa_sugerida_atualizado_em BEFORE UPDATE ON integrarp.financeiro_baixa_sugerida FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_regra_conciliacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_regra_conciliacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_regra_conciliacao_tenant_status ON integrarp.financeiro_regra_conciliacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_regra_conciliacao_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_regra_conciliacao ADD CONSTRAINT ck_financeiro_regra_conciliacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_regra_conciliacao_atualizado_em ON integrarp.financeiro_regra_conciliacao; CREATE TRIGGER trg_financeiro_regra_conciliacao_atualizado_em BEFORE UPDATE ON integrarp.financeiro_regra_conciliacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_alerta_inadimplencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_alerta_inadimplencia ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_alerta_inadimplencia_tenant_status ON integrarp.financeiro_alerta_inadimplencia (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_alerta_inadimplencia_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_alerta_inadimplencia ADD CONSTRAINT ck_financeiro_alerta_inadimplencia_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_alerta_inadimplencia_atualizado_em ON integrarp.financeiro_alerta_inadimplencia; CREATE TRIGGER trg_financeiro_alerta_inadimplencia_atualizado_em BEFORE UPDATE ON integrarp.financeiro_alerta_inadimplencia FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_projecao_recebivel (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_projecao_recebivel ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_projecao_recebivel_tenant_status ON integrarp.financeiro_projecao_recebivel (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_projecao_recebivel_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_projecao_recebivel ADD CONSTRAINT ck_financeiro_projecao_recebivel_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_projecao_recebivel_atualizado_em ON integrarp.financeiro_projecao_recebivel; CREATE TRIGGER trg_financeiro_projecao_recebivel_atualizado_em BEFORE UPDATE ON integrarp.financeiro_projecao_recebivel FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_otimizacao_execucao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_otimizacao_execucao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_otimizacao_execucao_tenant_status ON integrarp.rota_otimizacao_execucao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_otimizacao_execucao_tenant_not_empty') THEN ALTER TABLE integrarp.rota_otimizacao_execucao ADD CONSTRAINT ck_rota_otimizacao_execucao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_otimizacao_execucao_atualizado_em ON integrarp.rota_otimizacao_execucao; CREATE TRIGGER trg_rota_otimizacao_execucao_atualizado_em BEFORE UPDATE ON integrarp.rota_otimizacao_execucao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_otimizacao_parada (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz,
    latitude numeric(10,7), longitude numeric(10,7), ordem_original integer, ordem_sugerida integer
);

ALTER TABLE integrarp.rota_otimizacao_parada ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_otimizacao_parada_tenant_status ON integrarp.rota_otimizacao_parada (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_otimizacao_parada_tenant_not_empty') THEN ALTER TABLE integrarp.rota_otimizacao_parada ADD CONSTRAINT ck_rota_otimizacao_parada_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_otimizacao_parada_atualizado_em ON integrarp.rota_otimizacao_parada; CREATE TRIGGER trg_rota_otimizacao_parada_atualizado_em BEFORE UPDATE ON integrarp.rota_otimizacao_parada FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_otimizacao_resultado (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_otimizacao_resultado ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_otimizacao_resultado_tenant_status ON integrarp.rota_otimizacao_resultado (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_otimizacao_resultado_tenant_not_empty') THEN ALTER TABLE integrarp.rota_otimizacao_resultado ADD CONSTRAINT ck_rota_otimizacao_resultado_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_otimizacao_resultado_atualizado_em ON integrarp.rota_otimizacao_resultado; CREATE TRIGGER trg_rota_otimizacao_resultado_atualizado_em BEFORE UPDATE ON integrarp.rota_otimizacao_resultado FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_distancia_cache (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_distancia_cache ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_distancia_cache_tenant_status ON integrarp.rota_distancia_cache (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_distancia_cache_tenant_not_empty') THEN ALTER TABLE integrarp.rota_distancia_cache ADD CONSTRAINT ck_rota_distancia_cache_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_distancia_cache_atualizado_em ON integrarp.rota_distancia_cache; CREATE TRIGGER trg_rota_distancia_cache_atualizado_em BEFORE UPDATE ON integrarp.rota_distancia_cache FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_regra_otimizacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_regra_otimizacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_regra_otimizacao_tenant_status ON integrarp.rota_regra_otimizacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_regra_otimizacao_tenant_not_empty') THEN ALTER TABLE integrarp.rota_regra_otimizacao ADD CONSTRAINT ck_rota_regra_otimizacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_regra_otimizacao_atualizado_em ON integrarp.rota_regra_otimizacao; CREATE TRIGGER trg_rota_regra_otimizacao_atualizado_em BEFORE UPDATE ON integrarp.rota_regra_otimizacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_restricao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_restricao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_restricao_tenant_status ON integrarp.rota_restricao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_restricao_tenant_not_empty') THEN ALTER TABLE integrarp.rota_restricao ADD CONSTRAINT ck_rota_restricao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_restricao_atualizado_em ON integrarp.rota_restricao; CREATE TRIGGER trg_rota_restricao_atualizado_em BEFORE UPDATE ON integrarp.rota_restricao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_janela_entrega (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_janela_entrega ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_janela_entrega_tenant_status ON integrarp.rota_janela_entrega (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_janela_entrega_tenant_not_empty') THEN ALTER TABLE integrarp.rota_janela_entrega ADD CONSTRAINT ck_rota_janela_entrega_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_janela_entrega_atualizado_em ON integrarp.rota_janela_entrega; CREATE TRIGGER trg_rota_janela_entrega_atualizado_em BEFORE UPDATE ON integrarp.rota_janela_entrega FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_dispositivo (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_dispositivo ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_dispositivo_tenant_status ON integrarp.offline_dispositivo (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_dispositivo_tenant_not_empty') THEN ALTER TABLE integrarp.offline_dispositivo ADD CONSTRAINT ck_offline_dispositivo_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_dispositivo_atualizado_em ON integrarp.offline_dispositivo; CREATE TRIGGER trg_offline_dispositivo_atualizado_em BEFORE UPDATE ON integrarp.offline_dispositivo FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_pacote_sincronizacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_pacote_sincronizacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_pacote_sincronizacao_tenant_status ON integrarp.offline_pacote_sincronizacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_pacote_sincronizacao_tenant_not_empty') THEN ALTER TABLE integrarp.offline_pacote_sincronizacao ADD CONSTRAINT ck_offline_pacote_sincronizacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_pacote_sincronizacao_atualizado_em ON integrarp.offline_pacote_sincronizacao; CREATE TRIGGER trg_offline_pacote_sincronizacao_atualizado_em BEFORE UPDATE ON integrarp.offline_pacote_sincronizacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_item_sincronizacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_item_sincronizacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_item_sincronizacao_tenant_status ON integrarp.offline_item_sincronizacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_item_sincronizacao_tenant_not_empty') THEN ALTER TABLE integrarp.offline_item_sincronizacao ADD CONSTRAINT ck_offline_item_sincronizacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_item_sincronizacao_atualizado_em ON integrarp.offline_item_sincronizacao; CREATE TRIGGER trg_offline_item_sincronizacao_atualizado_em BEFORE UPDATE ON integrarp.offline_item_sincronizacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_conflito (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_conflito ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_conflito_tenant_status ON integrarp.offline_conflito (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_conflito_tenant_not_empty') THEN ALTER TABLE integrarp.offline_conflito ADD CONSTRAINT ck_offline_conflito_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_conflito_atualizado_em ON integrarp.offline_conflito; CREATE TRIGGER trg_offline_conflito_atualizado_em BEFORE UPDATE ON integrarp.offline_conflito FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_resolucao_conflito (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_resolucao_conflito ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_resolucao_conflito_tenant_status ON integrarp.offline_resolucao_conflito (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_resolucao_conflito_tenant_not_empty') THEN ALTER TABLE integrarp.offline_resolucao_conflito ADD CONSTRAINT ck_offline_resolucao_conflito_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_resolucao_conflito_atualizado_em ON integrarp.offline_resolucao_conflito; CREATE TRIGGER trg_offline_resolucao_conflito_atualizado_em BEFORE UPDATE ON integrarp.offline_resolucao_conflito FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_checkpoint (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_checkpoint ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_checkpoint_tenant_status ON integrarp.offline_checkpoint (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_checkpoint_tenant_not_empty') THEN ALTER TABLE integrarp.offline_checkpoint ADD CONSTRAINT ck_offline_checkpoint_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_checkpoint_atualizado_em ON integrarp.offline_checkpoint; CREATE TRIGGER trg_offline_checkpoint_atualizado_em BEFORE UPDATE ON integrarp.offline_checkpoint FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_log ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_log_tenant_status ON integrarp.offline_log (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_log_tenant_not_empty') THEN ALTER TABLE integrarp.offline_log ADD CONSTRAINT ck_offline_log_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_log_atualizado_em ON integrarp.offline_log; CREATE TRIGGER trg_offline_log_atualizado_em BEFORE UPDATE ON integrarp.offline_log FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE OR REPLACE VIEW integrarp.vw_v12_kpis AS SELECT 'integrations'::text AS modulo, count(*) AS total FROM integrarp.integracao_execucao;

INSERT INTO integrarp.integracao_conector (tenant_id,nome,codigo,tipo,secret_reference,metadata_json) VALUES ('00000000-0000-0000-0000-000000000001','Fiscal Fake v1.2','fiscal-fake','fiscal','vault://demo/fiscal-fake','{"demo":true}'::jsonb) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.integracao_conector (tenant_id,nome,codigo,tipo,secret_reference) VALUES ('00000000-0000-0000-0000-000000000001','Banco Fake v1.2','bank-fake','bank','vault://demo/bank-fake') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.financeiro_conta_bancaria (tenant_id,nome,codigo,tipo,metadata_json) VALUES ('00000000-0000-0000-0000-000000000001','Conta bancária demo','bank-demo','sandbox','{"banco":"Fake Bank"}'::jsonb) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.fiscal_documento (tenant_id,nome,codigo,status,xml_fake,danfe_html_fake,valor) VALUES ('00000000-0000-0000-0000-000000000001','Documento fiscal demo','nf-demo','emitida_fake','<nfeFake/>','<html><body>DANFE HTML fake demo</body></html>',123.45) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.financeiro_regra_conciliacao (tenant_id,nome,codigo,tipo) VALUES ('00000000-0000-0000-0000-000000000001','Regra valor/data demo','regra-demo','valor_data') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.rota_otimizacao_execucao (tenant_id,nome,codigo,status,metadata_json) VALUES ('00000000-0000-0000-0000-000000000001','Rota demo v1.2','rota-demo','otimizada','{"distancia_km":12.4}'::jsonb) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.offline_dispositivo (tenant_id,nome,codigo,tipo) VALUES ('00000000-0000-0000-0000-000000000001','Dispositivo offline demo','device-demo','mobile') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.schema_migrations (version) VALUES ('0014_v12_integracoes_fiscal_conciliacao_rotas_offline') ON CONFLICT DO NOTHING;
