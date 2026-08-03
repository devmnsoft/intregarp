-- IntegraRP v1.56 — operação canônica, tarefas e faturamento pendente.
-- Esta migration é aditiva, idempotente e preserva os registros da fila legada.

ALTER TABLE integrarp.tarefa
  ADD COLUMN IF NOT EXISTS pedido_id uuid NULL,
  ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

UPDATE integrarp.tarefa
SET status = CASE lower(btrim(status))
  WHEN 'aberta' THEN 'pendente'
  WHEN 'assumida' THEN 'atribuida'
  WHEN 'em_andamento' THEN 'em_execucao'
  WHEN 'concluido' THEN 'concluida'
  WHEN 'concluído' THEN 'concluida'
  ELSE lower(btrim(status))
END
WHERE lower(btrim(status)) IN
  ('aberta', 'assumida', 'em_andamento', 'concluido', 'concluído');

-- Preserva tarefas criadas pelo runtime anterior. Depois desta cópia a tabela
-- legada fica somente para leitura e integrarp.tarefa é a única fila gravável.
INSERT INTO integrarp.tarefa (
  id, tenant_id, pedido_id, codigo, titulo, status, prioridade,
  responsavel_usuario_id, vencimento_em, criado_em, atualizado_em,
  excluido_em, row_version, metadata_json
)
SELECT
  antiga.id,
  antiga.tenant_id,
  antiga.pedido_id,
  COALESCE(NULLIF(btrim(antiga.codigo), ''), 'TAR-' || upper(substr(antiga.id::text, 1, 8))),
  antiga.titulo,
  CASE lower(btrim(antiga.status))
    WHEN 'aberta' THEN 'pendente'
    WHEN 'assumida' THEN 'atribuida'
    WHEN 'em_andamento' THEN 'em_execucao'
    WHEN 'concluido' THEN 'concluida'
    WHEN 'concluído' THEN 'concluida'
    ELSE lower(btrim(antiga.status))
  END,
  COALESCE(NULLIF(btrim(antiga.prioridade), ''), 'normal'),
  antiga.responsavel_usuario_id,
  antiga.vencimento_em,
  antiga.criado_em,
  COALESCE(antiga.atualizado_em, antiga.criado_em),
  antiga.excluido_em,
  GREATEST(COALESCE(antiga.row_version, 1), 1),
  COALESCE(antiga.metadata_json, '{}'::jsonb) || jsonb_build_object('migrada_de', 'tarefa_operacional')
FROM integrarp.tarefa_operacional AS antiga
WHERE antiga.tenant_id IS NOT NULL
  AND antiga.titulo IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM integrarp.tarefa AS atual
    WHERE atual.id = antiga.id
  )
ON CONFLICT (id) DO NOTHING;

CREATE OR REPLACE FUNCTION integrarp.fn_tarefa_operacional_somente_leitura()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
  RAISE EXCEPTION USING
    ERRCODE = '55000',
    MESSAGE = 'integrarp.tarefa_operacional é somente leitura desde v1.56; grave em integrarp.tarefa';
END;
$function$;

DROP TRIGGER IF EXISTS trg_tarefa_operacional_somente_leitura ON integrarp.tarefa_operacional;
CREATE TRIGGER trg_tarefa_operacional_somente_leitura
BEFORE INSERT OR UPDATE OR DELETE ON integrarp.tarefa_operacional
FOR EACH STATEMENT EXECUTE FUNCTION integrarp.fn_tarefa_operacional_somente_leitura();

DO $validation$
BEGIN
  IF EXISTS (
    SELECT 1 FROM integrarp.tarefa
    WHERE status NOT IN ('pendente', 'atribuida', 'em_execucao', 'pausada', 'concluida', 'cancelada')
  ) THEN
    RAISE EXCEPTION 'Existem tarefas fora dos estados canônicos da v1.56';
  END IF;
END
$validation$;

ALTER TABLE integrarp.tarefa
  DROP CONSTRAINT IF EXISTS ck_tarefa_status_v156;
