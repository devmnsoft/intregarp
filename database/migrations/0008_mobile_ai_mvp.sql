CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.mobile_dispositivo (
    mobile_dispositivo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_dispositivo_tenant_status ON integrarp.mobile_dispositivo (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_sessao (
    mobile_sessao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_sessao_tenant_status ON integrarp.mobile_sessao (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_notificacao (
    mobile_notificacao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_notificacao_tenant_status ON integrarp.mobile_notificacao (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_anexo (
    mobile_anexo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_anexo_tenant_status ON integrarp.mobile_anexo (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_evidencia (
    mobile_evidencia_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_evidencia_tenant_status ON integrarp.mobile_evidencia (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_assinatura (
    mobile_assinatura_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_assinatura_tenant_status ON integrarp.mobile_assinatura (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_geo_evento (
    mobile_geo_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_geo_evento_tenant_status ON integrarp.mobile_geo_evento (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_sync_fila (
    mobile_sync_fila_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_sync_fila_tenant_status ON integrarp.mobile_sync_fila (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_execucao_tarefa (
    mobile_execucao_tarefa_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_execucao_tarefa_tenant_status ON integrarp.mobile_execucao_tarefa (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_aprovacao (
    mobile_aprovacao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_aprovacao_tenant_status ON integrarp.mobile_aprovacao (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_agente (
    ai_agente_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_agente_tenant_status ON integrarp.ai_agente (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_intencao (
    ai_intencao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_intencao_tenant_status ON integrarp.ai_intencao (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_ferramenta (
    ai_ferramenta_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_tenant_status ON integrarp.ai_ferramenta (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_ferramenta_permissao (
    ai_ferramenta_permissao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_permissao_tenant_status ON integrarp.ai_ferramenta_permissao (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_conversa (
    ai_conversa_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_conversa_tenant_status ON integrarp.ai_conversa (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_mensagem (
    ai_mensagem_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_mensagem_tenant_status ON integrarp.ai_mensagem (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_auditoria (
    ai_auditoria_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_auditoria_tenant_status ON integrarp.ai_auditoria (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_escalonamento_humano (
    ai_escalonamento_humano_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_escalonamento_humano_tenant_status ON integrarp.ai_escalonamento_humano (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_contexto_permitido (
    ai_contexto_permitido_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_contexto_permitido_tenant_status ON integrarp.ai_contexto_permitido (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_feedback_usuario (
    ai_feedback_usuario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_feedback_usuario_tenant_status ON integrarp.ai_feedback_usuario (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_configuracao (
    ai_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_configuracao_tenant_status ON integrarp.ai_configuracao (tenant_id, status);

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS device_id varchar(180) NULL;

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS plataforma varchar(40) NULL;

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS modelo varchar(120) NULL;

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS app_versao varchar(40) NULL;

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS push_token text NULL;

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS ultimo_acesso_em timestamptz NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS processo_instancia_id uuid NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS pedido_id uuid NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS titulo varchar(180) NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS latitude numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS longitude numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS accuracy_meters numeric(12,2) NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS storage_key text NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS content_type varchar(120) NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS tamanho_bytes bigint NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS capturado_em timestamptz NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS pedido_id uuid NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS processo_instancia_id uuid NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS nome_assinante varchar(180) NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS documento_assinante varchar(40) NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS assinatura_svg text NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS assinatura_png_storage_key text NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS latitude numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS longitude numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS assinado_em timestamptz NOT NULL DEFAULT now();

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS formulario_resposta_json jsonb NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS checklist_resposta_json jsonb NOT NULL DEFAULT '[]'::jsonb;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS inicio_em timestamptz NOT NULL DEFAULT now();

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS fim_em timestamptz NULL;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS latitude_inicio numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS longitude_inicio numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS latitude_fim numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS longitude_fim numeric(12,8) NULL;

ALTER TABLE integrarp.ai_agente ADD COLUMN IF NOT EXISTS modo varchar(40) NOT NULL DEFAULT 'governado';

ALTER TABLE integrarp.ai_agente ADD COLUMN IF NOT EXISTS configuracao_json jsonb NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE integrarp.ai_intencao ADD COLUMN IF NOT EXISTS exemplos_json jsonb NOT NULL DEFAULT '[]'::jsonb;

ALTER TABLE integrarp.ai_intencao ADD COLUMN IF NOT EXISTS ferramenta_padrao_codigo varchar(120) NULL;

ALTER TABLE integrarp.ai_ferramenta ADD COLUMN IF NOT EXISTS modulo varchar(80) NULL;

ALTER TABLE integrarp.ai_ferramenta ADD COLUMN IF NOT EXISTS requer_permissao varchar(120) NULL;

ALTER TABLE integrarp.ai_ferramenta ADD COLUMN IF NOT EXISTS parametros_schema_json jsonb NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS papel varchar(40) NULL;

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS conteudo text NULL;

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS intencao_codigo varchar(120) NULL;

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS ferramenta_codigo varchar(120) NULL;

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS confianca numeric(10,4) NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS ai_mensagem_id uuid NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS canal varchar(40) NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS pergunta text NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS intencao_codigo varchar(120) NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS ferramenta_codigo varchar(120) NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS permissao_validada boolean NOT NULL DEFAULT false;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS escopo_validado boolean NOT NULL DEFAULT false;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS mascaramento_aplicado boolean NOT NULL DEFAULT false;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS dados_consultados_json jsonb NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS resposta text NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS confianca numeric(10,4) NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS motivo text NULL;

ALTER TABLE integrarp.ai_escalonamento_humano ADD COLUMN IF NOT EXISTS resolvido_em timestamptz NULL;

CREATE OR REPLACE VIEW integrarp.vw_mobile_minha_fila AS SELECT tenant_id, tarefa_id, status, criado_em FROM integrarp.mobile_execucao_tarefa WHERE excluido_em IS NULL;

CREATE OR REPLACE VIEW integrarp.vw_mobile_tarefas_atrasadas AS SELECT tenant_id, tarefa_id, status, criado_em FROM integrarp.mobile_execucao_tarefa WHERE excluido_em IS NULL;

CREATE OR REPLACE VIEW integrarp.vw_mobile_dashboard AS SELECT tenant_id, tarefa_id, status, criado_em FROM integrarp.mobile_execucao_tarefa WHERE excluido_em IS NULL;

CREATE OR REPLACE VIEW integrarp.vw_ai_auditoria_resumo AS SELECT tenant_id, status, ferramenta_codigo, count(*)::bigint total FROM integrarp.ai_auditoria GROUP BY tenant_id, status, ferramenta_codigo;

CREATE OR REPLACE VIEW integrarp.vw_ai_conversas_recentes AS SELECT ai_conversa_id, tenant_id, status, criado_em FROM integrarp.ai_conversa WHERE excluido_em IS NULL;

CREATE OR REPLACE VIEW integrarp.vw_ai_escalonamentos_abertos AS SELECT ai_escalonamento_humano_id, tenant_id, status, criado_em FROM integrarp.ai_escalonamento_humano WHERE status = 'aberto';

CREATE OR REPLACE FUNCTION integrarp.set_atualizado_em() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN NEW.atualizado_em = now(); RETURN NEW; END $$;

DROP TRIGGER IF EXISTS trg_mobile_dispositivo_atualizado_em ON integrarp.mobile_dispositivo; CREATE TRIGGER trg_mobile_dispositivo_atualizado_em BEFORE UPDATE ON integrarp.mobile_dispositivo FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_sessao_atualizado_em ON integrarp.mobile_sessao; CREATE TRIGGER trg_mobile_sessao_atualizado_em BEFORE UPDATE ON integrarp.mobile_sessao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_notificacao_atualizado_em ON integrarp.mobile_notificacao; CREATE TRIGGER trg_mobile_notificacao_atualizado_em BEFORE UPDATE ON integrarp.mobile_notificacao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_anexo_atualizado_em ON integrarp.mobile_anexo; CREATE TRIGGER trg_mobile_anexo_atualizado_em BEFORE UPDATE ON integrarp.mobile_anexo FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_evidencia_atualizado_em ON integrarp.mobile_evidencia; CREATE TRIGGER trg_mobile_evidencia_atualizado_em BEFORE UPDATE ON integrarp.mobile_evidencia FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_assinatura_atualizado_em ON integrarp.mobile_assinatura; CREATE TRIGGER trg_mobile_assinatura_atualizado_em BEFORE UPDATE ON integrarp.mobile_assinatura FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_geo_evento_atualizado_em ON integrarp.mobile_geo_evento; CREATE TRIGGER trg_mobile_geo_evento_atualizado_em BEFORE UPDATE ON integrarp.mobile_geo_evento FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_sync_fila_atualizado_em ON integrarp.mobile_sync_fila; CREATE TRIGGER trg_mobile_sync_fila_atualizado_em BEFORE UPDATE ON integrarp.mobile_sync_fila FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_execucao_tarefa_atualizado_em ON integrarp.mobile_execucao_tarefa; CREATE TRIGGER trg_mobile_execucao_tarefa_atualizado_em BEFORE UPDATE ON integrarp.mobile_execucao_tarefa FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_aprovacao_atualizado_em ON integrarp.mobile_aprovacao; CREATE TRIGGER trg_mobile_aprovacao_atualizado_em BEFORE UPDATE ON integrarp.mobile_aprovacao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_agente_atualizado_em ON integrarp.ai_agente; CREATE TRIGGER trg_ai_agente_atualizado_em BEFORE UPDATE ON integrarp.ai_agente FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_intencao_atualizado_em ON integrarp.ai_intencao; CREATE TRIGGER trg_ai_intencao_atualizado_em BEFORE UPDATE ON integrarp.ai_intencao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_ferramenta_atualizado_em ON integrarp.ai_ferramenta; CREATE TRIGGER trg_ai_ferramenta_atualizado_em BEFORE UPDATE ON integrarp.ai_ferramenta FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_ferramenta_permissao_atualizado_em ON integrarp.ai_ferramenta_permissao; CREATE TRIGGER trg_ai_ferramenta_permissao_atualizado_em BEFORE UPDATE ON integrarp.ai_ferramenta_permissao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_conversa_atualizado_em ON integrarp.ai_conversa; CREATE TRIGGER trg_ai_conversa_atualizado_em BEFORE UPDATE ON integrarp.ai_conversa FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_mensagem_atualizado_em ON integrarp.ai_mensagem; CREATE TRIGGER trg_ai_mensagem_atualizado_em BEFORE UPDATE ON integrarp.ai_mensagem FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_auditoria_atualizado_em ON integrarp.ai_auditoria; CREATE TRIGGER trg_ai_auditoria_atualizado_em BEFORE UPDATE ON integrarp.ai_auditoria FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_escalonamento_humano_atualizado_em ON integrarp.ai_escalonamento_humano; CREATE TRIGGER trg_ai_escalonamento_humano_atualizado_em BEFORE UPDATE ON integrarp.ai_escalonamento_humano FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_contexto_permitido_atualizado_em ON integrarp.ai_contexto_permitido; CREATE TRIGGER trg_ai_contexto_permitido_atualizado_em BEFORE UPDATE ON integrarp.ai_contexto_permitido FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_feedback_usuario_atualizado_em ON integrarp.ai_feedback_usuario; CREATE TRIGGER trg_ai_feedback_usuario_atualizado_em BEFORE UPDATE ON integrarp.ai_feedback_usuario FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_configuracao_atualizado_em ON integrarp.ai_configuracao; CREATE TRIGGER trg_ai_configuracao_atualizado_em BEFORE UPDATE ON integrarp.ai_configuracao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

INSERT INTO integrarp.ai_agente (codigo,nome,modo,tenant_id) VALUES ('integra_assistente','Assistente IntegraRP','governado','00000000-0000-0000-0000-000000000001') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','pedido_status','pedido_status','get_order_status') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','entrega_comprovante','entrega_comprovante','get_delivery_proof') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','financeiro_titulo','financeiro_titulo','get_financial_title') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','kpi_consulta','kpi_consulta','get_authorized_kpi') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','modulo_dinamico_consulta','modulo_dinamico_consulta','search_dynamic_module') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','abrir_tarefa_humana','abrir_tarefa_humana','open_human_task') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','suporte','suporte','open_human_task') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','desconhecida','desconhecida','') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','get_order_status','get_order_status','ai','ai.tool.order_status') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','get_delivery_proof','get_delivery_proof','ai','ai.tool.delivery_proof') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','get_financial_title','get_financial_title','ai','ai.tool.financial_title') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','search_dynamic_module','search_dynamic_module','ai','ai.tool.dynamic_module_search') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','get_authorized_kpi','get_authorized_kpi','ai','ai.tool.kpi') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','open_human_task','open_human_task','ai','ai.tool.open_human_task') ON CONFLICT DO NOTHING;