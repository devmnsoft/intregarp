-- IntegraRP v1.57 — runtime canônico da operação.
-- A migration é aditiva e idempotente; tarefa_operacional permanece somente leitura.

ALTER TABLE integrarp.tarefa
  ADD COLUMN IF NOT EXISTS responsavel_email text NULL,
  ADD COLUMN IF NOT EXISTS formulario_resposta_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  ADD COLUMN IF NOT EXISTS checklist_resposta_json jsonb NOT NULL DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS correlation_id text NULL,
  ADD COLUMN IF NOT EXISTS sla_minutos integer NULL;

UPDATE integrarp.tarefa
SET status = CASE lower(btrim(status))
  WHEN 'aberta' THEN 'pendente'
  WHEN 'assumida' THEN 'atribuida'
  WHEN 'em_andamento' THEN 'em_execucao'
  ELSE lower(btrim(status))
END;

ALTER TABLE integrarp.tarefa DROP CONSTRAINT IF EXISTS ck_tarefa_status_v156;
ALTER TABLE integrarp.tarefa DROP CONSTRAINT IF EXISTS ck_tarefa_status_v157;
ALTER TABLE integrarp.tarefa ADD CONSTRAINT ck_tarefa_status_v157
  CHECK (status IN ('pendente','atribuida','em_execucao','pausada','concluida','cancelada')) NOT VALID;
ALTER TABLE integrarp.tarefa VALIDATE CONSTRAINT ck_tarefa_status_v157;

CREATE INDEX IF NOT EXISTS ix_tarefa_pedido_etapa_ativa_v157
  ON integrarp.tarefa(tenant_id,pedido_id,etapa_codigo)
  WHERE pedido_id IS NOT NULL AND status NOT IN ('concluida','cancelada') AND excluido_em IS NULL;

CREATE OR REPLACE VIEW integrarp.vw_flow_dashboard_resumo AS
SELECT d.tenant_id,
 count(DISTINCT d.processo_definicao_id) FILTER (WHERE d.status='publicado') AS processos_publicados,
 count(DISTINCT i.processo_instancia_id) FILTER (WHERE i.status IN ('em_andamento','aguardando_tarefa')) AS processos_em_andamento,
 count(DISTINCT t.id) FILTER (WHERE t.status IN ('pendente','atribuida','em_execucao','pausada')) AS tarefas_abertas,
 count(DISTINCT t.id) FILTER (WHERE t.status IN ('pendente','atribuida','em_execucao','pausada') AND t.vencimento_em<now()) AS tarefas_atrasadas,
 count(DISTINCT i.processo_instancia_id) FILTER (WHERE i.status='concluido') AS processos_concluidos
FROM integrarp.processo_definicao d
LEFT JOIN integrarp.processo_instancia i ON i.tenant_id=d.tenant_id AND i.processo_definicao_id=d.processo_definicao_id AND i.excluido_em IS NULL
LEFT JOIN integrarp.tarefa t ON t.tenant_id=d.tenant_id AND t.processo_instancia_id=i.processo_instancia_id AND t.excluido_em IS NULL
WHERE d.excluido_em IS NULL GROUP BY d.tenant_id;

COMMENT ON TABLE integrarp.tarefa IS 'Fila canônica gravável de tarefas operacionais do IntegraRP v1.57.';
COMMENT ON TABLE integrarp.tarefa_operacional IS 'Compatibilidade histórica somente leitura; nenhum writer produtivo pode utilizá-la.';

INSERT INTO integrarp.schema_contract(contract_name,product_version,postgresql_major,schema_name,migration_count,manifest_generated_at_utc,installed_at,updated_at)
VALUES('Banco Canônico Integrarp v1.57','v1.57',16,'integrarp',57,'2026-08-03T00:00:00Z'::timestamptz,now(),now())
ON CONFLICT(contract_name) DO UPDATE SET product_version=EXCLUDED.product_version,migration_count=57,updated_at=now();