ALTER TABLE integrarp.tarefa
  ADD CONSTRAINT ck_tarefa_status_v156
  CHECK (status IN ('pendente', 'atribuida', 'em_execucao', 'pausada', 'concluida', 'cancelada'))
  NOT VALID;
ALTER TABLE integrarp.tarefa VALIDATE CONSTRAINT ck_tarefa_status_v156;

ALTER TABLE integrarp.faturamento_pendente
  DROP CONSTRAINT IF EXISTS ck_faturamento_pendente_status_v156;
ALTER TABLE integrarp.faturamento_pendente
  ADD CONSTRAINT ck_faturamento_pendente_status_v156
  CHECK (status IN ('pendente', 'em_analise', 'aguardando_correcao', 'pronto_para_faturar', 'cancelado'))
  NOT VALID;
ALTER TABLE integrarp.faturamento_pendente
  VALIDATE CONSTRAINT ck_faturamento_pendente_status_v156;

CREATE OR REPLACE VIEW integrarp.vw_flow_tarefas_abertas AS
SELECT id AS tarefa_id, tenant_id, codigo, titulo, status, prioridade,
       vencimento_em AS prazo_em
FROM integrarp.tarefa
WHERE excluido_em IS NULL
  AND status IN ('pendente', 'atribuida', 'em_execucao', 'pausada');

CREATE OR REPLACE VIEW integrarp.vw_flow_tarefas_atrasadas AS
SELECT id AS tarefa_id, tenant_id, codigo, titulo, status, prioridade,
       vencimento_em AS prazo_em
FROM integrarp.tarefa
WHERE excluido_em IS NULL
  AND status IN ('pendente', 'atribuida', 'em_execucao', 'pausada')
  AND vencimento_em < now();

CREATE OR REPLACE VIEW integrarp.vw_flow_dashboard_resumo AS
SELECT
  d.tenant_id,
  count(DISTINCT d.processo_definicao_id) FILTER (WHERE d.status = 'publicado') AS processos_publicados,
  count(DISTINCT i.processo_instancia_id) FILTER (
    WHERE i.status IN ('em_andamento', 'aguardando_tarefa')) AS processos_em_andamento,
  count(DISTINCT t.id) FILTER (
    WHERE t.status IN ('pendente', 'atribuida', 'em_execucao', 'pausada')) AS tarefas_abertas,
  count(DISTINCT t.id) FILTER (
    WHERE t.status IN ('pendente', 'atribuida', 'em_execucao', 'pausada')
      AND t.vencimento_em < now()) AS tarefas_atrasadas,
  count(DISTINCT i.processo_instancia_id) FILTER (WHERE i.status = 'concluido') AS processos_concluidos
FROM integrarp.processo_definicao AS d
LEFT JOIN integrarp.processo_instancia AS i
  ON i.tenant_id = d.tenant_id
 AND i.processo_definicao_id = d.processo_definicao_id
 AND i.excluido_em IS NULL
LEFT JOIN integrarp.tarefa AS t
  ON t.tenant_id = d.tenant_id
 AND t.processo_instancia_id = i.processo_instancia_id
 AND t.excluido_em IS NULL
WHERE d.excluido_em IS NULL
GROUP BY d.tenant_id;

COMMENT ON TABLE integrarp.tarefa IS
  'Fila canônica e única gravável de tarefas da operação IntegraRP v1.56.';
COMMENT ON TABLE integrarp.tarefa_operacional IS
  'Estrutura histórica somente leitura; registros preservados em integrarp.tarefa na v1.56.';

INSERT INTO integrarp.schema_contract (
  contract_name, product_version, postgresql_major, schema_name, migration_count,
  manifest_generated_at_utc, installed_at, updated_at
) VALUES (
  'Banco Canônico Integrarp v1.56', 'v1.56', 16, 'integrarp', 56,
  '2026-08-03T00:00:00Z'::timestamptz, now(), now()
)
ON CONFLICT (contract_name) DO UPDATE SET
  product_version = EXCLUDED.product_version,
  migration_count = EXCLUDED.migration_count,
  manifest_generated_at_utc = EXCLUDED.manifest_generated_at_utc,
  updated_at = now();
