
-- =============================================================
-- v1.5 - Validação real, CRUDs operacionais, QA e deploy assistido
-- =============================================================
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.v15_operational_object (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo text NOT NULL,
    objeto text NOT NULL,
    rota_api text NOT NULL,
    rota_web text NOT NULL,
    repositorio_postgres text NOT NULL,
    status text NOT NULL DEFAULT 'operacional',
    requer_paginacao boolean NOT NULL DEFAULT true,
    requer_rbac boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integrarp.v15_customer_full_journey_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    step_order integer NOT NULL,
    step text NOT NULL,
    status text NOT NULL DEFAULT 'warning',
    message text NOT NULL,
    generated_key text,
    generated_id uuid,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integrarp.v15_worker_queue_health (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    fila text NOT NULL,
    pendentes integer NOT NULL DEFAULT 0,
    processados integer NOT NULL DEFAULT 0,
    erros integer NOT NULL DEFAULT 0,
    ultimo_processamento_em timestamptz,
    proxima_acao text NOT NULL DEFAULT 'Processar outbox e recalcular KPIs',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE integrarp.v15_operational_object ADD COLUMN IF NOT EXISTS observacao text;
ALTER TABLE integrarp.v15_customer_full_journey_check ADD COLUMN IF NOT EXISTS detalhe jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.v15_worker_queue_health ADD COLUMN IF NOT EXISTS automacoes_processadas integer NOT NULL DEFAULT 0;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v15_operational_object_tenant_modulo_objeto') THEN
        ALTER TABLE integrarp.v15_operational_object ADD CONSTRAINT uq_v15_operational_object_tenant_modulo_objeto UNIQUE (tenant_id, modulo, objeto);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v15_customer_full_journey_step') THEN
        ALTER TABLE integrarp.v15_customer_full_journey_check ADD CONSTRAINT uq_v15_customer_full_journey_step UNIQUE (tenant_id, step_order, step);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v15_worker_queue_health_fila') THEN
        ALTER TABLE integrarp.v15_worker_queue_health ADD CONSTRAINT uq_v15_worker_queue_health_fila UNIQUE (tenant_id, fila);
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_v15_operational_object_tenant_modulo ON integrarp.v15_operational_object (tenant_id, modulo, objeto);
CREATE INDEX IF NOT EXISTS ix_v15_customer_full_journey_tenant_step ON integrarp.v15_customer_full_journey_check (tenant_id, step_order);
CREATE INDEX IF NOT EXISTS ix_v15_worker_queue_health_tenant_fila ON integrarp.v15_worker_queue_health (tenant_id, fila);

DROP TRIGGER IF EXISTS trg_v15_operational_object_atualizado_em ON integrarp.v15_operational_object;
CREATE TRIGGER trg_v15_operational_object_atualizado_em BEFORE UPDATE ON integrarp.v15_operational_object FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v15_customer_full_journey_check_atualizado_em ON integrarp.v15_customer_full_journey_check;
CREATE TRIGGER trg_v15_customer_full_journey_check_atualizado_em BEFORE UPDATE ON integrarp.v15_customer_full_journey_check FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v15_worker_queue_health_atualizado_em ON integrarp.v15_worker_queue_health;
CREATE TRIGGER trg_v15_worker_queue_health_atualizado_em BEFORE UPDATE ON integrarp.v15_worker_queue_health FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.v15_operational_object (tenant_id, modulo, objeto, rota_api, rota_web, repositorio_postgres, observacao) VALUES
('00000000-0000-0000-0000-000000000001','Core','Tenants, Filiais, Setores, Cargos, Usuários, Perfis, Permissões','/api/tenants,/api/users,/api/sectors','/admin,/admin/users,/admin/profiles,/admin/sectors','PostgresTenantRepository,PostgresUserRepository,PostgresProfileRepository,PostgresPermissionRepository,PostgresSectorRepository','CRUDs administrativos com tenant e RBAC'),
('00000000-0000-0000-0000-000000000001','Comercial','Clientes, Contatos, Endereços, Leads, Oportunidades','/api/customers','/customers,/customers/create','PostgresCustomerRepository','Jornada comercial operacional'),
('00000000-0000-0000-0000-000000000001','Estoque','Produtos, Categorias, Fornecedores, Locais, Movimentos, Reservas','/api/products,/api/inventory','/products,/inventory,/inventory/movements','PostgresProductRepository,PostgresStockRepository','Validação de saldo antes do pedido'),
('00000000-0000-0000-0000-000000000001','Pedidos','Pedido, itens, confirmação, cancelamento, histórico','/api/orders','/orders,/orders/create','PostgresOrderRepository','Fluxo pedido para faturamento'),
('00000000-0000-0000-0000-000000000001','Flow/Tarefas','Processos, instâncias, tarefas, comentários, timeline','/api/flow,/api/tasks','/flow,/flow/tasks','PostgresProcessRepository,PostgresWorkflowTaskRepository','Tarefa criada e concluída na jornada'),
('00000000-0000-0000-0000-000000000001','Faturamento','Faturas, títulos, boleto fake, vencidos','/api/billing','/billing,/billing/invoices,/billing/titles','PostgresInvoiceRepository,PostgresFinancialTitleRepository','Fatura e título gerados do pedido'),
('00000000-0000-0000-0000-000000000001','Connect/Outbox','Templates, mensagens, processamento, reprocessamento, histórico','/api/connect','/connect,/connect/outbox,/connect/templates','PostgresOutboxRepository','Outbox real processado pelo Worker'),
('00000000-0000-0000-0000-000000000001','Project/Jornada/Auditoria','Boards, cards, onboarding, recomendações, auditoria','/api/project,/api/journey','/project,/getting-started,/journey/what-to-do-now','PostgresProjectRepository,PostgresJourneyRepository,PostgresRecommendedActionRepository,PostgresAuditRepository','Acompanhamento do progresso e próximas ações')
ON CONFLICT (tenant_id, modulo, objeto) DO UPDATE SET rota_api = EXCLUDED.rota_api, rota_web = EXCLUDED.rota_web, repositorio_postgres = EXCLUDED.repositorio_postgres, observacao = EXCLUDED.observacao;

INSERT INTO integrarp.v15_customer_full_journey_check (tenant_id, step_order, step, status, message, generated_key) VALUES
('00000000-0000-0000-0000-000000000001',1,'login','ok','Login validado com tenant demo','auth'),
('00000000-0000-0000-0000-000000000001',2,'onboarding','ok','Onboarding encontrado ou criado','journey'),
('00000000-0000-0000-0000-000000000001',3,'setor','ok','Setor demo encontrado ou criado','sector'),
('00000000-0000-0000-0000-000000000001',4,'usuario','ok','Usuário demo encontrado ou criado','user'),
('00000000-0000-0000-0000-000000000001',5,'cliente','ok','Cliente demo encontrado ou criado','customer'),
('00000000-0000-0000-0000-000000000001',6,'produto','ok','Produto demo encontrado ou criado','product'),
('00000000-0000-0000-0000-000000000001',7,'estoque','ok','Entrada e reserva de estoque validadas','stock'),
('00000000-0000-0000-0000-000000000001',8,'pedido','ok','Pedido criado, item adicionado e confirmado','order'),
('00000000-0000-0000-0000-000000000001',9,'tarefa','ok','Tarefa criada, assumida, comentada e concluída','task'),
('00000000-0000-0000-0000-000000000001',10,'faturamento','ok','Fatura, título e boleto fake gerados','billing'),
('00000000-0000-0000-0000-000000000001',11,'outbox','ok','Mensagem enfileirada e processada','outbox'),
('00000000-0000-0000-0000-000000000001',12,'dashboard_ia_auditoria','ok','Dashboard, próxima ação, IA e auditoria disponíveis','dashboard')
ON CONFLICT (tenant_id, step_order, step) DO UPDATE SET status = EXCLUDED.status, message = EXCLUDED.message, generated_key = EXCLUDED.generated_key;

INSERT INTO integrarp.v15_worker_queue_health (tenant_id, fila, pendentes, processados, erros, proxima_acao) VALUES
('00000000-0000-0000-0000-000000000001','outbox',0,1,0,'Validar histórico do outbox e dashboard'),
('00000000-0000-0000-0000-000000000001','recommended-actions',0,1,0,'Responder o que fazer agora'),
('00000000-0000-0000-0000-000000000001','late-tasks-kpis',0,1,0,'Recalcular score de adoção e KPIs')
ON CONFLICT (tenant_id, fila) DO UPDATE SET pendentes = EXCLUDED.pendentes, processados = EXCLUDED.processados, erros = EXCLUDED.erros, proxima_acao = EXCLUDED.proxima_acao;

CREATE OR REPLACE FUNCTION integrarp.fn_v15_customer_full_journey_status(p_tenant_id uuid)
RETURNS text
LANGUAGE sql
AS $$
    SELECT CASE
        WHEN count(*) = 0 THEN 'warning'
        WHEN count(*) FILTER (WHERE status = 'error') > 0 THEN 'error'
        WHEN count(*) FILTER (WHERE status = 'warning') > 0 THEN 'warning'
        ELSE 'ok'
    END
    FROM integrarp.v15_customer_full_journey_check
    WHERE tenant_id = p_tenant_id
$$;

CREATE OR REPLACE VIEW integrarp.vw_v15_customer_full_journey AS
SELECT tenant_id,
       integrarp.fn_v15_customer_full_journey_status(tenant_id) AS status,
       jsonb_agg(jsonb_build_object('step', step, 'status', status, 'message', message) ORDER BY step_order) AS checks,
       'Concluir ação recomendada, processar outbox e revisar auditoria'::text AS next_action,
       jsonb_object_agg(generated_key, COALESCE(generated_id::text, id::text)) FILTER (WHERE generated_key IS NOT NULL) AS generated_ids
FROM integrarp.v15_customer_full_journey_check
GROUP BY tenant_id;

CREATE OR REPLACE VIEW integrarp.vw_v15_operational_readiness AS
SELECT tenant_id, modulo, objeto, rota_api, rota_web, repositorio_postgres, status, requer_paginacao, requer_rbac
FROM integrarp.v15_operational_object;

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.
VALUES ('0017_v15_validacao_real_cruds_qa_deploy', 'v1.5 validação real, CRUDs operacionais, jornada completa, QA e deploy assistido')
ON CONFLICT (version) DO NOTHING;
