-- IntegraRP v1.47 — suporte transacional ao ciclo comercial executável.
CREATE TABLE IF NOT EXISTS integrarp.numeracao_comercial (
  tenant_id uuid NOT NULL,
  tipo varchar(20) NOT NULL,
  ano integer NOT NULL,
  proximo_numero bigint NOT NULL DEFAULT 1,
  atualizado_em timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT pk_numeracao_comercial PRIMARY KEY (tenant_id, tipo, ano),
  CONSTRAINT ck_numeracao_comercial_tipo CHECK (tipo IN ('orcamento','pedido')),
  CONSTRAINT ck_numeracao_comercial_valor CHECK (proximo_numero > 0)
);

CREATE TABLE IF NOT EXISTS integrarp.commercial_activity (
  commercial_activity_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  oportunidade_id uuid NULL,
  cliente_id uuid NULL,
  responsavel_id uuid NOT NULL,
  tipo varchar(24) NOT NULL,
  assunto varchar(200) NOT NULL,
  descricao text NULL,
  agendada_em timestamptz NOT NULL,
  concluida_em timestamptz NULL,
  cancelada_em timestamptz NULL,
  motivo_cancelamento text NULL,
  row_version bigint NOT NULL DEFAULT 1,
  criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT ck_commercial_activity_tipo CHECK (tipo IN ('ligacao','reuniao','email','tarefa','follow_up','anotacao')),
  CONSTRAINT ck_commercial_activity_version CHECK (row_version > 0)
);
CREATE INDEX IF NOT EXISTS ix_commercial_activity_tenant_due
  ON integrarp.commercial_activity (tenant_id, agendada_em)
  WHERE concluida_em IS NULL AND cancelada_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.commercial_idempotency (
  tenant_id uuid NOT NULL,
  operation varchar(80) NOT NULL,
  idempotency_key varchar(160) NOT NULL,
  resource_id uuid NOT NULL,
  response_json jsonb NULL,
  criado_em timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT pk_commercial_idempotency PRIMARY KEY (tenant_id, operation, idempotency_key)
);

CREATE TABLE IF NOT EXISTS integrarp.discount_approval_decision (
  discount_approval_decision_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  orcamento_id uuid NOT NULL,
  solicitante_id uuid NOT NULL,
  aprovador_id uuid NULL,
  percentual numeric(7,4) NOT NULL,
  status varchar(16) NOT NULL DEFAULT 'pendente',
  motivo text NULL,
  decidido_em timestamptz NULL,
  criado_em timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT ck_discount_approval_percent CHECK (percentual BETWEEN 0 AND 100),
  CONSTRAINT ck_discount_approval_status CHECK (status IN ('pendente','aprovado','rejeitado')),
  CONSTRAINT ck_discount_approval_rejection CHECK (status <> 'rejeitado' OR length(trim(motivo)) > 0)
);
CREATE INDEX IF NOT EXISTS ix_discount_approval_tenant_status
  ON integrarp.discount_approval_decision (tenant_id, status, criado_em DESC);

INSERT INTO integrarp.schema_contract (
  contract_name, product_version, postgresql_major, schema_name, migration_count, manifest_generated_at_utc
) VALUES ('Banco Canônico Integrarp v1.47', 'v1.47', 16, 'integrarp', 49, '2026-07-30T00:00:00Z'::timestamptz)
ON CONFLICT (contract_name) DO UPDATE SET product_version=EXCLUDED.product_version,
  migration_count=EXCLUDED.migration_count, manifest_generated_at_utc=EXCLUDED.manifest_generated_at_utc,
  updated_at=now();
