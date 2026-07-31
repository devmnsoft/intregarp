-- IntegraRP v1.49 — Orçamento ao Faturamento
-- Reconciliação aditiva do contrato canônico de tarefas operacionais.

ALTER TABLE integrarp.tarefa
  ADD COLUMN IF NOT EXISTS titulo text NULL,
  ADD COLUMN IF NOT EXISTS descricao text NULL,
  ADD COLUMN IF NOT EXISTS prioridade text NULL,
  ADD COLUMN IF NOT EXISTS responsavel_setor_id uuid NULL,
  ADD COLUMN IF NOT EXISTS processo_instancia_id uuid NULL,
  ADD COLUMN IF NOT EXISTS etapa_codigo text NULL,
  ADD COLUMN IF NOT EXISTS prazo_em timestamptz NULL,
  ADD COLUMN IF NOT EXISTS vencimento_em timestamptz NULL,
  ADD COLUMN IF NOT EXISTS iniciado_em timestamptz NULL,
  ADD COLUMN IF NOT EXISTS concluido_em timestamptz NULL,
  ADD COLUMN IF NOT EXISTS cancelado_em timestamptz NULL,
  ADD COLUMN IF NOT EXISTS motivo_cancelamento text NULL,
  ADD COLUMN IF NOT EXISTS criado_por uuid NULL,
  ADD COLUMN IF NOT EXISTS atualizado_por uuid NULL,
  ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NULL,
  ADD COLUMN IF NOT EXISTS excluido_em timestamptz NULL,
  ADD COLUMN IF NOT EXISTS row_version bigint NULL;

UPDATE integrarp.tarefa
SET titulo = COALESCE(
      NULLIF(btrim(descricao), ''),
      NULLIF(btrim(codigo), ''),
      NULLIF(btrim(nome), ''),
      'Tarefa migrada ' || id::text)
WHERE titulo IS NULL OR btrim(titulo) = '';

UPDATE integrarp.tarefa
SET prioridade = 'normal'
WHERE prioridade IS NULL OR btrim(prioridade) = '';

UPDATE integrarp.tarefa
SET vencimento_em = prazo_em
WHERE vencimento_em IS NULL AND prazo_em IS NOT NULL;

UPDATE integrarp.tarefa
SET atualizado_em = COALESCE(atualizado_em, criado_em, now()),
    row_version = COALESCE(row_version, 1),
    criado_por = COALESCE(criado_por, criado_por_usuario_id),
    atualizado_por = COALESCE(atualizado_por, atualizado_por_usuario_id),
    responsavel_setor_id = COALESCE(responsavel_setor_id, setor_id);

UPDATE integrarp.tarefa
SET status = CASE lower(status)
  WHEN 'aberta' THEN 'pendente'
  WHEN 'ativo' THEN 'pendente'
  WHEN 'em_andamento' THEN 'em_execucao'
  ELSE lower(status)
END
WHERE status IS NOT NULL;

DO $validation$
BEGIN
  IF EXISTS (
    SELECT 1 FROM integrarp.tarefa
    WHERE tenant_id IS NULL OR titulo IS NULL OR btrim(titulo) = ''
       OR prioridade IS NULL OR row_version IS NULL OR row_version < 1
  ) THEN
    RAISE EXCEPTION 'integrarp.tarefa contém registros incompatíveis com o contrato canônico v1.49';
  END IF;
END
$validation$;

ALTER TABLE integrarp.tarefa
  ALTER COLUMN titulo SET NOT NULL,
  ALTER COLUMN prioridade SET DEFAULT 'normal',
  ALTER COLUMN prioridade SET NOT NULL,
  ALTER COLUMN atualizado_em SET DEFAULT now(),
  ALTER COLUMN atualizado_em SET NOT NULL,
  ALTER COLUMN row_version SET DEFAULT 1,
  ALTER COLUMN row_version SET NOT NULL;

CREATE INDEX IF NOT EXISTS ix_tarefa_tenant_status_vencimento
  ON integrarp.tarefa (tenant_id, status, vencimento_em)
  WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_tenant_responsavel_status
  ON integrarp.tarefa (tenant_id, responsavel_usuario_id, status)
  WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_tenant_processo_etapa
  ON integrarp.tarefa (tenant_id, processo_instancia_id, etapa_codigo)
  WHERE excluido_em IS NULL;

CREATE OR REPLACE VIEW integrarp.vw_flow_tarefas_abertas AS
SELECT
    id AS tarefa_id,
    tenant_id,
    codigo,
    titulo,
    status,
    prioridade,
    vencimento_em AS prazo_em
FROM integrarp.tarefa
WHERE excluido_em IS NULL
  AND status IN ('pendente', 'atribuida', 'em_execucao', 'pausada');

CREATE OR REPLACE VIEW integrarp.vw_flow_tarefas_atrasadas AS
SELECT
    id AS tarefa_id,
    tenant_id,
    codigo,
    titulo,
    status,
    prioridade,
    vencimento_em AS prazo_em
FROM integrarp.tarefa
WHERE excluido_em IS NULL
  AND status IN ('pendente', 'atribuida', 'em_execucao', 'pausada')
  AND vencimento_em < now();

INSERT INTO integrarp.schema_contract (
  contract_name, product_version, postgresql_major, schema_name, migration_count,
  manifest_generated_at_utc, installed_at, updated_at
) VALUES (
  'Banco Canônico Integrarp v1.49', 'v1.49', 16, 'integrarp', 51,
  '2026-07-31T00:00:00Z'::timestamptz, now(), now()
)
ON CONFLICT (contract_name) DO UPDATE SET
  product_version = EXCLUDED.product_version,
  migration_count = EXCLUDED.migration_count,
  manifest_generated_at_utc = EXCLUDED.manifest_generated_at_utc,
  updated_at = now();
