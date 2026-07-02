CREATE EXTENSION IF NOT EXISTS pgcrypto;

ALTER TABLE integrarp.processo_versao ADD COLUMN IF NOT EXISTS designer_layout_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.processo_versao ADD COLUMN IF NOT EXISTS designer_validacao_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.processo_versao ADD COLUMN IF NOT EXISTS ultima_validacao_em timestamptz NULL;
ALTER TABLE integrarp.processo_elemento ADD COLUMN IF NOT EXISTS designer_config_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.processo_elemento ADD COLUMN IF NOT EXISTS formulario_schema_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.processo_elemento ADD COLUMN IF NOT EXISTS checklist_schema_json jsonb NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE integrarp.processo_transicao ADD COLUMN IF NOT EXISTS designer_config_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE TABLE IF NOT EXISTS integrarp.flow_template (
    flow_template_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    descricao text NULL,
    categoria varchar(80) NOT NULL,
    setor_sugerido varchar(120) NULL,
    icone varchar(80) NULL,
    cor varchar(20) NOT NULL DEFAULT '#2563EB',
    publico boolean NOT NULL DEFAULT true,
    ativo boolean NOT NULL DEFAULT true,
    template_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.flow_template_elemento (
    flow_template_elemento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    flow_template_id uuid NOT NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    tipo varchar(40) NOT NULL,
    descricao text NULL,
    setor_sugerido varchar(120) NULL,
    sla_minutos int NULL,
    formulario_schema_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    checklist_schema_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    regra_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    posicao_x numeric(12,2) NULL,
    posicao_y numeric(12,2) NULL,
    ordem numeric(12,4) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS integrarp.flow_template_transicao (
    flow_template_transicao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    flow_template_id uuid NOT NULL,
    codigo varchar(120) NOT NULL,
    origem_codigo varchar(120) NOT NULL,
    destino_codigo varchar(120) NOT NULL,
    nome varchar(180) NULL,
    condicao_tipo varchar(40) NOT NULL DEFAULT 'always',
    condicao_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ordem numeric(12,4) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS integrarp.flow_designer_historico (
    flow_designer_historico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    processo_definicao_id uuid NOT NULL,
    processo_versao_id uuid NOT NULL,
    usuario_id uuid NULL,
    acao varchar(80) NOT NULL,
    descricao text NULL,
    antes_json jsonb NULL,
    depois_json jsonb NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    correlation_id varchar(120) NULL
);

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_flow_template_tenant_codigo') THEN
        ALTER TABLE integrarp.flow_template ADD CONSTRAINT uq_flow_template_tenant_codigo UNIQUE (tenant_id, codigo);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_flow_template_elemento_template') THEN
        ALTER TABLE integrarp.flow_template_elemento ADD CONSTRAINT fk_flow_template_elemento_template FOREIGN KEY (flow_template_id) REFERENCES integrarp.flow_template(flow_template_id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_flow_template_transicao_template') THEN
        ALTER TABLE integrarp.flow_template_transicao ADD CONSTRAINT fk_flow_template_transicao_template FOREIGN KEY (flow_template_id) REFERENCES integrarp.flow_template(flow_template_id) ON DELETE CASCADE;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_flow_template_categoria ON integrarp.flow_template(categoria) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_flow_template_elemento_template ON integrarp.flow_template_elemento(flow_template_id);
CREATE INDEX IF NOT EXISTS ix_flow_template_transicao_template ON integrarp.flow_template_transicao(flow_template_id);
CREATE INDEX IF NOT EXISTS ix_flow_designer_historico_versao ON integrarp.flow_designer_historico(processo_versao_id, criado_em DESC);

CREATE OR REPLACE FUNCTION integrarp.fn_flow_designer_touch_template() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_flow_template_touch ON integrarp.flow_template;
CREATE TRIGGER trg_flow_template_touch BEFORE UPDATE ON integrarp.flow_template FOR EACH ROW EXECUTE FUNCTION integrarp.fn_flow_designer_touch_template();

CREATE OR REPLACE VIEW integrarp.vw_flow_template_catalogo AS
SELECT flow_template_id, tenant_id, codigo, nome, categoria, setor_sugerido, icone, cor, publico, ativo
FROM integrarp.flow_template
WHERE excluido_em IS NULL;

INSERT INTO integrarp.flow_template (codigo, nome, descricao, categoria, setor_sugerido, icone, cor, publico, ativo, template_json)
VALUES
('pedido_ao_pos_venda','Pedido ao Pós-venda','Fluxo do pedido até pós-venda.','Operação Comercial','Vendas, Administrativo/Financeiro, Logística, Entregas','diagram','#2563EB',true,true,'{}'),
('emissao_de_boletos','Emissão de Boletos','Geração e envio de boleto.','Financeiro','Financeiro','receipt','#2563EB',true,true,'{}'),
('lancamento_de_pedidos_no_sistema','Lançamento de Pedidos no Sistema','Lançamento no ERP.','Administrativo / Financeiro','Administrativo/Financeiro','clipboard','#2563EB',true,true,'{}'),
('emissao_e_faturamento_de_notas_fiscais','Emissão e Faturamento de Notas Fiscais','Faturamento e NF.','Financeiro / Faturamento','Financeiro/Faturamento','file-invoice','#2563EB',true,true,'{}'),
('atualizacao_de_produtos_no_catalogo','Atualização de Produtos no Catálogo','Atualização de conteúdo de produtos.','Marketing','Marketing','box','#2563EB',true,true,'{}'),
('planejamento_semanal_de_vendas','Planejamento Semanal de Vendas','Planejamento semanal de visitas e vendas.','Vendas','Vendas','calendar','#2563EB',true,true,'{}'),
('visita_a_clientes','Visita a Clientes','Rotina de visita a clientes.','Vendas','Vendas','users','#2563EB',true,true,'{}'),
('pos_vendas','Pós-vendas','Acompanhamento pós-entrega.','Vendas','Vendas','phone','#2563EB',true,true,'{}'),
('arrumacao_do_ponto_de_venda','Arrumação do Ponto de Venda','Organização do PV.','Trade Marketing','Trade Marketing','store','#2563EB',true,true,'{}'),
('checagem_de_estoque','Checagem de Estoque','Conferência de estoque.','Trade Marketing / Estoque','Trade Marketing/Estoque','warehouse','#2563EB',true,true,'{}'),
('precificacao','Precificação','Controle de etiquetas e promoções.','Trade Marketing','Trade Marketing','tag','#2563EB',true,true,'{}'),
('recebimento_de_notas_fiscais','Recebimento de Notas Fiscais','Recebimento logístico.','Logística','Logística','truck','#2563EB',true,true,'{}'),
('separacao_de_pedidos','Separação de Pedidos','Separação e expedição.','Logística','Logística','boxes','#2563EB',true,true,'{}'),
('saida_de_notas_fiscais_expedicao','Saída de Notas Fiscais / Expedição','Conferência de romaneio e saída.','Logística','Logística','send','#2563EB',true,true,'{}')
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.flow_template_elemento (flow_template_id, codigo, nome, tipo, descricao, setor_sugerido, sla_minutos, formulario_schema_json, checklist_schema_json, posicao_x, posicao_y, ordem)
SELECT t.flow_template_id, e.codigo, e.nome, e.tipo, e.descricao, t.setor_sugerido, e.sla_minutos, e.formulario_schema_json::jsonb, e.checklist_schema_json::jsonb, e.posicao_x, e.posicao_y, e.ordem
FROM integrarp.flow_template t
CROSS JOIN (VALUES
('inicio','Início','start_event','Evento de início',NULL,'{"fields":[]}','[]',80,120,0),
('atividade_1','Executar etapa operacional','human_task','Etapa humana principal',240,'{"fields":[{"code":"observacao","label":"Observação","type":"textarea","required":false,"options":[],"order":1}]}','[{"code":"confirmar","title":"Confirmar execução","required":true,"order":1}]',320,120,1),
('decisao','Conferência necessária?','gateway','Decisão simples',NULL,'{"fields":[]}','[]',560,120,2),
('fim','Fim','end_event','Evento de fim',NULL,'{"fields":[]}','[]',820,120,3)
) AS e(codigo,nome,tipo,descricao,sla_minutos,formulario_schema_json,checklist_schema_json,posicao_x,posicao_y,ordem)
WHERE NOT EXISTS (SELECT 1 FROM integrarp.flow_template_elemento x WHERE x.flow_template_id = t.flow_template_id AND x.codigo = e.codigo);

INSERT INTO integrarp.flow_template_transicao (flow_template_id, codigo, origem_codigo, destino_codigo, nome, condicao_tipo, condicao_json, ordem)
SELECT t.flow_template_id, e.codigo, e.origem_codigo, e.destino_codigo, e.nome, e.condicao_tipo, e.condicao_json::jsonb, e.ordem
FROM integrarp.flow_template t
CROSS JOIN (VALUES
('t_inicio_atividade','inicio','atividade_1','Iniciar','always','{}',1),
('t_atividade_decisao','atividade_1','decisao','Conferir','always','{}',2),
('t_decisao_fim','decisao','fim','Finalizar','always','{}',3)
) AS e(codigo,origem_codigo,destino_codigo,nome,condicao_tipo,condicao_json,ordem)
WHERE NOT EXISTS (SELECT 1 FROM integrarp.flow_template_transicao x WHERE x.flow_template_id = t.flow_template_id AND x.codigo = e.codigo);

-- Permissões do designer devem ser vinculadas ao catálogo RBAC quando a tabela de permissões estiver habilitada.
