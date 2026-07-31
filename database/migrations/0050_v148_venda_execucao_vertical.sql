-- IntegraRP v1.48 — Venda à Execução Vertical
-- Evolução aditiva das estruturas canônicas; migrations anteriores permanecem congeladas.

ALTER TABLE integrarp.commercial_activity
  ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'agendada',
  ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid NULL,
  ADD COLUMN IF NOT EXISTS concluida_em timestamptz NULL,
  ADD COLUMN IF NOT EXISTS cancelada_em timestamptz NULL,
  ADD COLUMN IF NOT EXISTS motivo_cancelamento text NULL,
  ADD COLUMN IF NOT EXISTS criado_por_usuario_id uuid NULL,
  ADD COLUMN IF NOT EXISTS atualizado_por_usuario_id uuid NULL,
  ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now(),
  ADD COLUMN IF NOT EXISTS excluido_em timestamptz NULL,
  ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;

CREATE INDEX IF NOT EXISTS ix_commercial_activity_vencidas
  ON integrarp.commercial_activity (tenant_id, agendada_para)
  WHERE excluido_em IS NULL AND status = 'agendada';

ALTER TABLE integrarp.discount_approval_decision
  ADD COLUMN IF NOT EXISTS politica_desconto_id uuid NULL,
  ADD COLUMN IF NOT EXISTS orcamento_id uuid NULL,
  ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
CREATE UNIQUE INDEX IF NOT EXISTS ux_discount_approval_decision_orcamento
  ON integrarp.discount_approval_decision (tenant_id, orcamento_id)
  WHERE orcamento_id IS NOT NULL;

ALTER TABLE integrarp.pedido
  ADD COLUMN IF NOT EXISTS orcamento_id uuid NULL,
  ADD COLUMN IF NOT EXISTS faturamento_status text NULL,
  ADD COLUMN IF NOT EXISTS faturamento_pendente_em timestamptz NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_orcamento
  ON integrarp.pedido (tenant_id, orcamento_id) WHERE orcamento_id IS NOT NULL;

CREATE TABLE IF NOT EXISTS integrarp.commercial_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  aggregate_type text NOT NULL,
  aggregate_id uuid NOT NULL,
  event_type text NOT NULL,
  actor_user_id uuid NULL,
  details_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  correlation_id text NOT NULL,
  criado_em timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS ix_commercial_history_timeline
  ON integrarp.commercial_history (tenant_id, aggregate_type, aggregate_id, criado_em DESC);

CREATE TABLE IF NOT EXISTS integrarp.tarefa_checklist_item (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  tarefa_id uuid NOT NULL,
  titulo text NOT NULL,
  obrigatorio boolean NOT NULL DEFAULT true,
  concluido boolean NOT NULL DEFAULT false,
  concluido_por_usuario_id uuid NULL,
  concluido_em timestamptz NULL,
  ordem integer NOT NULL DEFAULT 0,
  criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NOT NULL DEFAULT now(),
  row_version bigint NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, tarefa_id, id)
);
CREATE INDEX IF NOT EXISTS ix_tarefa_checklist_pendente
  ON integrarp.tarefa_checklist_item (tenant_id, tarefa_id, ordem) WHERE NOT concluido;

CREATE TABLE IF NOT EXISTS integrarp.faturamento_pendente (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  pedido_id uuid NOT NULL,
  processo_instancia_id uuid NULL,
  tarefa_id uuid NULL,
  status text NOT NULL DEFAULT 'pendente',
  criado_por_usuario_id uuid NULL,
  criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NOT NULL DEFAULT now(),
  row_version bigint NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, pedido_id)
);
CREATE INDEX IF NOT EXISTS ix_faturamento_pendente_fila
  ON integrarp.faturamento_pendente (tenant_id, criado_em) WHERE status = 'pendente';

-- A chave canônica de integrarp.tarefa é id; as views expõem o contrato Flow por alias.
CREATE OR REPLACE VIEW integrarp.vw_flow_tarefas_abertas AS
SELECT id AS tarefa_id, tenant_id, codigo, titulo, status, prioridade, prazo_em
FROM integrarp.tarefa
WHERE excluido_em IS NULL AND status IN ('aberta', 'atribuida', 'em_andamento');
CREATE OR REPLACE VIEW integrarp.vw_flow_tarefas_atrasadas AS
SELECT id AS tarefa_id, tenant_id, codigo, titulo, status, prioridade, prazo_em
FROM integrarp.tarefa
WHERE excluido_em IS NULL AND status <> 'concluida' AND prazo_em < now();

INSERT INTO integrarp.schema_contract (
  contract_name, product_version, postgresql_major, schema_name, migration_count,
  manifest_generated_at_utc, installed_at, updated_at
) VALUES (
  'Banco Canônico Integrarp v1.48', 'v1.48', 16, 'integrarp', 50,
  '2026-07-31T00:00:00Z'::timestamptz, now(), now()
)
ON CONFLICT (contract_name) DO UPDATE SET
  product_version = EXCLUDED.product_version,
  migration_count = EXCLUDED.migration_count,
  manifest_generated_at_utc = EXCLUDED.manifest_generated_at_utc,
  updated_at = now();
