-- Sprint 9 - Integra Studio Avancado e Modulos Dinamicos
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.modulo_dinamico (
    modulo_dinamico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    nome_plural varchar(180) NULL,
    descricao text NULL,
    icone varchar(80) NULL,
    cor varchar(20) NOT NULL DEFAULT '#2563EB',
    setor_dono_id uuid NULL,
    visivel_web boolean NOT NULL DEFAULT true,
    visivel_mobile boolean NOT NULL DEFAULT false,
    status varchar(40) NOT NULL DEFAULT 'rascunho',
    versao_atual int NOT NULL DEFAULT 1,
    slug varchar(140) NOT NULL,
    menu_path varchar(180) NULL,
    permite_comentarios boolean NOT NULL DEFAULT true,
    permite_anexos boolean NOT NULL DEFAULT true,
    permite_auditoria boolean NOT NULL DEFAULT true,
    permite_ia boolean NOT NULL DEFAULT false,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    publicado_em timestamptz NULL,
    publicado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_modulo_dinamico_tenant_codigo ON integrarp.modulo_dinamico (tenant_id, codigo) WHERE excluido_em IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_modulo_dinamico_tenant_slug ON integrarp.modulo_dinamico (tenant_id, slug) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.modulo_entidade (
    modulo_entidade_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo_dinamico_id uuid NOT NULL,
    codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, descricao text NULL, entidade_principal boolean NOT NULL DEFAULT true,
    status varchar(40) NOT NULL DEFAULT 'ativa', ordenacao_padrao_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.modulo_campo (
    modulo_campo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo_dinamico_id uuid NOT NULL, modulo_entidade_id uuid NOT NULL,
    codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, label varchar(180) NOT NULL, tipo varchar(60) NOT NULL,
    obrigatorio boolean NOT NULL DEFAULT false, somente_leitura boolean NOT NULL DEFAULT false, visivel_listagem boolean NOT NULL DEFAULT true,
    visivel_formulario boolean NOT NULL DEFAULT true, visivel_detalhe boolean NOT NULL DEFAULT true, pesquisavel boolean NOT NULL DEFAULT false,
    mascarar boolean NOT NULL DEFAULT false, sensivel_lgpd boolean NOT NULL DEFAULT false, ordem numeric(12,4) NOT NULL DEFAULT 0,
    placeholder varchar(220) NULL, help_text text NULL, valor_padrao_json jsonb NULL, opcoes_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    validacao_json jsonb NOT NULL DEFAULT '{}'::jsonb, regra_visibilidade_json jsonb NOT NULL DEFAULT '{}'::jsonb, relacao_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.modulo_acao (
    modulo_acao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo_dinamico_id uuid NOT NULL,
    codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, descricao text NULL, tipo varchar(60) NOT NULL, icone varchar(80) NULL,
    cor varchar(20) NULL, exige_confirmacao boolean NOT NULL DEFAULT false, permissao_codigo varchar(160) NULL,
    regra_json jsonb NOT NULL DEFAULT '{}'::jsonb, parametros_json jsonb NOT NULL DEFAULT '{}'::jsonb, resultado_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ordem numeric(12,4) NOT NULL DEFAULT 0, ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.modulo_menu (
    modulo_menu_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_menu_tenant ON integrarp.modulo_menu (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_permissao (
    modulo_permissao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_permissao_tenant ON integrarp.modulo_permissao (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_relacionamento (
    modulo_relacionamento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_relacionamento_tenant ON integrarp.modulo_relacionamento (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_kpi (
    modulo_kpi_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_kpi_tenant ON integrarp.modulo_kpi (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_bpmn_vinculo (
    modulo_bpmn_vinculo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_bpmn_vinculo_tenant ON integrarp.modulo_bpmn_vinculo (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_catalogo_semantico (
    modulo_catalogo_semantico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_catalogo_semantico_tenant ON integrarp.modulo_catalogo_semantico (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_tela_configuracao (
    modulo_tela_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_tela_configuracao_tenant ON integrarp.modulo_tela_configuracao (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_filtro_configuracao (
    modulo_filtro_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_filtro_configuracao_tenant ON integrarp.modulo_filtro_configuracao (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_validacao (
    modulo_validacao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_validacao_tenant ON integrarp.modulo_validacao (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_evento (
    modulo_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_evento_tenant ON integrarp.modulo_evento (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_template (
    modulo_template_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_template_tenant ON integrarp.modulo_template (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_publicacao_historico (
    modulo_publicacao_historico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_publicacao_historico_tenant ON integrarp.modulo_publicacao_historico (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro (
    modulo_registro_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_tenant ON integrarp.modulo_registro (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_valor (
    modulo_registro_valor_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_valor_tenant ON integrarp.modulo_registro_valor (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_historico (
    modulo_registro_historico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_historico_tenant ON integrarp.modulo_registro_historico (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_comentario (
    modulo_registro_comentario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_comentario_tenant ON integrarp.modulo_registro_comentario (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_anexo (
    modulo_registro_anexo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_anexo_tenant ON integrarp.modulo_registro_anexo (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_acao_log (
    modulo_registro_acao_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_acao_log_tenant ON integrarp.modulo_registro_acao_log (tenant_id);

ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS modulo_entidade_id uuid NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS titulo varchar(260) NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS busca_texto text NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS setor_responsavel_id uuid NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS processo_instancia_id uuid NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS tarefa_id uuid NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS modulo_registro_id uuid NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS modulo_campo_id uuid NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS campo_codigo varchar(120) NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_texto text NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_numero numeric(18,4) NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_data timestamptz NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_booleano boolean NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_json jsonb NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_mascarado text NULL;

CREATE OR REPLACE VIEW integrarp.vw_studio_modulos_publicados AS SELECT tenant_id, modulo_dinamico_id, codigo, nome, slug FROM integrarp.modulo_dinamico WHERE status = 'publicado' AND excluido_em IS NULL;
CREATE OR REPLACE VIEW integrarp.vw_studio_registros_resumo AS SELECT tenant_id, modulo_dinamico_id, modulo_registro_id, codigo, titulo, status, criado_em FROM integrarp.modulo_registro WHERE excluido_em IS NULL;
CREATE OR REPLACE VIEW integrarp.vw_studio_modulo_kpis AS SELECT tenant_id, modulo_dinamico_id, codigo, nome, tipo, dados_json FROM integrarp.modulo_kpi WHERE excluido_em IS NULL;
CREATE OR REPLACE VIEW integrarp.vw_studio_auditoria_recente AS SELECT tenant_id, modulo_dinamico_id, codigo, nome, tipo, criado_em FROM integrarp.modulo_evento WHERE excluido_em IS NULL;
CREATE OR REPLACE VIEW integrarp.vw_studio_modulos_por_setor AS SELECT tenant_id, setor_dono_id, count(*) quantidade FROM integrarp.modulo_dinamico WHERE excluido_em IS NULL GROUP BY tenant_id, setor_dono_id;

CREATE OR REPLACE FUNCTION integrarp.fn_studio_touch_updated_at() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$;
DROP TRIGGER IF EXISTS trg_modulo_dinamico_touch ON integrarp.modulo_dinamico;
CREATE TRIGGER trg_modulo_dinamico_touch BEFORE UPDATE ON integrarp.modulo_dinamico FOR EACH ROW EXECUTE FUNCTION integrarp.fn_studio_touch_updated_at();

INSERT INTO integrarp.modulo_template (tenant_id, codigo, nome, tipo, status, dados_json)
VALUES
('00000000-0000-0000-0000-000000000001','controle_avarias','Controle de Avarias','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','solicitacoes_internas','Solicitações Internas','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','checklist_visita','Checklist de Visita','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','pesquisa_satisfacao','Pesquisa de Satisfação','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','controle_manutencao','Controle de Manutenção','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','registro_ocorrencias','Registro de Ocorrências','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','solicitacao_compras','Solicitação de Compras','template','ativo','{}')
ON CONFLICT DO NOTHING;
