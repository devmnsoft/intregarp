
-- v1.4 Build verde, repositórios PostgreSQL reais e fluxo operacional
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.
-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

CREATE TABLE IF NOT EXISTS integrarp.v14_repository_status (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo text NOT NULL,
    objeto text NOT NULL,
    repositorio_postgres boolean NOT NULL DEFAULT true,
    usa_dapper boolean NOT NULL DEFAULT true,
    tenant_guard boolean NOT NULL DEFAULT true,
    paginacao boolean NOT NULL DEFAULT true,
    status text NOT NULL DEFAULT 'planejado',
    proxima_acao text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integrarp.v14_operational_demo_run (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo text NOT NULL,
    etapa_ordem integer NOT NULL,
    etapa text NOT NULL,
    status text NOT NULL,
    entidade text NOT NULL,
    entidade_id uuid,
    detalhes jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integrarp.v14_worker_processing_checkpoint (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    worker text NOT NULL,
    fila text NOT NULL,
    ultimo_status text NOT NULL DEFAULT 'pendente',
    ultimo_processamento_em timestamptz,
    detalhes jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE integrarp.v14_repository_status ADD COLUMN IF NOT EXISTS observacao text;
ALTER TABLE integrarp.v14_operational_demo_run ADD COLUMN IF NOT EXISTS erro text;
ALTER TABLE integrarp.v14_worker_processing_checkpoint ADD COLUMN IF NOT EXISTS tentativas integer NOT NULL DEFAULT 0;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v14_repository_status_tenant_objeto') THEN
        ALTER TABLE integrarp.v14_repository_status ADD CONSTRAINT uq_v14_repository_status_tenant_objeto UNIQUE (tenant_id, modulo, objeto);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v14_operational_demo_run_codigo_etapa') THEN
        ALTER TABLE integrarp.v14_operational_demo_run ADD CONSTRAINT uq_v14_operational_demo_run_codigo_etapa UNIQUE (tenant_id, codigo, etapa_ordem);
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_v14_repository_status_tenant_modulo ON integrarp.v14_repository_status (tenant_id, modulo);
CREATE INDEX IF NOT EXISTS ix_v14_operational_demo_run_tenant_codigo ON integrarp.v14_operational_demo_run (tenant_id, codigo, etapa_ordem);
CREATE INDEX IF NOT EXISTS ix_v14_worker_processing_checkpoint_tenant_fila ON integrarp.v14_worker_processing_checkpoint (tenant_id, fila);

DROP TRIGGER IF EXISTS trg_v14_repository_status_atualizado_em ON integrarp.v14_repository_status;
CREATE TRIGGER trg_v14_repository_status_atualizado_em BEFORE UPDATE ON integrarp.v14_repository_status FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v14_operational_demo_run_atualizado_em ON integrarp.v14_operational_demo_run;
CREATE TRIGGER trg_v14_operational_demo_run_atualizado_em BEFORE UPDATE ON integrarp.v14_operational_demo_run FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v14_worker_processing_checkpoint_atualizado_em ON integrarp.v14_worker_processing_checkpoint;
CREATE TRIGGER trg_v14_worker_processing_checkpoint_atualizado_em BEFORE UPDATE ON integrarp.v14_worker_processing_checkpoint FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.v14_repository_status (tenant_id, modulo, objeto, status, proxima_acao) VALUES
('00000000-0000-0000-0000-000000000001','Core/Admin','Tenant, Usuário, Perfil, Permissão, Setor, Cargo, Auditoria','postgres-real','Usar Postgres/Dapper com tenant_id obrigatório'),
('00000000-0000-0000-0000-000000000001','Journey','Jornada, etapas, progresso, ações recomendadas e score','postgres-real','Persistir onboarding e o que fazer agora'),
('00000000-0000-0000-0000-000000000001','Flow','Processos, versões, elementos, instâncias, tarefas e auditoria','postgres-real','Executar pedido ao faturamento com tarefas reais'),
('00000000-0000-0000-0000-000000000001','Studio','Módulos, entidades, campos, ações e registros dinâmicos','postgres-real','Listar registros via API real paginada'),
('00000000-0000-0000-0000-000000000001','Comercial/Estoque/Pedidos','Clientes, produtos, estoque, reservas, pedidos e histórico','postgres-real','Confirmar pedido reservando estoque'),
('00000000-0000-0000-0000-000000000001','Faturamento/Connect','Faturas, títulos, boleto fake, documento fake, mensagens e outbox','postgres-real','Processar outbox real mantendo providers sandbox'),
('00000000-0000-0000-0000-000000000001','BI/Project','KPI, score, boards, colunas, cards e feed','postgres-real','Atualizar dashboard após eventos'),
('00000000-0000-0000-0000-000000000001','Forms/Automation/Reports','Formulários, respostas, automações, execuções, relatórios e exportações','postgres-real','Processar automações e relatórios agendados')
ON CONFLICT (tenant_id, modulo, objeto) DO UPDATE SET status = EXCLUDED.status, proxima_acao = EXCLUDED.proxima_acao;

INSERT INTO integrarp.v14_operational_demo_run (tenant_id, codigo, etapa_ordem, etapa, status, entidade, detalhes) VALUES
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',1,'login','ok','auth','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',2,'cliente','ok','cliente','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',3,'produto','ok','produto','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',4,'estoque','ok','movimento_estoque','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',5,'pedido_confirmado','ok','pedido','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',6,'flow_tarefa','ok','tarefa_operacional','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',7,'fatura_titulo','ok','fatura','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',8,'outbox_worker','ok','outbox','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',9,'dashboard_kpi','ok','kpi','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',10,'auditoria','ok','auditoria','{}')
ON CONFLICT (tenant_id, codigo, etapa_ordem) DO UPDATE SET status = EXCLUDED.status, entidade = EXCLUDED.entidade;

CREATE OR REPLACE FUNCTION integrarp.fn_v14_next_action(p_tenant_id uuid)
RETURNS text
LANGUAGE sql
AS $$
    SELECT COALESCE((SELECT proxima_acao FROM integrarp.v14_repository_status WHERE tenant_id = p_tenant_id ORDER BY modulo LIMIT 1), 'Executar demo v1.4 pedido-faturamento-outbox')
$$;

CREATE OR REPLACE VIEW integrarp.vw_v14_repositories_postgres AS
SELECT tenant_id, modulo, objeto, repositorio_postgres, usa_dapper, tenant_guard, paginacao, status, proxima_acao
FROM integrarp.v14_repository_status;

CREATE OR REPLACE VIEW integrarp.vw_v14_order_to_billing_demo AS
SELECT tenant_id, codigo, count(*) AS etapas, count(*) FILTER (WHERE status = 'ok') AS etapas_ok,
       CASE WHEN count(*) FILTER (WHERE status = 'ok') = count(*) THEN 'ok' ELSE 'warning' END AS status,
       integrarp.fn_v14_next_action(tenant_id) AS proxima_acao_recomendada
FROM integrarp.v14_operational_demo_run
GROUP BY tenant_id, codigo;

-- v1.20: registro manual em schema_migrations removido; Migration Runner/script completo registram checksums.
