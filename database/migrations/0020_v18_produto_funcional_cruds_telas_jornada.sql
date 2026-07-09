CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- v1.8 - Produto funcional completo: auditoria de telas, catálogo de templates, jornada e dashboard.
CREATE TABLE IF NOT EXISTS integrarp.v18_screen_audit (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo text NOT NULL,
    rota_web text NOT NULL,
    controller_web text NULL,
    view_path text NULL,
    js_path text NULL,
    css_path text NULL,
    endpoint_api text NULL,
    use_case text NULL,
    repository text NULL,
    tabela_principal text NULL,
    permissao_rbac text NULL,
    tem_loading boolean NOT NULL DEFAULT false,
    trata_erro boolean NOT NULL DEFAULT false,
    trata_401 boolean NOT NULL DEFAULT false,
    trata_403 boolean NOT NULL DEFAULT false,
    tem_estado_vazio boolean NOT NULL DEFAULT false,
    tem_botao_principal boolean NOT NULL DEFAULT false,
    tem_ajuda_contextual boolean NOT NULL DEFAULT false,
    tem_proxima_acao boolean NOT NULL DEFAULT false,
    tem_consulta_filtro boolean NOT NULL DEFAULT false,
    tem_paginacao boolean NOT NULL DEFAULT false,
    funcional_status text NOT NULL DEFAULT 'Parcial',
    proxima_correcao text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.v18_template_catalog (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo text NOT NULL,
    nome text NOT NULL,
    descricao text NOT NULL,
    setor_dono text NOT NULL,
    etapas_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    responsaveis_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    sla_horas integer NOT NULL DEFAULT 24,
    formulario_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    acoes_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    kpis_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    mensagens_fake_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    proxima_acao text NOT NULL,
    permissoes_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.v18_functional_validation_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    area text NOT NULL,
    modulo text NOT NULL,
    status text NOT NULL DEFAULT 'warning',
    checks_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    erros_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    warnings_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    proxima_acao text NOT NULL,
    rota_relacionada text NULL,
    endpoint_relacionado text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v18_screen_audit_tenant_rota') THEN ALTER TABLE integrarp.v18_screen_audit ADD CONSTRAINT uq_v18_screen_audit_tenant_rota UNIQUE (tenant_id, rota_web); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v18_screen_audit_status') THEN ALTER TABLE integrarp.v18_screen_audit ADD CONSTRAINT ck_v18_screen_audit_status CHECK (funcional_status IN ('OK','Parcial','Mock','Quebrado','Não implementado')); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v18_template_catalog_codigo') THEN ALTER TABLE integrarp.v18_template_catalog ADD CONSTRAINT uq_v18_template_catalog_codigo UNIQUE (tenant_id, codigo); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v18_validation_area_modulo') THEN ALTER TABLE integrarp.v18_functional_validation_check ADD CONSTRAINT uq_v18_validation_area_modulo UNIQUE (tenant_id, area, modulo); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v18_validation_status') THEN ALTER TABLE integrarp.v18_functional_validation_check ADD CONSTRAINT ck_v18_validation_status CHECK (status IN ('ok','warning','error')); END IF; END $$;

CREATE INDEX IF NOT EXISTS ix_v18_screen_audit_tenant_modulo_status ON integrarp.v18_screen_audit(tenant_id, modulo, funcional_status);
CREATE INDEX IF NOT EXISTS ix_v18_template_catalog_tenant_ativo ON integrarp.v18_template_catalog(tenant_id, ativo, setor_dono);
CREATE INDEX IF NOT EXISTS ix_v18_validation_tenant_area_status ON integrarp.v18_functional_validation_check(tenant_id, area, status);

DROP TRIGGER IF EXISTS trg_v18_screen_audit_atualizado_em ON integrarp.v18_screen_audit;
CREATE TRIGGER trg_v18_screen_audit_atualizado_em BEFORE UPDATE ON integrarp.v18_screen_audit FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v18_template_catalog_atualizado_em ON integrarp.v18_template_catalog;
CREATE TRIGGER trg_v18_template_catalog_atualizado_em BEFORE UPDATE ON integrarp.v18_template_catalog FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v18_functional_validation_check_atualizado_em ON integrarp.v18_functional_validation_check;
CREATE TRIGGER trg_v18_functional_validation_check_atualizado_em BEFORE UPDATE ON integrarp.v18_functional_validation_check FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE OR REPLACE VIEW integrarp.vw_v18_dashboard_operacional AS
SELECT tenant_id,
       count(*) FILTER (WHERE area = 'dashboard' AND status = 'ok') AS checks_dashboard_ok,
       count(*) FILTER (WHERE status = 'warning') AS warnings,
       count(*) FILTER (WHERE status = 'error') AS errors,
       CASE WHEN count(*) FILTER (WHERE status = 'error') > 0 THEN 'error' WHEN count(*) FILTER (WHERE status = 'warning') > 0 THEN 'warning' ELSE 'ok' END AS status,
       jsonb_agg(jsonb_build_object('area', area, 'modulo', modulo, 'status', status, 'proxima_acao', proxima_acao) ORDER BY area, modulo) AS checks
