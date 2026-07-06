CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.template_operacional_pacote (
    template_operacional_pacote_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    descricao text NULL,
    segmento varchar(120) NULL,
    versao varchar(40) NOT NULL DEFAULT '1.0',
    publico boolean NOT NULL DEFAULT true,
    ativo boolean NOT NULL DEFAULT true,
    icone varchar(80) NULL,
    cor varchar(20) NOT NULL DEFAULT '#2563EB',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.template_operacional (
    template_operacional_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    pacote_id uuid NULL,
    tenant_id uuid NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    descricao text NULL,
    categoria varchar(80) NOT NULL,
    tipo varchar(60) NOT NULL,
    setor_sugerido varchar(120) NULL,
    icone varchar(80) NULL,
    cor varchar(20) NOT NULL DEFAULT '#2563EB',
    template_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.template_operacional_item (template_operacional_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, tipo varchar(60) NOT NULL, codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, payload_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_instalacao (template_operacional_instalacao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, template_operacional_id uuid NULL, pacote_id uuid NULL, status varchar(40) NOT NULL DEFAULT 'pendente', instalado_por_usuario_id uuid NULL, instalado_em timestamptz NULL, erro text NULL, objetos_criados_json jsonb NOT NULL DEFAULT '{}'::jsonb, configuracao_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_instalacao_log (template_operacional_instalacao_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, instalacao_id uuid NOT NULL, etapa varchar(120) NOT NULL, status varchar(40) NOT NULL, mensagem text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_dependencia (template_operacional_dependencia_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, codigo_dependencia varchar(120) NOT NULL, obrigatoria boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_variavel (template_operacional_variavel_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, tipo varchar(60) NOT NULL DEFAULT 'texto', obrigatoria boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_kpi (template_operacional_kpi_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, formula_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_ai_catalogo (template_operacional_ai_catalogo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, intencao varchar(120) NOT NULL, descricao text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_mensagem (template_operacional_mensagem_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, codigo varchar(120) NOT NULL, canal varchar(60) NOT NULL, conteudo text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_dashboard (template_operacional_dashboard_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, codigo varchar(120) NOT NULL, widget_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

CREATE TABLE IF NOT EXISTS integrarp.operacao_rota (operacao_rota_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo varchar(80) NOT NULL, nome varchar(180) NOT NULL, data_rota date NOT NULL, motorista_usuario_id uuid NULL, veiculo_descricao varchar(120) NULL, status varchar(40) NOT NULL DEFAULT 'planejada', total_paradas int NOT NULL DEFAULT 0, paradas_concluidas int NOT NULL DEFAULT 0, distancia_estimativa_km numeric(18,2) NULL, inicio_em timestamptz NULL, fim_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_rota_parada (operacao_rota_parada_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, operacao_rota_id uuid NOT NULL, pedido_id uuid NULL, cliente_id uuid NULL, endereco_texto text NULL, latitude numeric(12,8) NULL, longitude numeric(12,8) NULL, ordem numeric(12,4) NOT NULL DEFAULT 0, status varchar(40) NOT NULL DEFAULT 'pendente', previsao_inicio timestamptz NULL, previsao_fim timestamptz NULL, chegada_em timestamptz NULL, saida_em timestamptz NULL, observacao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_romaneio (operacao_romaneio_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo varchar(80) NOT NULL, data_romaneio date NOT NULL, rota_id uuid NULL, motorista_usuario_id uuid NULL, status varchar(40) NOT NULL DEFAULT 'rascunho', quantidade_vias int NULL, total_pedidos int NOT NULL DEFAULT 0, total_volumes int NOT NULL DEFAULT 0, observacao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_romaneio_item (operacao_romaneio_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, romaneio_id uuid NOT NULL, pedido_id uuid NULL, cliente_id uuid NULL, nota_fiscal_referencia_id uuid NULL, quantidade_volumes int NOT NULL DEFAULT 0, volumetria_descricao varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'pendente', ordem numeric(12,4) NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_entrega_monitoramento (operacao_entrega_monitoramento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, rota_id uuid NULL, rota_parada_id uuid NULL, status varchar(40) NOT NULL DEFAULT 'pendente', sla_limite_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_prova_entrega (operacao_prova_entrega_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, rota_id uuid NULL, rota_parada_id uuid NULL, romaneio_id uuid NULL, cliente_id uuid NULL, tarefa_id uuid NULL, tipo varchar(40) NOT NULL DEFAULT 'pod', status varchar(40) NOT NULL DEFAULT 'registrada', recebedor_nome varchar(180) NULL, recebedor_documento varchar(40) NULL, assinatura_id uuid NULL, foto_storage_key text NULL, latitude numeric(12,8) NULL, longitude numeric(12,8) NULL, entregue_em timestamptz NOT NULL DEFAULT now(), observacao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_ocorrencia_entrega (operacao_ocorrencia_entrega_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, rota_id uuid NULL, rota_parada_id uuid NULL, romaneio_id uuid NULL, tipo varchar(80) NOT NULL, status varchar(40) NOT NULL DEFAULT 'aberta', descricao text NOT NULL, evidencia_json jsonb NOT NULL DEFAULT '{}'::jsonb, responsavel_usuario_id uuid NULL, tarefa_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

CREATE INDEX IF NOT EXISTS ix_template_operacional_codigo ON integrarp.template_operacional (codigo);
CREATE INDEX IF NOT EXISTS ix_operacao_rota_tenant_data ON integrarp.operacao_rota (tenant_id, data_rota);
CREATE INDEX IF NOT EXISTS ix_operacao_rota_parada_rota ON integrarp.operacao_rota_parada (tenant_id, operacao_rota_id, ordem);
CREATE INDEX IF NOT EXISTS ix_operacao_romaneio_tenant_data ON integrarp.operacao_romaneio (tenant_id, data_romaneio);
CREATE INDEX IF NOT EXISTS ix_operacao_ocorrencia_status ON integrarp.operacao_ocorrencia_entrega (tenant_id, status);

CREATE OR REPLACE VIEW integrarp.vw_operacoes_dashboard AS SELECT tenant_id, count(*) AS rotas FROM integrarp.operacao_rota WHERE excluido_em IS NULL GROUP BY tenant_id;
CREATE OR REPLACE VIEW integrarp.vw_entregas_dashboard AS SELECT tenant_id, status, count(*) AS total FROM integrarp.operacao_entrega_monitoramento WHERE excluido_em IS NULL GROUP BY tenant_id, status;
CREATE OR REPLACE VIEW integrarp.vw_romaneio_dashboard AS SELECT tenant_id, status, count(*) AS total FROM integrarp.operacao_romaneio WHERE excluido_em IS NULL GROUP BY tenant_id, status;
CREATE OR REPLACE VIEW integrarp.vw_avarias_dashboard AS SELECT tenant_id, codigo, nome FROM integrarp.template_operacional WHERE categoria = 'avarias';
CREATE OR REPLACE VIEW integrarp.vw_devolucoes_dashboard AS SELECT tenant_id, codigo, nome FROM integrarp.template_operacional WHERE categoria = 'devolucoes';
CREATE OR REPLACE VIEW integrarp.vw_promotores_dashboard AS SELECT tenant_id, codigo, nome FROM integrarp.template_operacional WHERE categoria = 'visita_promotor';

CREATE OR REPLACE FUNCTION integrarp.fn_operacional_touch_updated_at() RETURNS trigger AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_operacao_rota_touch ON integrarp.operacao_rota;
CREATE TRIGGER trg_operacao_rota_touch BEFORE UPDATE ON integrarp.operacao_rota FOR EACH ROW EXECUTE FUNCTION integrarp.fn_operacional_touch_updated_at();

INSERT INTO integrarp.template_operacional_pacote (codigo, nome, descricao, segmento, versao, publico, ativo, icone, cor)
SELECT 'pacote_operacao_distribuicao', 'Pacote Operação Distribuição', 'Templates para empresas com pedidos, estoque, romaneio, entrega, devolução, avarias e equipe de campo.', 'Distribuição', '1.0', true, true, 'truck', '#2563EB'
WHERE NOT EXISTS (SELECT 1 FROM integrarp.template_operacional_pacote WHERE codigo = 'pacote_operacao_distribuicao');

INSERT INTO integrarp.template_operacional (pacote_id, codigo, nome, descricao, categoria, tipo, setor_sugerido, template_json)
SELECT p.template_operacional_pacote_id, v.codigo, v.nome, v.descricao, v.categoria, v.tipo, 'Operações', jsonb_build_object('codigo', v.codigo, 'campos', v.campos)
FROM integrarp.template_operacional_pacote p
CROSS JOIN (VALUES
    ('controle_avarias', 'Controle de Avarias', 'Controle operacional de avarias com fluxo, KPIs, IA e mobile.', 'avarias', 'modulo_dinamico', 'Cliente,Produto,Lote,Quantidade,Tipo de avaria,Foto,Descrição,Status'),
    ('tratamento_devolucoes', 'Tratamento de Devoluções', 'Tratamento de devoluções com análise comercial, logística e financeira.', 'devolucoes', 'modulo_dinamico', 'Cliente,Pedido,Produto,Nota fiscal,Motivo,Quantidade,Status'),
    ('romaneio_entrega', 'Romaneio de Entrega', 'Romaneio nativo de entrega.', 'romaneio', 'pacote', 'Pedidos,Notas fiscais,Volumetria,Motorista'),
    ('roteirizacao_entregas', 'Roteirização de Entregas', 'Roteirização sem mapas externos.', 'roteirizacao', 'pacote', 'Rota,Paradas,Motorista,Coordenadas'),
    ('monitoramento_entrega', 'Monitoramento de Entrega', 'Monitoramento, SLA, POD e ocorrências.', 'entrega', 'dashboard', 'Pendentes,Em rota,Concluídas,Ocorrências'),
    ('prova_entrega_pod', 'Prova de Entrega/POD', 'Prova de entrega com recebedor, foto, assinatura e GPS.', 'entrega', 'mobile_form', 'Recebedor,Documento,Assinatura,Foto,GPS'),
    ('visita_promotor', 'Visita de Promotor', 'Visita de promotor e checklist de gôndola.', 'visita_promotor', 'modulo_dinamico', 'PV,Promotor,GPS,Fotos,Layout,Preço'),
    ('checklist_ponto_venda', 'Checklist de Ponto de Venda', 'Checklist operacional de PDV.', 'ponto_venda', 'mobile_form', 'Layout,Precificação,Estoque,Limpeza,Promoções'),
    ('solicitacao_reposicao', 'Solicitação de Reposição', 'Solicitação de reposição com aprovação.', 'estoque_campo', 'processo_bpmn', 'Produto,PV,Quantidade,Urgência,Motivo'),
    ('pesquisa_satisfacao_pos_entrega', 'Pesquisa de Satisfação Pós-entrega', 'Pesquisa de satisfação após entrega.', 'satisfacao', 'mobile_form', 'Cliente,Pedido,Nota,Comentário,Contato')
) AS v(codigo, nome, descricao, categoria, tipo, campos)
WHERE p.codigo = 'pacote_operacao_distribuicao'
  AND NOT EXISTS (SELECT 1 FROM integrarp.template_operacional t WHERE t.codigo = v.codigo);
