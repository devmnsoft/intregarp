-- IntegraRP database complete idempotent script v1.1
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em()
RETURNS trigger AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Core
CREATE TABLE IF NOT EXISTS integrarp.schema_migrations (version varchar(32) PRIMARY KEY, aplicado_em timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS integrarp.tenant (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Segurança
CREATE TABLE IF NOT EXISTS integrarp.usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, email text NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.perfil (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, permissoes_json jsonb NOT NULL DEFAULT '[]'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Flow
CREATE TABLE IF NOT EXISTS integrarp.flow_tarefa (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, titulo text NOT NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Studio
CREATE TABLE IF NOT EXISTS integrarp.studio_modulo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Comercial
CREATE TABLE IF NOT EXISTS integrarp.pedido (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, numero text NOT NULL, status text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Estoque
CREATE TABLE IF NOT EXISTS integrarp.produto (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, sku text NOT NULL, nome text NOT NULL, estoque_atual numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Faturamento
CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, numero text NOT NULL, valor numeric NOT NULL, vencimento date NOT NULL, status text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Connect
CREATE TABLE IF NOT EXISTS integrarp.connect_outbox (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tipo text NOT NULL, payload_json jsonb NOT NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- BI
CREATE TABLE IF NOT EXISTS integrarp.kpi_valor (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, valor numeric NOT NULL, referencia_em timestamptz NOT NULL DEFAULT now(), criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Project
CREATE TABLE IF NOT EXISTS integrarp.project_board (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Mobile
CREATE TABLE IF NOT EXISTS integrarp.mobile_device (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NULL, push_token text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- IA
CREATE TABLE IF NOT EXISTS integrarp.ai_auditoria (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pergunta text NOT NULL, resposta text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Operações
CREATE TABLE IF NOT EXISTS integrarp.entrega (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, status text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

-- Forms
CREATE TABLE IF NOT EXISTS integrarp.formulario_definicao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, descricao text NULL, status text NOT NULL DEFAULT 'draft', versao_publicada_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_versao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_definicao_id uuid NOT NULL, numero int NOT NULL, publicado boolean NOT NULL DEFAULT false, publicado_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_secao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_versao_id uuid NOT NULL, titulo text NOT NULL, ordem int NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_campo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_secao_id uuid NOT NULL, chave text NOT NULL, rotulo text NOT NULL, tipo text NOT NULL, ordem int NOT NULL, obrigatorio boolean NOT NULL DEFAULT false, mascara text NULL, regex_validacao text NULL, valor_padrao text NULL, opcoes_json jsonb NOT NULL DEFAULT '[]'::jsonb, visibilidade_json jsonb NOT NULL DEFAULT '{}'::jsonb, calculo_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_regra (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_versao_id uuid NOT NULL, nome text NOT NULL, condicao_json jsonb NOT NULL, acao_json jsonb NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_resposta (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_versao_id uuid NOT NULL, entidade_tipo text NULL, entidade_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_resposta_campo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_resposta_id uuid NOT NULL, formulario_campo_id uuid NOT NULL, valor_json jsonb NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_template (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, template_json jsonb NOT NULL, demo boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_validacao_log (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_resposta_id uuid NULL, mensagem text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

-- Automação
CREATE TABLE IF NOT EXISTS integrarp.automacao_regra (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, habilitada boolean NOT NULL DEFAULT true, max_retries int NOT NULL DEFAULT 3, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.automacao_gatilho (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, automacao_regra_id uuid NOT NULL, tipo text NOT NULL, config_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.automacao_condicao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, automacao_regra_id uuid NOT NULL, campo text NOT NULL, operador text NOT NULL, valor_esperado text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.automacao_acao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, automacao_regra_id uuid NOT NULL, tipo text NOT NULL, ordem int NOT NULL, config_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.automacao_execucao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, automacao_regra_id uuid NOT NULL, status text NOT NULL DEFAULT 'pendente', tentativa int NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.automacao_execucao_log (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, automacao_execucao_id uuid NOT NULL, nivel text NOT NULL, mensagem text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

-- Anexos
CREATE TABLE IF NOT EXISTS integrarp.anexo_arquivo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome_arquivo text NOT NULL, content_type text NOT NULL, tamanho_bytes bigint NOT NULL, extensao text NOT NULL, sha256 text NOT NULL, storage_key text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_vinculo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, anexo_arquivo_id uuid NOT NULL, entidade_tipo text NOT NULL, entidade_id uuid NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_versao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, anexo_arquivo_id uuid NOT NULL, numero int NOT NULL, storage_key text NOT NULL, sha256 text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_auditoria (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, anexo_arquivo_id uuid NOT NULL, acao text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_thumbnail (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, anexo_arquivo_id uuid NOT NULL, storage_key text NOT NULL, largura int NOT NULL, altura int NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_assinatura (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, anexo_arquivo_id uuid NOT NULL, assinante text NOT NULL, assinado_em timestamptz NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_configuracao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, extensoes_permitidas text NOT NULL, tamanho_maximo_bytes bigint NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

-- Notificações
CREATE TABLE IF NOT EXISTS integrarp.notificacao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, evento text NOT NULL, titulo text NOT NULL, corpo text NOT NULL, canal text NOT NULL DEFAULT 'sistema', status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.notificacao_destinatario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, notificacao_id uuid NOT NULL, usuario_id uuid NOT NULL, lida boolean NOT NULL DEFAULT false, lida_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.notificacao_preferencia (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, canal text NOT NULL, habilitado boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.notificacao_template (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, evento text NOT NULL, canal text NOT NULL, assunto_template text NOT NULL, corpo_template text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.notificacao_push_log (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, notificacao_id uuid NOT NULL, canal text NOT NULL, status text NOT NULL, erro text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

-- Relatórios
CREATE TABLE IF NOT EXISTS integrarp.relatorio_definicao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, chave_consulta text NOT NULL, formatos_json jsonb NOT NULL DEFAULT '["csv","pdf_html","json"]'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.relatorio_filtro (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, relatorio_definicao_id uuid NOT NULL, nome text NOT NULL, tipo text NOT NULL, obrigatorio boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.relatorio_execucao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, relatorio_definicao_id uuid NOT NULL, status text NOT NULL DEFAULT 'pendente', parametros_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.relatorio_exportacao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, relatorio_execucao_id uuid NOT NULL, formato text NOT NULL, storage_key text NOT NULL, expira_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.relatorio_agendamento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, relatorio_definicao_id uuid NOT NULL, cron text NOT NULL, formato text NOT NULL, habilitado boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

ALTER TABLE integrarp.formulario_definicao ADD COLUMN IF NOT EXISTS categoria text NULL;
ALTER TABLE integrarp.automacao_regra ADD COLUMN IF NOT EXISTS seguranca_json jsonb NOT NULL DEFAULT '{"no_eval":true,"no_dynamic_sql":true,"rbac":true}'::jsonb;
ALTER TABLE integrarp.anexo_arquivo ADD COLUMN IF NOT EXISTS validado boolean NOT NULL DEFAULT true;
ALTER TABLE integrarp.relatorio_definicao ADD COLUMN IF NOT EXISTS descricao text NULL;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_formulario_campo_tipo_v11') THEN ALTER TABLE integrarp.formulario_campo ADD CONSTRAINT ck_formulario_campo_tipo_v11 CHECK (tipo IN ('text','textarea','number','money','date','datetime','boolean','select','multiselect','user','sector','client','product','order','financial_title','dynamic_record','file','photo','signature','gps','barcode','qrcode','rating','checklist','json','relation')); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_notificacao_canal_v11') THEN ALTER TABLE integrarp.notificacao ADD CONSTRAINT ck_notificacao_canal_v11 CHECK (canal IN ('sistema','email_fake','whatsapp_fake','telegram_fake','mobile_push_fake','webhook_fake')); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_relatorio_formato_v11') THEN ALTER TABLE integrarp.relatorio_exportacao ADD CONSTRAINT ck_relatorio_formato_v11 CHECK (formato IN ('csv','xlsx','pdf_html','json')); END IF; END $$;

CREATE INDEX IF NOT EXISTS ix_formulario_definicao_tenant ON integrarp.formulario_definicao(tenant_id);
CREATE INDEX IF NOT EXISTS ix_automacao_execucao_status ON integrarp.automacao_execucao(tenant_id,status);
CREATE INDEX IF NOT EXISTS ix_anexo_vinculo_entidade ON integrarp.anexo_vinculo(tenant_id,entidade_tipo,entidade_id);
CREATE INDEX IF NOT EXISTS ix_notificacao_destinatario_usuario ON integrarp.notificacao_destinatario(tenant_id,usuario_id,lida);
CREATE INDEX IF NOT EXISTS ix_relatorio_execucao_relatorio ON integrarp.relatorio_execucao(tenant_id,relatorio_definicao_id,status);

CREATE OR REPLACE VIEW integrarp.vw_v11_relatorios_demo AS SELECT tenant_id, nome, chave_consulta FROM integrarp.relatorio_definicao WHERE excluido_em IS NULL;

DROP TRIGGER IF EXISTS trg_formulario_definicao_atualizado_em ON integrarp.formulario_definicao;
CREATE TRIGGER trg_formulario_definicao_atualizado_em BEFORE UPDATE ON integrarp.formulario_definicao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_automacao_regra_atualizado_em ON integrarp.automacao_regra;
CREATE TRIGGER trg_automacao_regra_atualizado_em BEFORE UPDATE ON integrarp.automacao_regra FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_anexo_arquivo_atualizado_em ON integrarp.anexo_arquivo;
CREATE TRIGGER trg_anexo_arquivo_atualizado_em BEFORE UPDATE ON integrarp.anexo_arquivo FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_notificacao_atualizado_em ON integrarp.notificacao;
CREATE TRIGGER trg_notificacao_atualizado_em BEFORE UPDATE ON integrarp.notificacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_relatorio_definicao_atualizado_em ON integrarp.relatorio_definicao;
CREATE TRIGGER trg_relatorio_definicao_atualizado_em BEFORE UPDATE ON integrarp.relatorio_definicao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.tenant (id,nome,metadata_json) VALUES ('11111111-1111-1111-1111-111111111111','Demo IntegraRP v1.1','{"demo":true}'::jsonb) ON CONFLICT (id) DO NOTHING;
INSERT INTO integrarp.formulario_template (tenant_id,nome,template_json,demo) VALUES
('11111111-1111-1111-1111-111111111111','Checklist de Visita Comercial','{"fields":["cliente","gps","assinatura"]}'::jsonb,true),
('11111111-1111-1111-1111-111111111111','Checklist de Entrega com POD','{"fields":["photo","signature","gps"]}'::jsonb,true),
('11111111-1111-1111-1111-111111111111','Registro de Avaria','{"fields":["product","photo","textarea"]}'::jsonb,true),
('11111111-1111-1111-1111-111111111111','Pesquisa de Satisfação','{"fields":["rating","textarea"]}'::jsonb,true)
ON CONFLICT DO NOTHING;
INSERT INTO integrarp.automacao_regra (tenant_id,nome,habilitada,metadata_json) VALUES
('11111111-1111-1111-1111-111111111111','Tarefa atrasada',true,'{"trigger":"task_overdue","action":"send_notification"}'::jsonb),
('11111111-1111-1111-1111-111111111111','Ocorrência cria tarefa',true,'{"trigger":"delivery_occurrence_created","action":"create_task"}'::jsonb)
ON CONFLICT DO NOTHING;
INSERT INTO integrarp.relatorio_definicao (tenant_id,nome,chave_consulta) VALUES
('11111111-1111-1111-1111-111111111111','Pedidos por período','orders_by_period'),
('11111111-1111-1111-1111-111111111111','Estoque crítico','critical_inventory'),
('11111111-1111-1111-1111-111111111111','Títulos vencidos','overdue_titles')
ON CONFLICT DO NOTHING;
INSERT INTO integrarp.notificacao (tenant_id,evento,titulo,corpo,canal,status) VALUES ('11111111-1111-1111-1111-111111111111','automacao falhou','Demo v1.1','Notificação demo','sistema','pendente') ON CONFLICT DO NOTHING;
INSERT INTO integrarp.anexo_configuracao (tenant_id,extensoes_permitidas,tamanho_maximo_bytes,metadata_json) VALUES ('11111111-1111-1111-1111-111111111111','.pdf,.png,.jpg,.jpeg,.csv',10485760,'{"demo":"Anexos demo"}'::jsonb) ON CONFLICT DO NOTHING;
INSERT INTO integrarp.schema_migrations (version) VALUES ('0013_v11_scriptcompleto_forms_automation') ON CONFLICT (version) DO NOTHING;


-- V1.2 Integrações, Fiscal Fake/Sandbox, Conciliação, Rotas e Offline Robusto
CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.schema_migrations (version text PRIMARY KEY, applied_at timestamptz NOT NULL DEFAULT now());

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em() RETURNS trigger AS $$ BEGIN NEW.atualizado_em = now(); RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS integrarp.integracao_conector (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_conector ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_conector_tenant_status ON integrarp.integracao_conector (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_conector_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_conector ADD CONSTRAINT ck_integracao_conector_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_conector_atualizado_em ON integrarp.integracao_conector; CREATE TRIGGER trg_integracao_conector_atualizado_em BEFORE UPDATE ON integrarp.integracao_conector FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_conector_configuracao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_conector_configuracao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_conector_configuracao_tenant_status ON integrarp.integracao_conector_configuracao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_conector_configuracao_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_conector_configuracao ADD CONSTRAINT ck_integracao_conector_configuracao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_conector_configuracao_atualizado_em ON integrarp.integracao_conector_configuracao; CREATE TRIGGER trg_integracao_conector_configuracao_atualizado_em BEFORE UPDATE ON integrarp.integracao_conector_configuracao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_credencial_referencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_credencial_referencia ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_credencial_referencia_tenant_status ON integrarp.integracao_credencial_referencia (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_credencial_referencia_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_credencial_referencia ADD CONSTRAINT ck_integracao_credencial_referencia_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_credencial_referencia_atualizado_em ON integrarp.integracao_credencial_referencia; CREATE TRIGGER trg_integracao_credencial_referencia_atualizado_em BEFORE UPDATE ON integrarp.integracao_credencial_referencia FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_execucao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_execucao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_execucao_tenant_status ON integrarp.integracao_execucao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_execucao_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_execucao ADD CONSTRAINT ck_integracao_execucao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_execucao_atualizado_em ON integrarp.integracao_execucao; CREATE TRIGGER trg_integracao_execucao_atualizado_em BEFORE UPDATE ON integrarp.integracao_execucao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_execucao_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_execucao_log ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_execucao_log_tenant_status ON integrarp.integracao_execucao_log (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_execucao_log_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_execucao_log ADD CONSTRAINT ck_integracao_execucao_log_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_execucao_log_atualizado_em ON integrarp.integracao_execucao_log; CREATE TRIGGER trg_integracao_execucao_log_atualizado_em BEFORE UPDATE ON integrarp.integracao_execucao_log FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_webhook_endpoint (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_webhook_endpoint ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_webhook_endpoint_tenant_status ON integrarp.integracao_webhook_endpoint (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_webhook_endpoint_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_webhook_endpoint ADD CONSTRAINT ck_integracao_webhook_endpoint_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_webhook_endpoint_atualizado_em ON integrarp.integracao_webhook_endpoint; CREATE TRIGGER trg_integracao_webhook_endpoint_atualizado_em BEFORE UPDATE ON integrarp.integracao_webhook_endpoint FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_webhook_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_webhook_evento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_webhook_evento_tenant_status ON integrarp.integracao_webhook_evento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_webhook_evento_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_webhook_evento ADD CONSTRAINT ck_integracao_webhook_evento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_webhook_evento_atualizado_em ON integrarp.integracao_webhook_evento; CREATE TRIGGER trg_integracao_webhook_evento_atualizado_em BEFORE UPDATE ON integrarp.integracao_webhook_evento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_mapeamento_campo (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_mapeamento_campo ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_mapeamento_campo_tenant_status ON integrarp.integracao_mapeamento_campo (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_mapeamento_campo_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_mapeamento_campo ADD CONSTRAINT ck_integracao_mapeamento_campo_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_mapeamento_campo_atualizado_em ON integrarp.integracao_mapeamento_campo; CREATE TRIGGER trg_integracao_mapeamento_campo_atualizado_em BEFORE UPDATE ON integrarp.integracao_mapeamento_campo FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_fila_saida (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_fila_saida ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_fila_saida_tenant_status ON integrarp.integracao_fila_saida (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_fila_saida_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_fila_saida ADD CONSTRAINT ck_integracao_fila_saida_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_fila_saida_atualizado_em ON integrarp.integracao_fila_saida; CREATE TRIGGER trg_integracao_fila_saida_atualizado_em BEFORE UPDATE ON integrarp.integracao_fila_saida FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_fila_entrada (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_fila_entrada ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_fila_entrada_tenant_status ON integrarp.integracao_fila_entrada (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_fila_entrada_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_fila_entrada ADD CONSTRAINT ck_integracao_fila_entrada_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_fila_entrada_atualizado_em ON integrarp.integracao_fila_entrada; CREATE TRIGGER trg_integracao_fila_entrada_atualizado_em BEFORE UPDATE ON integrarp.integracao_fila_entrada FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_configuracao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_configuracao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_configuracao_tenant_status ON integrarp.fiscal_configuracao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_configuracao_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_configuracao ADD CONSTRAINT ck_fiscal_configuracao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_configuracao_atualizado_em ON integrarp.fiscal_configuracao; CREATE TRIGGER trg_fiscal_configuracao_atualizado_em BEFORE UPDATE ON integrarp.fiscal_configuracao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_documento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz,
    xml_fake text,
    danfe_html_fake text,
    pedido_id uuid,
    fatura_id uuid,
    cliente_id uuid
);

ALTER TABLE integrarp.fiscal_documento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_documento_tenant_status ON integrarp.fiscal_documento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_documento_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_documento ADD CONSTRAINT ck_fiscal_documento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_documento_atualizado_em ON integrarp.fiscal_documento; CREATE TRIGGER trg_fiscal_documento_atualizado_em BEFORE UPDATE ON integrarp.fiscal_documento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_documento_item (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_documento_item ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_documento_item_tenant_status ON integrarp.fiscal_documento_item (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_documento_item_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_documento_item ADD CONSTRAINT ck_fiscal_documento_item_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_documento_item_atualizado_em ON integrarp.fiscal_documento_item; CREATE TRIGGER trg_fiscal_documento_item_atualizado_em BEFORE UPDATE ON integrarp.fiscal_documento_item FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_documento_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_documento_evento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_documento_evento_tenant_status ON integrarp.fiscal_documento_evento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_documento_evento_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_documento_evento ADD CONSTRAINT ck_fiscal_documento_evento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_documento_evento_atualizado_em ON integrarp.fiscal_documento_evento; CREATE TRIGGER trg_fiscal_documento_evento_atualizado_em BEFORE UPDATE ON integrarp.fiscal_documento_evento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_emissao_lote (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_emissao_lote ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_emissao_lote_tenant_status ON integrarp.fiscal_emissao_lote (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_emissao_lote_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_emissao_lote ADD CONSTRAINT ck_fiscal_emissao_lote_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_emissao_lote_atualizado_em ON integrarp.fiscal_emissao_lote; CREATE TRIGGER trg_fiscal_emissao_lote_atualizado_em BEFORE UPDATE ON integrarp.fiscal_emissao_lote FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_emissao_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_emissao_log ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_emissao_log_tenant_status ON integrarp.fiscal_emissao_log (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_emissao_log_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_emissao_log ADD CONSTRAINT ck_fiscal_emissao_log_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_emissao_log_atualizado_em ON integrarp.fiscal_emissao_log; CREATE TRIGGER trg_fiscal_emissao_log_atualizado_em BEFORE UPDATE ON integrarp.fiscal_emissao_log FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_cancelamento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_cancelamento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_cancelamento_tenant_status ON integrarp.fiscal_cancelamento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_cancelamento_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_cancelamento ADD CONSTRAINT ck_fiscal_cancelamento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_cancelamento_atualizado_em ON integrarp.fiscal_cancelamento; CREATE TRIGGER trg_fiscal_cancelamento_atualizado_em BEFORE UPDATE ON integrarp.fiscal_cancelamento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_carta_correcao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_carta_correcao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_carta_correcao_tenant_status ON integrarp.fiscal_carta_correcao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_carta_correcao_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_carta_correcao ADD CONSTRAINT ck_fiscal_carta_correcao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_carta_correcao_atualizado_em ON integrarp.fiscal_carta_correcao; CREATE TRIGGER trg_fiscal_carta_correcao_atualizado_em BEFORE UPDATE ON integrarp.fiscal_carta_correcao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_serie (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_serie ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_serie_tenant_status ON integrarp.fiscal_serie (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_serie_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_serie ADD CONSTRAINT ck_fiscal_serie_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_serie_atualizado_em ON integrarp.fiscal_serie; CREATE TRIGGER trg_fiscal_serie_atualizado_em BEFORE UPDATE ON integrarp.fiscal_serie FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_certificado_referencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_certificado_referencia ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_certificado_referencia_tenant_status ON integrarp.fiscal_certificado_referencia (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_certificado_referencia_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_certificado_referencia ADD CONSTRAINT ck_fiscal_certificado_referencia_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_certificado_referencia_atualizado_em ON integrarp.fiscal_certificado_referencia; CREATE TRIGGER trg_fiscal_certificado_referencia_atualizado_em BEFORE UPDATE ON integrarp.fiscal_certificado_referencia FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_provedor (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_provedor ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_provedor_tenant_status ON integrarp.fiscal_provedor (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_provedor_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_provedor ADD CONSTRAINT ck_fiscal_provedor_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_provedor_atualizado_em ON integrarp.fiscal_provedor; CREATE TRIGGER trg_fiscal_provedor_atualizado_em BEFORE UPDATE ON integrarp.fiscal_provedor FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_conta_bancaria (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_conta_bancaria ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_conta_bancaria_tenant_status ON integrarp.financeiro_conta_bancaria (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_conta_bancaria_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_conta_bancaria ADD CONSTRAINT ck_financeiro_conta_bancaria_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_conta_bancaria_atualizado_em ON integrarp.financeiro_conta_bancaria; CREATE TRIGGER trg_financeiro_conta_bancaria_atualizado_em BEFORE UPDATE ON integrarp.financeiro_conta_bancaria FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_extrato_importacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_extrato_importacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_extrato_importacao_tenant_status ON integrarp.financeiro_extrato_importacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_extrato_importacao_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_extrato_importacao ADD CONSTRAINT ck_financeiro_extrato_importacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_extrato_importacao_atualizado_em ON integrarp.financeiro_extrato_importacao; CREATE TRIGGER trg_financeiro_extrato_importacao_atualizado_em BEFORE UPDATE ON integrarp.financeiro_extrato_importacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_extrato_lancamento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_extrato_lancamento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_extrato_lancamento_tenant_status ON integrarp.financeiro_extrato_lancamento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_extrato_lancamento_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_extrato_lancamento ADD CONSTRAINT ck_financeiro_extrato_lancamento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_extrato_lancamento_atualizado_em ON integrarp.financeiro_extrato_lancamento; CREATE TRIGGER trg_financeiro_extrato_lancamento_atualizado_em BEFORE UPDATE ON integrarp.financeiro_extrato_lancamento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_conciliacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_conciliacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_conciliacao_tenant_status ON integrarp.financeiro_conciliacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_conciliacao_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_conciliacao ADD CONSTRAINT ck_financeiro_conciliacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_conciliacao_atualizado_em ON integrarp.financeiro_conciliacao; CREATE TRIGGER trg_financeiro_conciliacao_atualizado_em BEFORE UPDATE ON integrarp.financeiro_conciliacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_conciliacao_item (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_conciliacao_item ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_conciliacao_item_tenant_status ON integrarp.financeiro_conciliacao_item (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_conciliacao_item_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_conciliacao_item ADD CONSTRAINT ck_financeiro_conciliacao_item_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_conciliacao_item_atualizado_em ON integrarp.financeiro_conciliacao_item; CREATE TRIGGER trg_financeiro_conciliacao_item_atualizado_em BEFORE UPDATE ON integrarp.financeiro_conciliacao_item FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_baixa_sugerida (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_baixa_sugerida ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_baixa_sugerida_tenant_status ON integrarp.financeiro_baixa_sugerida (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_baixa_sugerida_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_baixa_sugerida ADD CONSTRAINT ck_financeiro_baixa_sugerida_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_baixa_sugerida_atualizado_em ON integrarp.financeiro_baixa_sugerida; CREATE TRIGGER trg_financeiro_baixa_sugerida_atualizado_em BEFORE UPDATE ON integrarp.financeiro_baixa_sugerida FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_regra_conciliacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_regra_conciliacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_regra_conciliacao_tenant_status ON integrarp.financeiro_regra_conciliacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_regra_conciliacao_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_regra_conciliacao ADD CONSTRAINT ck_financeiro_regra_conciliacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_regra_conciliacao_atualizado_em ON integrarp.financeiro_regra_conciliacao; CREATE TRIGGER trg_financeiro_regra_conciliacao_atualizado_em BEFORE UPDATE ON integrarp.financeiro_regra_conciliacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_alerta_inadimplencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_alerta_inadimplencia ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_alerta_inadimplencia_tenant_status ON integrarp.financeiro_alerta_inadimplencia (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_alerta_inadimplencia_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_alerta_inadimplencia ADD CONSTRAINT ck_financeiro_alerta_inadimplencia_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_alerta_inadimplencia_atualizado_em ON integrarp.financeiro_alerta_inadimplencia; CREATE TRIGGER trg_financeiro_alerta_inadimplencia_atualizado_em BEFORE UPDATE ON integrarp.financeiro_alerta_inadimplencia FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_projecao_recebivel (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_projecao_recebivel ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_projecao_recebivel_tenant_status ON integrarp.financeiro_projecao_recebivel (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_projecao_recebivel_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_projecao_recebivel ADD CONSTRAINT ck_financeiro_projecao_recebivel_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_projecao_recebivel_atualizado_em ON integrarp.financeiro_projecao_recebivel; CREATE TRIGGER trg_financeiro_projecao_recebivel_atualizado_em BEFORE UPDATE ON integrarp.financeiro_projecao_recebivel FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_otimizacao_execucao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_otimizacao_execucao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_otimizacao_execucao_tenant_status ON integrarp.rota_otimizacao_execucao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_otimizacao_execucao_tenant_not_empty') THEN ALTER TABLE integrarp.rota_otimizacao_execucao ADD CONSTRAINT ck_rota_otimizacao_execucao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_otimizacao_execucao_atualizado_em ON integrarp.rota_otimizacao_execucao; CREATE TRIGGER trg_rota_otimizacao_execucao_atualizado_em BEFORE UPDATE ON integrarp.rota_otimizacao_execucao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_otimizacao_parada (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz,
    latitude numeric(10,7), longitude numeric(10,7), ordem_original integer, ordem_sugerida integer
);

ALTER TABLE integrarp.rota_otimizacao_parada ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_otimizacao_parada_tenant_status ON integrarp.rota_otimizacao_parada (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_otimizacao_parada_tenant_not_empty') THEN ALTER TABLE integrarp.rota_otimizacao_parada ADD CONSTRAINT ck_rota_otimizacao_parada_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_otimizacao_parada_atualizado_em ON integrarp.rota_otimizacao_parada; CREATE TRIGGER trg_rota_otimizacao_parada_atualizado_em BEFORE UPDATE ON integrarp.rota_otimizacao_parada FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_otimizacao_resultado (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_otimizacao_resultado ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_otimizacao_resultado_tenant_status ON integrarp.rota_otimizacao_resultado (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_otimizacao_resultado_tenant_not_empty') THEN ALTER TABLE integrarp.rota_otimizacao_resultado ADD CONSTRAINT ck_rota_otimizacao_resultado_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_otimizacao_resultado_atualizado_em ON integrarp.rota_otimizacao_resultado; CREATE TRIGGER trg_rota_otimizacao_resultado_atualizado_em BEFORE UPDATE ON integrarp.rota_otimizacao_resultado FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_distancia_cache (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_distancia_cache ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_distancia_cache_tenant_status ON integrarp.rota_distancia_cache (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_distancia_cache_tenant_not_empty') THEN ALTER TABLE integrarp.rota_distancia_cache ADD CONSTRAINT ck_rota_distancia_cache_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_distancia_cache_atualizado_em ON integrarp.rota_distancia_cache; CREATE TRIGGER trg_rota_distancia_cache_atualizado_em BEFORE UPDATE ON integrarp.rota_distancia_cache FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_regra_otimizacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_regra_otimizacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_regra_otimizacao_tenant_status ON integrarp.rota_regra_otimizacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_regra_otimizacao_tenant_not_empty') THEN ALTER TABLE integrarp.rota_regra_otimizacao ADD CONSTRAINT ck_rota_regra_otimizacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_regra_otimizacao_atualizado_em ON integrarp.rota_regra_otimizacao; CREATE TRIGGER trg_rota_regra_otimizacao_atualizado_em BEFORE UPDATE ON integrarp.rota_regra_otimizacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_restricao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_restricao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_restricao_tenant_status ON integrarp.rota_restricao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_restricao_tenant_not_empty') THEN ALTER TABLE integrarp.rota_restricao ADD CONSTRAINT ck_rota_restricao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_restricao_atualizado_em ON integrarp.rota_restricao; CREATE TRIGGER trg_rota_restricao_atualizado_em BEFORE UPDATE ON integrarp.rota_restricao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_janela_entrega (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_janela_entrega ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_janela_entrega_tenant_status ON integrarp.rota_janela_entrega (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_janela_entrega_tenant_not_empty') THEN ALTER TABLE integrarp.rota_janela_entrega ADD CONSTRAINT ck_rota_janela_entrega_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_janela_entrega_atualizado_em ON integrarp.rota_janela_entrega; CREATE TRIGGER trg_rota_janela_entrega_atualizado_em BEFORE UPDATE ON integrarp.rota_janela_entrega FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_dispositivo (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_dispositivo ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_dispositivo_tenant_status ON integrarp.offline_dispositivo (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_dispositivo_tenant_not_empty') THEN ALTER TABLE integrarp.offline_dispositivo ADD CONSTRAINT ck_offline_dispositivo_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_dispositivo_atualizado_em ON integrarp.offline_dispositivo; CREATE TRIGGER trg_offline_dispositivo_atualizado_em BEFORE UPDATE ON integrarp.offline_dispositivo FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_pacote_sincronizacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_pacote_sincronizacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_pacote_sincronizacao_tenant_status ON integrarp.offline_pacote_sincronizacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_pacote_sincronizacao_tenant_not_empty') THEN ALTER TABLE integrarp.offline_pacote_sincronizacao ADD CONSTRAINT ck_offline_pacote_sincronizacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_pacote_sincronizacao_atualizado_em ON integrarp.offline_pacote_sincronizacao; CREATE TRIGGER trg_offline_pacote_sincronizacao_atualizado_em BEFORE UPDATE ON integrarp.offline_pacote_sincronizacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_item_sincronizacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_item_sincronizacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_item_sincronizacao_tenant_status ON integrarp.offline_item_sincronizacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_item_sincronizacao_tenant_not_empty') THEN ALTER TABLE integrarp.offline_item_sincronizacao ADD CONSTRAINT ck_offline_item_sincronizacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_item_sincronizacao_atualizado_em ON integrarp.offline_item_sincronizacao; CREATE TRIGGER trg_offline_item_sincronizacao_atualizado_em BEFORE UPDATE ON integrarp.offline_item_sincronizacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_conflito (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_conflito ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_conflito_tenant_status ON integrarp.offline_conflito (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_conflito_tenant_not_empty') THEN ALTER TABLE integrarp.offline_conflito ADD CONSTRAINT ck_offline_conflito_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_conflito_atualizado_em ON integrarp.offline_conflito; CREATE TRIGGER trg_offline_conflito_atualizado_em BEFORE UPDATE ON integrarp.offline_conflito FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_resolucao_conflito (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_resolucao_conflito ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_resolucao_conflito_tenant_status ON integrarp.offline_resolucao_conflito (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_resolucao_conflito_tenant_not_empty') THEN ALTER TABLE integrarp.offline_resolucao_conflito ADD CONSTRAINT ck_offline_resolucao_conflito_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_resolucao_conflito_atualizado_em ON integrarp.offline_resolucao_conflito; CREATE TRIGGER trg_offline_resolucao_conflito_atualizado_em BEFORE UPDATE ON integrarp.offline_resolucao_conflito FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_checkpoint (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_checkpoint ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_checkpoint_tenant_status ON integrarp.offline_checkpoint (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_checkpoint_tenant_not_empty') THEN ALTER TABLE integrarp.offline_checkpoint ADD CONSTRAINT ck_offline_checkpoint_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_checkpoint_atualizado_em ON integrarp.offline_checkpoint; CREATE TRIGGER trg_offline_checkpoint_atualizado_em BEFORE UPDATE ON integrarp.offline_checkpoint FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_log ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_log_tenant_status ON integrarp.offline_log (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_log_tenant_not_empty') THEN ALTER TABLE integrarp.offline_log ADD CONSTRAINT ck_offline_log_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_log_atualizado_em ON integrarp.offline_log; CREATE TRIGGER trg_offline_log_atualizado_em BEFORE UPDATE ON integrarp.offline_log FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE OR REPLACE VIEW integrarp.vw_v12_kpis AS SELECT 'integrations'::text AS modulo, count(*) AS total FROM integrarp.integracao_execucao;

INSERT INTO integrarp.integracao_conector (tenant_id,nome,codigo,tipo,secret_reference,metadata_json) VALUES ('00000000-0000-0000-0000-000000000001','Fiscal Fake v1.2','fiscal-fake','fiscal','vault://demo/fiscal-fake','{"demo":true}'::jsonb) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.integracao_conector (tenant_id,nome,codigo,tipo,secret_reference) VALUES ('00000000-0000-0000-0000-000000000001','Banco Fake v1.2','bank-fake','bank','vault://demo/bank-fake') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.financeiro_conta_bancaria (tenant_id,nome,codigo,tipo,metadata_json) VALUES ('00000000-0000-0000-0000-000000000001','Conta bancária demo','bank-demo','sandbox','{"banco":"Fake Bank"}'::jsonb) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.fiscal_documento (tenant_id,nome,codigo,status,xml_fake,danfe_html_fake,valor) VALUES ('00000000-0000-0000-0000-000000000001','Documento fiscal demo','nf-demo','emitida_fake','<nfeFake/>','<html><body>DANFE HTML fake demo</body></html>',123.45) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.financeiro_regra_conciliacao (tenant_id,nome,codigo,tipo) VALUES ('00000000-0000-0000-0000-000000000001','Regra valor/data demo','regra-demo','valor_data') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.rota_otimizacao_execucao (tenant_id,nome,codigo,status,metadata_json) VALUES ('00000000-0000-0000-0000-000000000001','Rota demo v1.2','rota-demo','otimizada','{"distancia_km":12.4}'::jsonb) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.offline_dispositivo (tenant_id,nome,codigo,tipo) VALUES ('00000000-0000-0000-0000-000000000001','Dispositivo offline demo','device-demo','mobile') ON CONFLICT DO NOTHING;



-- RBAC demo v1.2: permissões de integrações, fiscal fake/sandbox, conciliação, rotas e offline robusto.
INSERT INTO integrarp.perfil (id, tenant_id, nome, permissoes_json, metadata_json)
VALUES ('00000000-0000-0000-0000-000000001201', '00000000-0000-0000-0000-000000000001', 'Administrador demo v1.2', '["integrations.connectors.visualizar","integrations.connectors.criar","integrations.connectors.editar","integrations.connectors.testar","integrations.executions.visualizar","integrations.queue.processar","fiscal.documents.visualizar","fiscal.documents.criar","fiscal.documents.validar","fiscal.documents.emitir_fake","fiscal.documents.cancelar","fiscal.danfe.visualizar","reconciliation.accounts.visualizar","reconciliation.accounts.criar","reconciliation.statements.importar","reconciliation.suggest.visualizar","reconciliation.confirmar","reconciliation.rejeitar","reconciliation.alerts.visualizar","routing.optimize","routing.apply","routing.visualizar","routing.reorder","offline.device.registrar","offline.package.baixar","offline.sync.enviar","offline.conflicts.visualizar","offline.conflicts.resolver"]'::jsonb, '{"demo":true,"versao":"v1.2"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
    permissoes_json = EXCLUDED.permissoes_json,
    metadata_json = EXCLUDED.metadata_json,
    atualizado_em = now();

INSERT INTO integrarp.schema_migrations (version) VALUES ('0014_v12_integracoes_fiscal_conciliacao_rotas_offline') ON CONFLICT DO NOTHING;