FROM integrarp.v18_functional_validation_check
GROUP BY tenant_id;

INSERT INTO integrarp.v18_template_catalog (tenant_id, codigo, nome, descricao, setor_dono, etapas_json, responsaveis_json, sla_horas, formulario_json, acoes_json, kpis_json, mensagens_fake_json, proxima_acao, permissoes_json) VALUES
('00000000-0000-0000-0000-000000000001','pedido-faturamento','Pedido ao Faturamento','Fluxo operacional do pedido confirmado até fatura, título e outbox fake.','Financeiro','["Confirmar pedido","Reservar estoque","Gerar fatura","Gerar título","Enfileirar cobrança"]'::jsonb,'["Vendas","Financeiro"]'::jsonb,24,'{"campos":["pedido","cliente","valor"]}'::jsonb,'["confirmar","faturar","processar-outbox"]'::jsonb,'["tempo_faturamento","titulos_em_aberto"]'::jsonb,'["cobranca_fake"]'::jsonb,'Abrir pedidos faturáveis e gerar fatura.','["orders.billing","billing.write"]'::jsonb),
('00000000-0000-0000-0000-000000000001','separacao-pedido','Separação de Pedido','Checklist de separação com reserva e evidência operacional.','Logística','["Criar tarefa","Separar itens","Anexar evidência","Concluir tarefa"]'::jsonb,'["Logística","Operador"]'::jsonb,8,'{"checklist":["produto","quantidade","local"]}'::jsonb,'["assumir-tarefa","concluir-tarefa"]'::jsonb,'["pedidos_parados","tarefas_atrasadas"]'::jsonb,'["aviso_separacao_fake"]'::jsonb,'Abrir fila de tarefas de separação.','["tasks.claim","tasks.complete"]'::jsonb),
('00000000-0000-0000-0000-000000000001','entrega-pod','Entrega com POD','Entrega com foto, GPS e assinatura no mobile.','Campo','["Carregar rota","Registrar ocorrência","Capturar POD","Sincronizar"]'::jsonb,'["Motorista","Operador Campo"]'::jsonb,12,'{"evidencias":["foto","gps","assinatura"]}'::jsonb,'["registrar-ocorrencia","concluir-entrega"]'::jsonb,'["entregas_no_prazo","ocorrencias"]'::jsonb,'["pod_fake_log"]'::jsonb,'Abrir próximas entregas no mobile.','["mobile.tasks","operations.delivery"]'::jsonb)
ON CONFLICT (tenant_id, codigo) DO UPDATE SET nome = EXCLUDED.nome, descricao = EXCLUDED.descricao, atualizado_em = now();

INSERT INTO integrarp.v18_functional_validation_check (tenant_id, area, modulo, status, checks_json, warnings_json, proxima_acao, rota_relacionada, endpoint_relacionado) VALUES
('00000000-0000-0000-0000-000000000001','templates','operacional','ok','["catalogo_minimo","instalacao_mapeada"]'::jsonb,'[]'::jsonb,'Instalar template piloto e validar processo gerado.','/templates','/api/templates'),
('00000000-0000-0000-0000-000000000001','dashboard','home','warning','["cards_operacionais","scores","atividades"]'::jsonb,'["validar dados reais em PostgreSQL"]'::jsonb,'Executar smoke E2E e consultar integrarp.vw_v18_dashboard_operacional.','/','/api/dashboard'),
('00000000-0000-0000-0000-000000000001','cruds','essenciais','warning','["cliente","produto","pedido","tarefa","faturamento","outbox"]'::jsonb,'["validação local limitada por ausência do SDK .NET"]'::jsonb,'Executar CI com dotnet restore/build/test.','/customers','/api/customers')
ON CONFLICT (tenant_id, area, modulo) DO UPDATE SET status = EXCLUDED.status, checks_json = EXCLUDED.checks_json, warnings_json = EXCLUDED.warnings_json, proxima_acao = EXCLUDED.proxima_acao, atualizado_em = now();

INSERT INTO integrarp.schema_migrations (version, description)
VALUES ('0020_v18_produto_funcional_cruds_telas_jornada', 'v1.8 produto funcional, CRUDs, telas, templates, dashboard e jornada operacional')
ON CONFLICT (version) DO NOTHING;
