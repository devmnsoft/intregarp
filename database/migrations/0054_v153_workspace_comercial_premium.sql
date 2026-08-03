-- IntegraRP v1.53 — Workspace Comercial Premium.
-- Evolução aditiva e multi-tenant para ordenação, preferências e ações reais.

ALTER TABLE integrarp.oportunidade_comercial
  ADD COLUMN IF NOT EXISTS posicao integer NOT NULL DEFAULT 0;

ALTER TABLE integrarp.atividade_comercial
  ADD COLUMN IF NOT EXISTS posicao integer NOT NULL DEFAULT 0;

CREATE INDEX IF NOT EXISTS ix_oportunidade_pipeline_ordem
  ON integrarp.oportunidade_comercial (tenant_id, etapa, posicao, atualizado_em DESC)
  WHERE removido_em IS NULL;

CREATE INDEX IF NOT EXISTS ix_atividade_agenda_ordem
  ON integrarp.atividade_comercial (tenant_id, responsavel_id, posicao, agendada_em)
  WHERE removido_em IS NULL AND concluida_em IS NULL AND cancelada_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.preferencia_interface (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  usuario_id uuid NOT NULL,
  tema text NOT NULL DEFAULT 'sistema',
  sidebar_recolhida boolean NOT NULL DEFAULT false,
  densidade text NOT NULL DEFAULT 'confortavel',
  criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NOT NULL DEFAULT now(),
  row_version bigint NOT NULL DEFAULT 1,
  CONSTRAINT ux_preferencia_interface_usuario UNIQUE (tenant_id, usuario_id),
  CONSTRAINT ck_preferencia_interface_tema CHECK (tema IN ('claro', 'escuro', 'sistema')),
  CONSTRAINT ck_preferencia_interface_densidade CHECK (densidade IN ('compacta', 'confortavel'))
);

CREATE TABLE IF NOT EXISTS integrarp.visao_salva (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL,
  recurso text NOT NULL, nome text NOT NULL, filtros_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  compartilhada boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NOT NULL DEFAULT now(), row_version bigint NOT NULL DEFAULT 1,
  CONSTRAINT ux_visao_salva_nome UNIQUE (tenant_id, usuario_id, recurso, nome)
);

CREATE TABLE IF NOT EXISTS integrarp.item_favorito (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL,
  recurso text NOT NULL, entidade_id uuid NOT NULL, titulo text NOT NULL, deep_link text NOT NULL,
  criado_em timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT ux_item_favorito UNIQUE (tenant_id, usuario_id, recurso, entidade_id)
);

CREATE TABLE IF NOT EXISTS integrarp.item_recente (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL,
  recurso text NOT NULL, entidade_id uuid NOT NULL, titulo text NOT NULL, deep_link text NOT NULL,
  acessado_em timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT ux_item_recente UNIQUE (tenant_id, usuario_id, recurso, entidade_id)
);
CREATE INDEX IF NOT EXISTS ix_item_recente_usuario
  ON integrarp.item_recente (tenant_id, usuario_id, acessado_em DESC);

CREATE TABLE IF NOT EXISTS integrarp.central_acao (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL,
  tipo text NOT NULL, entidade_tipo text NOT NULL, entidade_id uuid NOT NULL,
  titulo text NOT NULL, impacto text NOT NULL, responsavel_usuario_id uuid,
  prazo_em timestamptz, acao_recomendada text NOT NULL, deep_link text NOT NULL,
  prioridade smallint NOT NULL DEFAULT 2, status text NOT NULL DEFAULT 'aberta',
  resolvida_em timestamptz, criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NOT NULL DEFAULT now(), row_version bigint NOT NULL DEFAULT 1,
  CONSTRAINT ck_central_acao_prioridade CHECK (prioridade BETWEEN 1 AND 4),
  CONSTRAINT ck_central_acao_status CHECK (status IN ('aberta', 'em_andamento', 'resolvida', 'descartada')),
  CONSTRAINT ux_central_acao_aberta UNIQUE (tenant_id, tipo, entidade_tipo, entidade_id)
);
CREATE INDEX IF NOT EXISTS ix_central_acao_fila
  ON integrarp.central_acao (tenant_id, responsavel_usuario_id, prioridade, prazo_em)
  WHERE status IN ('aberta', 'em_andamento');

COMMENT ON TABLE integrarp.central_acao IS
  'Fila multi-tenant de pendências acionáveis, com impacto, responsável, prazo e deep link.';

INSERT INTO integrarp.schema_contract (
  contract_name, product_version, postgresql_major, schema_name, migration_count,
  manifest_generated_at_utc, installed_at, updated_at
) VALUES (
  'Banco Canônico Integrarp v1.53', 'v1.53', 16, 'integrarp', 54,
  '2026-08-03T00:00:00Z'::timestamptz, now(), now()
)
ON CONFLICT (contract_name) DO UPDATE SET
  product_version = EXCLUDED.product_version,
  migration_count = EXCLUDED.migration_count,
  manifest_generated_at_utc = EXCLUDED.manifest_generated_at_utc,
  updated_at = now();
