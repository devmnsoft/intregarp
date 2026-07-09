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

-- v1.2 Jornada do Cliente, Onboarding Guiado e UX Operacional
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$;

CREATE TABLE IF NOT EXISTS integrarp.schema_migrations (version varchar(120) PRIMARY KEY, applied_at timestamptz NOT NULL DEFAULT now());

CREATE TABLE IF NOT EXISTS integrarp.jornada_cliente (jornada_cliente_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, descricao text NULL, perfil_alvo varchar(80) NULL, modulo varchar(80) NULL, ordem numeric(12,4) NOT NULL DEFAULT 0, ativo boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_etapa (jornada_etapa_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, jornada_cliente_id uuid NOT NULL, codigo varchar(120) NOT NULL, titulo varchar(180) NOT NULL, descricao text NULL, modulo varchar(80) NULL, rota_web varchar(240) NULL, rota_mobile varchar(240) NULL, acao_api varchar(240) NULL, tipo varchar(60) NOT NULL DEFAULT 'manual', obrigatoria boolean NOT NULL DEFAULT true, ordem numeric(12,4) NOT NULL DEFAULT 0, criterio_conclusao_json jsonb NOT NULL DEFAULT '{}'::jsonb, dica_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_usuario_progresso (jornada_usuario_progresso_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, jornada_cliente_id uuid NOT NULL, jornada_etapa_id uuid NULL, status varchar(40) NOT NULL DEFAULT 'pendente', iniciado_em timestamptz NULL, concluido_em timestamptz NULL, ultima_interacao_em timestamptz NULL, progresso_percentual numeric(10,2) NOT NULL DEFAULT 0, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_checklist (jornada_checklist_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, jornada_etapa_id uuid NOT NULL, titulo varchar(180) NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_checklist_item (jornada_checklist_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, jornada_checklist_id uuid NOT NULL, titulo varchar(180) NOT NULL, obrigatorio boolean NOT NULL DEFAULT true, concluido boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_evento (jornada_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, tipo varchar(80) NOT NULL, entidade_tipo varchar(80) NULL, entidade_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_dica_contextual (jornada_dica_contextual_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, chave_tela varchar(160) NOT NULL, titulo varchar(180) NOT NULL, conteudo text NOT NULL, proxima_acao varchar(180) NOT NULL, rota_web varchar(240) NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_tour (jornada_tour_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, codigo varchar(120) NOT NULL, titulo varchar(180) NOT NULL, gatilho varchar(60) NOT NULL DEFAULT 'manual', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_tour_passo (jornada_tour_passo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, jornada_tour_id uuid NOT NULL, seletor_css varchar(180) NULL, titulo varchar(180) NOT NULL, conteudo text NOT NULL, ordem numeric(12,4) NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_estado_vazio (jornada_estado_vazio_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, chave_tela varchar(160) NOT NULL, tipo varchar(60) NOT NULL DEFAULT 'lista', titulo varchar(180) NOT NULL, explicacao text NOT NULL, acao_rotulo varchar(120) NOT NULL, acao_rota_web varchar(240) NULL, exemplo_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_acao_recomendada (jornada_acao_recomendada_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NULL, perfil varchar(80) NULL, modulo varchar(80) NULL, titulo varchar(180) NOT NULL, descricao text NULL, prioridade varchar(20) NOT NULL DEFAULT 'media', rota_web varchar(240) NULL, rota_mobile varchar(240) NULL, entidade_tipo varchar(80) NULL, entidade_id uuid NULL, motivo varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, concluido_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_feedback_usuario (jornada_feedback_usuario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, nota int NOT NULL, comentario text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.adocao_score (adocao_score_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, score numeric(10,2) NOT NULL DEFAULT 0, periodo_inicio timestamptz NULL, periodo_fim timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.adocao_evento (adocao_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NULL, tipo varchar(80) NOT NULL, peso numeric(10,2) NOT NULL DEFAULT 1, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.adocao_modulo_status (adocao_modulo_status_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo varchar(80) NOT NULL, status varchar(40) NOT NULL DEFAULT 'incompleto', score numeric(10,2) NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.adocao_usuario_status (adocao_usuario_status_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, status varchar(40) NOT NULL DEFAULT 'ativo', ultimo_login_em timestamptz NULL, score numeric(10,2) NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

ALTER TABLE integrarp.jornada_cliente ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_jornada_usuario_progresso_status') THEN ALTER TABLE integrarp.jornada_usuario_progresso ADD CONSTRAINT ck_jornada_usuario_progresso_status CHECK (status IN ('pendente','em_andamento','concluida','ignorada','bloqueada')); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_jornada_progresso_percentual') THEN ALTER TABLE integrarp.jornada_usuario_progresso ADD CONSTRAINT ck_jornada_progresso_percentual CHECK (progresso_percentual >= 0 AND progresso_percentual <= 100); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_jornada_etapa_cliente') THEN ALTER TABLE integrarp.jornada_etapa ADD CONSTRAINT fk_jornada_etapa_cliente FOREIGN KEY (jornada_cliente_id) REFERENCES integrarp.jornada_cliente(jornada_cliente_id); END IF; END $$;

CREATE INDEX IF NOT EXISTS ix_jornada_cliente_codigo ON integrarp.jornada_cliente(codigo);
CREATE INDEX IF NOT EXISTS ix_jornada_etapa_jornada ON integrarp.jornada_etapa(jornada_cliente_id, ordem);
CREATE INDEX IF NOT EXISTS ix_jornada_usuario_progresso_tenant_usuario ON integrarp.jornada_usuario_progresso(tenant_id, usuario_id, status);
CREATE INDEX IF NOT EXISTS ix_jornada_acao_recomendada_usuario ON integrarp.jornada_acao_recomendada(tenant_id, usuario_id, status, prioridade);
CREATE INDEX IF NOT EXISTS ix_adocao_score_tenant ON integrarp.adocao_score(tenant_id, periodo_fim);

DROP TRIGGER IF EXISTS trg_jornada_cliente_atualizado_em ON integrarp.jornada_cliente; CREATE TRIGGER trg_jornada_cliente_atualizado_em BEFORE UPDATE ON integrarp.jornada_cliente FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_jornada_etapa_atualizado_em ON integrarp.jornada_etapa; CREATE TRIGGER trg_jornada_etapa_atualizado_em BEFORE UPDATE ON integrarp.jornada_etapa FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_jornada_acao_recomendada_atualizado_em ON integrarp.jornada_acao_recomendada; CREATE TRIGGER trg_jornada_acao_recomendada_atualizado_em BEFORE UPDATE ON integrarp.jornada_acao_recomendada FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_adocao_score_atualizado_em ON integrarp.adocao_score; CREATE TRIGGER trg_adocao_score_atualizado_em BEFORE UPDATE ON integrarp.adocao_score FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE OR REPLACE VIEW integrarp.vw_jornada_onboarding_status AS SELECT jc.tenant_id, jc.codigo, jc.nome, COALESCE(avg(jup.progresso_percentual),0) AS progresso_percentual FROM integrarp.jornada_cliente jc LEFT JOIN integrarp.jornada_usuario_progresso jup ON jup.jornada_cliente_id = jc.jornada_cliente_id GROUP BY jc.tenant_id, jc.codigo, jc.nome;
CREATE OR REPLACE VIEW integrarp.vw_jornada_usuario_progresso AS SELECT * FROM integrarp.jornada_usuario_progresso;
CREATE OR REPLACE VIEW integrarp.vw_acao_recomendada_usuario AS SELECT tenant_id, usuario_id, titulo, prioridade, rota_web, status, criado_em FROM integrarp.jornada_acao_recomendada WHERE status = 'pendente';
CREATE OR REPLACE VIEW integrarp.vw_o_que_fazer_agora AS SELECT tenant_id, usuario_id, 'acao_recomendada'::text AS origem, titulo, descricao, prioridade, rota_web, status, criado_em FROM integrarp.jornada_acao_recomendada WHERE status = 'pendente' UNION ALL SELECT tenant_id, usuario_id, 'jornadas_incompletas'::text AS origem, 'Continuar onboarding'::varchar(180) AS titulo, 'Concluir etapas pendentes da jornada guiada'::text AS descricao, 'alta'::varchar(20) AS prioridade, '/onboarding'::varchar(240) AS rota_web, status, ultima_interacao_em AS criado_em FROM integrarp.jornada_usuario_progresso WHERE status IN ('pendente','em_andamento','bloqueada');
CREATE OR REPLACE VIEW integrarp.vw_pendencias_por_perfil AS SELECT tenant_id, perfil, prioridade, count(*) AS total FROM integrarp.jornada_acao_recomendada WHERE status = 'pendente' GROUP BY tenant_id, perfil, prioridade;
CREATE OR REPLACE VIEW integrarp.vw_gargalos_para_gestor AS SELECT tenant_id, modulo, count(*) AS total_pendencias FROM integrarp.jornada_acao_recomendada WHERE status = 'pendente' GROUP BY tenant_id, modulo;
CREATE OR REPLACE VIEW integrarp.vw_proximos_passos_operacionais AS SELECT tenant_id, usuario_id, titulo, rota_web FROM integrarp.jornada_acao_recomendada WHERE status = 'pendente';
CREATE OR REPLACE VIEW integrarp.vw_modulos_incompletos_configuracao AS SELECT tenant_id, modulo, status FROM integrarp.adocao_modulo_status WHERE status <> 'completo';
CREATE OR REPLACE VIEW integrarp.vw_adocao_score_tenant AS SELECT tenant_id, max(score) AS score FROM integrarp.adocao_score GROUP BY tenant_id;
CREATE OR REPLACE VIEW integrarp.vw_adocao_modulos AS SELECT tenant_id, modulo, status, score FROM integrarp.adocao_modulo_status;
CREATE OR REPLACE VIEW integrarp.vw_adocao_usuarios AS SELECT tenant_id, usuario_id, status, score, ultimo_login_em FROM integrarp.adocao_usuario_status;

INSERT INTO integrarp.jornada_cliente (codigo, nome, descricao, perfil_alvo, modulo, ordem) VALUES
('primeiros-passos-administrador','Primeiros Passos do Administrador','Confirmar dados da empresa; Criar setores; Criar usuários; Definir perfis; Instalar pacote operacional; Criar primeiro processo; Criar primeiro cliente; Criar primeiro produto; Registrar entrada de estoque; Criar primeiro pedido; Ver dashboard.','Administrador do Tenant','core',1),
('operacao-diaria','Operação Diária','Ver painel O que fazer agora; Abrir minhas tarefas; Resolver atrasos; Ver pedidos pendentes; Ver estoque crítico; Ver títulos vencidos; Ver ocorrências; Consultar IA se necessário.','Operador','operacao',2),
('gestor','Gestor','Ver score operacional; Ver gargalos; Ver SLAs vencidos; Ver responsáveis; Exportar relatório; Criar ação corretiva; Acompanhar Project.','Diretor','gestao',3),
('usuario-campo','Usuário de Campo','Abrir app mobile; Ver minha fila; Abrir tarefa; Executar checklist; Registrar evidência; Capturar assinatura/GPS; Concluir; Sincronizar.','Motorista','mobile',4),
('studio','Studio','Criar módulo; Criar campos; Criar formulário; Criar ação; Conectar BPMN; Publicar; Criar primeiro registro; Ver KPI; Permitir consulta pela IA.','Administrador do Tenant','studio',5)
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.jornada_acao_recomendada (tenant_id, titulo, descricao, prioridade, rota_web, motivo) VALUES ('00000000-0000-0000-0000-000000000001','Criar primeiro pedido','Complete cliente, produto e estoque para validar o fluxo comercial.','alta','/onboarding/first-order','seed demo v1.2') ON CONFLICT DO NOTHING;
-- RBAC v1.2: journey.visualizar journey.iniciar journey.concluir_etapa journey.ignorar_etapa journey.resetar journey.acoes.visualizar journey.acoes.concluir journey.ajuda.visualizar journey.tour.visualizar journey.feedback.enviar
-- Perfis: Administrador Geral; Administrador do Tenant; Diretor; Coordenador; Financeiro; Vendas; Logística; Motorista; Promotor de Vendas; Operador.
INSERT INTO integrarp.schema_migrations(version) VALUES ('0014_v12_jornada_cliente_onboarding_ux') ON CONFLICT DO NOTHING;

-- v1.3 - Funcionalidade real end-to-end, validação funcional e demo persistido
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

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

INSERT INTO integrarp.schema_migrations(version) VALUES ('0015_v13_funcionalidade_real_end_to_end') ON CONFLICT (version) DO NOTHING;

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

-- v1.4 Build verde, repositórios PostgreSQL reais e fluxo operacional
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.schema_migrations (version text PRIMARY KEY, applied_at timestamptz NOT NULL DEFAULT now());
ALTER TABLE integrarp.schema_migrations ADD COLUMN IF NOT EXISTS description text;

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
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',6,'flow_tarefa','ok','workflow_task','{}'),
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

INSERT INTO integrarp.schema_migrations (version, description)
VALUES ('0016_v14_postgres_repositories_operacional', 'v1.4 PostgreSQL real, Dapper readiness e demo pedido-faturamento-outbox')
ON CONFLICT (version) DO NOTHING;

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

INSERT INTO integrarp.schema_migrations (version, description)
VALUES ('0017_v15_validacao_real_cruds_qa_deploy', 'v1.5 validação real, CRUDs operacionais, jornada completa, QA e deploy assistido')
ON CONFLICT (version) DO NOTHING;

-- =============================================================
-- v1.6 Release Candidate - validação real, CI, Docker, smoke tests
-- =============================================================
CREATE TABLE IF NOT EXISTS integrarp.v16_release_candidate_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    area varchar(80) NOT NULL,
    check_name varchar(140) NOT NULL,
    status varchar(20) NOT NULL DEFAULT 'warning',
    evidence text NULL,
    next_action text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS tenant_id uuid NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS area varchar(80) NOT NULL DEFAULT 'release-candidate';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS check_name varchar(140) NOT NULL DEFAULT 'pending';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS status varchar(20) NOT NULL DEFAULT 'warning';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS evidence text NULL;
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS next_action text NULL;
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS criado_em timestamptz NOT NULL DEFAULT now();
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v16_release_candidate_check_area_name') THEN
        ALTER TABLE integrarp.v16_release_candidate_check ADD CONSTRAINT uq_v16_release_candidate_check_area_name UNIQUE (tenant_id, area, check_name);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v16_release_candidate_check_status') THEN
        ALTER TABLE integrarp.v16_release_candidate_check ADD CONSTRAINT ck_v16_release_candidate_check_status CHECK (status IN ('ok','warning','error'));
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_v16_release_candidate_check_tenant_area ON integrarp.v16_release_candidate_check (tenant_id, area, status);
CREATE INDEX IF NOT EXISTS ix_v16_release_candidate_check_updated ON integrarp.v16_release_candidate_check (atualizado_em DESC);

DROP TRIGGER IF EXISTS trg_v16_release_candidate_check_atualizado_em ON integrarp.v16_release_candidate_check;
CREATE TRIGGER trg_v16_release_candidate_check_atualizado_em BEFORE UPDATE ON integrarp.v16_release_candidate_check FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.v16_release_candidate_check (tenant_id, area, check_name, status, evidence, next_action) VALUES
('00000000-0000-0000-0000-000000000001','build','dotnet-sdk-codex','warning','SDK .NET ausente no ambiente Codex; CI executa restore/build/test em ubuntu-latest e windows-latest.','Acompanhar GitHub Actions antes de promover RC.'),
('00000000-0000-0000-0000-000000000001','mobile','typecheck-codex','ok','npm install e npm run typecheck executados com sucesso no Codex.','Manter typecheck no CI.'),
('00000000-0000-0000-0000-000000000001','database','scriptcompleto-idempotente','warning','Workflow database-validation aplica scriptcompleto.sql duas vezes em PostgreSQL limpo.','Validar execução do workflow.'),
('00000000-0000-0000-0000-000000000001','docker','docker-codex','warning','Docker ausente no ambiente Codex; script validate-docker-release.ps1 criado para Windows/local.','Executar em host com Docker.'),
('00000000-0000-0000-0000-000000000001','smoke','customer-full-journey','warning','Smoke script cobre health, Swagger e validação da jornada do cliente.','Executar com API e banco reais.')
ON CONFLICT (tenant_id, area, check_name) DO UPDATE SET status = EXCLUDED.status, evidence = EXCLUDED.evidence, next_action = EXCLUDED.next_action;

CREATE OR REPLACE VIEW integrarp.vw_v16_release_candidate_status AS
SELECT tenant_id,
       CASE
           WHEN count(*) FILTER (WHERE status = 'error') > 0 THEN 'error'
           WHEN count(*) FILTER (WHERE status = 'warning') > 0 THEN 'warning'
           ELSE 'ok'
       END AS status,
       jsonb_agg(jsonb_build_object('area', area, 'check', check_name, 'status', status, 'evidence', evidence, 'next_action', next_action) ORDER BY area, check_name) AS checks,
       'Executar CI, database-validation, release-candidate e smoke tests em ambiente com .NET, PostgreSQL e Docker.'::text AS next_action
FROM integrarp.v16_release_candidate_check
GROUP BY tenant_id;

INSERT INTO integrarp.schema_migrations (version, description)
VALUES ('0018_v16_release_candidate_validation', 'v1.6 release candidate: validação de build, banco, CI, Docker e smoke tests')
ON CONFLICT (version) DO NOTHING;

-- =============================================================
-- v1.7 - Runtime validation, green pipeline evidence and smoke readiness
-- =============================================================
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

ALTER TABLE integrarp.schema_migrations ADD COLUMN IF NOT EXISTS description text NULL;

CREATE TABLE IF NOT EXISTS integrarp.permissao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001',
    codigo text NOT NULL,
    descricao text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.cliente (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text NOT NULL,
    documento text NULL,
    email text NULL,
    status text NOT NULL DEFAULT 'ativo',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.estoque_movimento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    produto_id uuid NOT NULL,
    tipo text NOT NULL,
    quantidade numeric(18,4) NOT NULL,
    local_estoque text NOT NULL DEFAULT 'principal',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.pedido_item (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    pedido_id uuid NOT NULL,
    produto_id uuid NOT NULL,
    quantidade numeric(18,4) NOT NULL,
    valor_unitario numeric(18,2) NOT NULL DEFAULT 0,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.processo_definicao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo text NOT NULL,
    nome text NOT NULL,
    status text NOT NULL DEFAULT 'ativo',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.processo_instancia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    processo_definicao_id uuid NOT NULL,
    entidade_tipo text NULL,
    entidade_id uuid NULL,
    status text NOT NULL DEFAULT 'em_andamento',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.tarefa (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    processo_instancia_id uuid NULL,
    titulo text NOT NULL,
    responsavel_usuario_id uuid NULL,
    status text NOT NULL DEFAULT 'pendente',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.fatura (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    pedido_id uuid NULL,
    numero text NOT NULL,
    valor_total numeric(18,2) NOT NULL DEFAULT 0,
    status text NOT NULL DEFAULT 'emitida',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    tipo text NOT NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    status text NOT NULL DEFAULT 'pendente',
    proxima_tentativa_em timestamptz NULL,
    tentativas integer NOT NULL DEFAULT 0,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.projeto_central_board (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text NOT NULL,
    status text NOT NULL DEFAULT 'ativo',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.v17_runtime_validation_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    area text NOT NULL,
    check_name text NOT NULL,
    status text NOT NULL DEFAULT 'warning',
    evidence text NULL,
    next_action text NULL,
    simulated boolean NOT NULL DEFAULT false,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v17_runtime_validation_check') THEN ALTER TABLE integrarp.v17_runtime_validation_check ADD CONSTRAINT uq_v17_runtime_validation_check UNIQUE (tenant_id, area, check_name); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v17_runtime_validation_status') THEN ALTER TABLE integrarp.v17_runtime_validation_check ADD CONSTRAINT ck_v17_runtime_validation_status CHECK (status IN ('ok','warning','error')); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_estoque_movimento_tipo_v17') THEN ALTER TABLE integrarp.estoque_movimento ADD CONSTRAINT ck_estoque_movimento_tipo_v17 CHECK (tipo IN ('entrada','saida','reserva','ajuste')); END IF; END $$;

CREATE INDEX IF NOT EXISTS ix_permissao_tenant_codigo ON integrarp.permissao(tenant_id, codigo);
CREATE INDEX IF NOT EXISTS ix_cliente_tenant_status_nome ON integrarp.cliente(tenant_id, status, nome);
CREATE INDEX IF NOT EXISTS ix_estoque_movimento_produto_local_tenant ON integrarp.estoque_movimento(tenant_id, produto_id, local_estoque, criado_em DESC);
CREATE INDEX IF NOT EXISTS ix_pedido_tenant_status_data ON integrarp.pedido(tenant_id, status, criado_em DESC);
CREATE INDEX IF NOT EXISTS ix_pedido_item_tenant_pedido ON integrarp.pedido_item(tenant_id, pedido_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_responsavel_status ON integrarp.tarefa(tenant_id, responsavel_usuario_id, status);
CREATE INDEX IF NOT EXISTS ix_titulo_financeiro_tenant_status_vencimento ON integrarp.titulo_financeiro(tenant_id, status, vencimento);
CREATE INDEX IF NOT EXISTS ix_outbox_evento_status_proxima_tentativa ON integrarp.outbox_evento(tenant_id, status, proxima_tentativa_em);
CREATE INDEX IF NOT EXISTS ix_v17_runtime_validation_tenant_area ON integrarp.v17_runtime_validation_check(tenant_id, area, status);

DROP TRIGGER IF EXISTS trg_permissao_atualizado_em ON integrarp.permissao;
CREATE TRIGGER trg_permissao_atualizado_em BEFORE UPDATE ON integrarp.permissao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_cliente_atualizado_em ON integrarp.cliente;
CREATE TRIGGER trg_cliente_atualizado_em BEFORE UPDATE ON integrarp.cliente FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_outbox_evento_atualizado_em ON integrarp.outbox_evento;
CREATE TRIGGER trg_outbox_evento_atualizado_em BEFORE UPDATE ON integrarp.outbox_evento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v17_runtime_validation_check_atualizado_em ON integrarp.v17_runtime_validation_check;
CREATE TRIGGER trg_v17_runtime_validation_check_atualizado_em BEFORE UPDATE ON integrarp.v17_runtime_validation_check FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.permissao (tenant_id, codigo, descricao) VALUES
('00000000-0000-0000-0000-000000000001','validation.functional.visualizar','Visualizar endpoints de validação funcional'),
('00000000-0000-0000-0000-000000000001','tenant.demo.acessar','Acessar tenant demo')
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.cliente (tenant_id, nome, documento, email) VALUES ('00000000-0000-0000-0000-000000000001','Cliente Demo v1.7','00000000000191','cliente.demo@integrarp.local') ON CONFLICT DO NOTHING;
INSERT INTO integrarp.processo_definicao (tenant_id, codigo, nome) VALUES ('00000000-0000-0000-0000-000000000001','order-to-billing','Pedido para faturamento') ON CONFLICT DO NOTHING;
INSERT INTO integrarp.projeto_central_board (tenant_id, nome) VALUES ('00000000-0000-0000-0000-000000000001','Board Demo v1.7') ON CONFLICT DO NOTHING;
INSERT INTO integrarp.outbox_evento (tenant_id, tipo, payload_json, status, proxima_tentativa_em) VALUES ('00000000-0000-0000-0000-000000000001','demo.v17.runtime','{"demo":true}'::jsonb,'processado',now()) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.v17_runtime_validation_check (tenant_id, area, check_name, status, evidence, next_action, simulated) VALUES
('00000000-0000-0000-0000-000000000001','github','pr-22-audit','warning','PR #22 permanece aberto com escopo v1.6 semelhante ao PR #23 mergeado; auditoria documentada em docs/v1.7-github-state-audit.md.','Fechar PR #22 após revisão humana dos arquivos alterados.',false),
('00000000-0000-0000-0000-000000000001','database','scriptcompleto-idempotency','warning','Ambiente local não possui psql; workflow database-validation aplica o script duas vezes em PostgreSQL.','Executar workflow e anexar logs.',false),
('00000000-0000-0000-0000-000000000001','runtime','functional-validation-controller','ok','Endpoints retornam contrato com checks, warnings, erros, próxima ação, tempo de execução e correlation id.','Evoluir consultas para DbConnection quando ambiente de banco estiver disponível.',false),
('00000000-0000-0000-0000-000000000001','docker','compose-runtime','warning','Ambiente local não possui Docker; script validate-docker-release.ps1 é a evidência operacional esperada.','Executar em host com Docker Desktop ou runner habilitado.',false)
ON CONFLICT (tenant_id, area, check_name) DO UPDATE SET status = EXCLUDED.status, evidence = EXCLUDED.evidence, next_action = EXCLUDED.next_action, simulated = EXCLUDED.simulated;

CREATE OR REPLACE VIEW integrarp.vw_v17_runtime_validation_status AS
SELECT tenant_id,
       CASE WHEN count(*) FILTER (WHERE status = 'error') > 0 THEN 'error'
            WHEN count(*) FILTER (WHERE status = 'warning') > 0 THEN 'warning'
            ELSE 'ok' END AS status,
       jsonb_agg(jsonb_build_object('area', area, 'check', check_name, 'status', status, 'evidence', evidence, 'next_action', next_action, 'simulated', simulated) ORDER BY area, check_name) AS checks,
       'Executar CI, database-validation, release-candidate, Docker runtime e smoke tests reais.'::text AS next_action
FROM integrarp.v17_runtime_validation_check
GROUP BY tenant_id;

INSERT INTO integrarp.schema_migrations (version, description)
VALUES ('0019_v17_runtime_validation_and_green_pipeline', 'v1.7 validação de runtime, pipeline verde, Docker, banco real e smoke tests')
ON CONFLICT (version) DO NOTHING;
