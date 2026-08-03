-- IntegraRP v1.58 — experiência premium, preferências e suporte global auditável.

CREATE TABLE IF NOT EXISTS integrarp.superadmin_contexto_suporte (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  superadmin_usuario_id uuid NOT NULL,
  tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id),
  motivo text NOT NULL CHECK (length(btrim(motivo)) >= 10),
  iniciado_em timestamptz NOT NULL DEFAULT now(),
  expira_em timestamptz NOT NULL,
  encerrado_em timestamptz NULL,
  correlation_id text NOT NULL,
  CHECK (expira_em > iniciado_em),
  CHECK (expira_em <= iniciado_em + interval '2 hours')
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_superadmin_contexto_ativo
  ON integrarp.superadmin_contexto_suporte(superadmin_usuario_id)
  WHERE encerrado_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.usuario_preferencia_ui (
  tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id),
  usuario_id uuid NOT NULL,
  tema text NOT NULL DEFAULT 'system' CHECK (tema IN ('light','dark','system')),
  densidade text NOT NULL DEFAULT 'comfortable' CHECK (densidade IN ('comfortable','compact')),
  pagina_inicial text NOT NULL DEFAULT '/dashboard',
  filtros_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  colunas_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  favoritos_json jsonb NOT NULL DEFAULT '[]'::jsonb,
  recentes_json jsonb NOT NULL DEFAULT '[]'::jsonb,
  atualizado_em timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (tenant_id, usuario_id),
  FOREIGN KEY (tenant_id, usuario_id) REFERENCES integrarp.usuario(tenant_id, id)
);

CREATE OR REPLACE VIEW integrarp.vw_flow_dashboard_resumo AS
SELECT d.tenant_id,
 count(DISTINCT d.processo_definicao_id) FILTER (WHERE d.status='publicado') AS processos_publicados,
 count(DISTINCT i.processo_instancia_id) FILTER (WHERE i.status IN ('em_andamento','aguardando_tarefa')) AS processos_em_andamento,
 count(DISTINCT t.id) FILTER (WHERE t.status IN ('pendente','atribuida','em_execucao','pausada')) AS tarefas_abertas,
 count(DISTINCT t.id) FILTER (WHERE t.status IN ('pendente','atribuida','em_execucao','pausada') AND t.vencimento_em < now()) AS tarefas_atrasadas,
 count(DISTINCT i.processo_instancia_id) FILTER (WHERE i.status='concluido') AS processos_concluidos
FROM integrarp.processo_definicao d
LEFT JOIN integrarp.processo_instancia i ON i.tenant_id=d.tenant_id AND i.processo_definicao_id=d.processo_definicao_id AND i.excluido_em IS NULL
LEFT JOIN integrarp.tarefa t ON t.tenant_id=d.tenant_id AND t.processo_instancia_id=i.processo_instancia_id AND t.excluido_em IS NULL
WHERE d.excluido_em IS NULL
GROUP BY d.tenant_id;

INSERT INTO integrarp.schema_contract(contract_name,product_version,postgresql_major,schema_name,migration_count,manifest_generated_at_utc,installed_at,updated_at)
VALUES('Banco Canônico Integrarp v1.58','v1.58',16,'integrarp',58,'2026-08-03T00:00:00Z'::timestamptz,now(),now())
ON CONFLICT(contract_name) DO UPDATE SET product_version=EXCLUDED.product_version,migration_count=58,updated_at=now();
