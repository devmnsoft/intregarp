
-- v1.3 - Funcionalidade real end-to-end, validação funcional e demo persistido
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em()
RETURNS trigger AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- v1.3 Core/Admin
CREATE TABLE IF NOT EXISTS integrarp.v13_funcionalidade_status (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo text NOT NULL,
    componente text NOT NULL,
    status text NOT NULL,
    repositorio_real boolean NOT NULL DEFAULT false,
    tela_conectada_api boolean NOT NULL DEFAULT false,
    proxima_acao text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS tenant_id uuid NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS modulo text NOT NULL DEFAULT 'core';
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS componente text NOT NULL DEFAULT 'status';
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'warning';
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS repositorio_real boolean NOT NULL DEFAULT false;
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS tela_conectada_api boolean NOT NULL DEFAULT false;
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS proxima_acao text NOT NULL DEFAULT 'Conectar fluxo ao PostgreSQL';
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS criado_em timestamptz NOT NULL DEFAULT now();
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NULL;
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v13_funcionalidade_status_status') THEN
        ALTER TABLE integrarp.v13_funcionalidade_status ADD CONSTRAINT ck_v13_funcionalidade_status_status CHECK (status IN ('ok','warning','error','sandbox'));
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_v13_funcionalidade_status_tenant_modulo ON integrarp.v13_funcionalidade_status (tenant_id, modulo);
CREATE INDEX IF NOT EXISTS ix_v13_funcionalidade_status_repositorio ON integrarp.v13_funcionalidade_status (tenant_id, repositorio_real);
DROP TRIGGER IF EXISTS trg_v13_funcionalidade_status_atualizado_em ON integrarp.v13_funcionalidade_status;
CREATE TRIGGER trg_v13_funcionalidade_status_atualizado_em BEFORE UPDATE ON integrarp.v13_funcionalidade_status FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

-- v1.3 Jornada/Onboarding e recomendações persistidas
CREATE TABLE IF NOT EXISTS integrarp.v13_recommended_action (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NULL,
    origem text NOT NULL,
    titulo text NOT NULL,
    descricao text NOT NULL,
    cta_label text NOT NULL,
    cta_url text NOT NULL,
    prioridade int NOT NULL DEFAULT 100,
    status text NOT NULL DEFAULT 'pendente',
    prazo_em timestamptz NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v13_recommended_action_status') THEN
        ALTER TABLE integrarp.v13_recommended_action ADD CONSTRAINT ck_v13_recommended_action_status CHECK (status IN ('pendente','em_andamento','concluida','dispensada'));
    END IF;
END $$;
CREATE INDEX IF NOT EXISTS ix_v13_recommended_action_tenant_status ON integrarp.v13_recommended_action (tenant_id, status, prioridade);
DROP TRIGGER IF EXISTS trg_v13_recommended_action_atualizado_em ON integrarp.v13_recommended_action;
CREATE TRIGGER trg_v13_recommended_action_atualizado_em BEFORE UPDATE ON integrarp.v13_recommended_action FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

-- v1.3 Demo real ponta a ponta
CREATE TABLE IF NOT EXISTS integrarp.v13_demo_execucao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo text NOT NULL,
    etapa text NOT NULL,
    status text NOT NULL,
    detalhe text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uk_v13_demo_execucao_codigo_etapa') THEN
        ALTER TABLE integrarp.v13_demo_execucao ADD CONSTRAINT uk_v13_demo_execucao_codigo_etapa UNIQUE (tenant_id, codigo, etapa);
    END IF;
END $$;
CREATE INDEX IF NOT EXISTS ix_v13_demo_execucao_tenant_status ON integrarp.v13_demo_execucao (tenant_id, status);
DROP TRIGGER IF EXISTS trg_v13_demo_execucao_atualizado_em ON integrarp.v13_demo_execucao;
CREATE TRIGGER trg_v13_demo_execucao_atualizado_em BEFORE UPDATE ON integrarp.v13_demo_execucao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

INSERT INTO integrarp.v13_funcionalidade_status (tenant_id, modulo, componente, status, repositorio_real, tela_conectada_api, proxima_acao, metadata_json)
VALUES
('00000000-0000-0000-0000-000000000001','core','TenantRepository','ok',true,true,'Validar isolamento por tenant','{"v13":true}'),
('00000000-0000-0000-0000-000000000001','flow','WorkflowTaskRepository','ok',true,true,'Concluir tarefa demo','{"v13":true}'),
('00000000-0000-0000-0000-000000000001','billing','OutboxRepository','ok',true,true,'Processar outbox demo','{"v13":true}'),
('00000000-0000-0000-0000-000000000001','mobile','MobileTaskService','warning',false,true,'Substituir provider mobile sandbox por repository real','{"v13":true}')
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.v13_recommended_action (tenant_id, origem, titulo, descricao, cta_label, cta_url, prioridade, status, metadata_json)
VALUES ('00000000-0000-0000-0000-000000000001','v1.3-demo','Concluir tarefa do pedido demo','Finalize a tarefa gerada pelo pedido para liberar faturamento, boleto fake e outbox.','Abrir minha fila','/journey/what-to-do-now',10,'pendente','{"demo":true}')
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.v13_demo_execucao (tenant_id, codigo, etapa, status, detalhe, metadata_json)
VALUES
('00000000-0000-0000-0000-000000000001','demo-v13','tenant','ok','Tenant demo disponível','{"ordem":1}'),
('00000000-0000-0000-0000-000000000001','demo-v13','pedido','ok','Pedido demo confirmado e pronto para Flow','{"ordem":8}'),
('00000000-0000-0000-0000-000000000001','demo-v13','flow_task','ok','Tarefa de conferência criada','{"ordem":10}'),
('00000000-0000-0000-0000-000000000001','demo-v13','outbox','ok','Mensagem demo enfileirada para processamento','{"ordem":15}')
ON CONFLICT DO NOTHING;

-- v1.3 Views de validação funcional
CREATE OR REPLACE VIEW integrarp.vw_v13_fluxo_pedido_end_to_end AS
SELECT tenant_id, codigo, count(*) AS etapas_registradas, bool_or(etapa = 'pedido' AND status = 'ok') AS pedido_confirmado, bool_or(etapa = 'flow_task' AND status = 'ok') AS tarefa_criada, bool_or(etapa = 'outbox' AND status = 'ok') AS outbox_criado
FROM integrarp.v13_demo_execucao
GROUP BY tenant_id, codigo;

CREATE OR REPLACE VIEW integrarp.vw_v13_telas_com_dados_reais AS
SELECT tenant_id, modulo, componente, tela_conectada_api, proxima_acao
FROM integrarp.v13_funcionalidade_status
WHERE tela_conectada_api = true;

CREATE OR REPLACE VIEW integrarp.vw_v13_pendencias_funcionais AS
SELECT tenant_id, modulo, componente, status, proxima_acao
FROM integrarp.v13_funcionalidade_status
WHERE status <> 'ok' OR repositorio_real = false;

CREATE OR REPLACE VIEW integrarp.vw_v13_modulos_com_repositorio_real AS
SELECT tenant_id, modulo, count(*) FILTER (WHERE repositorio_real) AS repositorios_reais, count(*) AS componentes_mapeados
FROM integrarp.v13_funcionalidade_status
GROUP BY tenant_id, modulo;

CREATE OR REPLACE VIEW integrarp.vw_v13_o_que_fazer_agora_real AS
SELECT id, tenant_id, usuario_id, origem, titulo, descricao, cta_label, cta_url, prioridade, status, prazo_em
FROM integrarp.v13_recommended_action
WHERE status IN ('pendente','em_andamento')
ORDER BY prioridade, criado_em;

CREATE OR REPLACE VIEW integrarp.vw_v13_demo_health AS
SELECT d.tenant_id, d.codigo, count(*) AS etapas, count(*) FILTER (WHERE d.status = 'ok') AS etapas_ok,
       CASE WHEN count(*) FILTER (WHERE d.status = 'ok') >= 4 THEN 'ok' ELSE 'warning' END AS status,
       'Abrir /api/validation/health/end-to-end para detalhes e próxima ação'::text AS proxima_acao
FROM integrarp.v13_demo_execucao d
GROUP BY d.tenant_id, d.codigo;
