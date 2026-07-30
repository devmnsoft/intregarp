-- IntegraRP v1.45 — CRM, orçamentos, preços, operação e documentos.
-- Apenas objetos aditivos no schema canônico; todas as chaves de negócio incluem tenant_id.
ALTER TABLE integrarp.cliente_contato ADD COLUMN IF NOT EXISTS whatsapp boolean NOT NULL DEFAULT false;
ALTER TABLE integrarp.cliente_contato ADD COLUMN IF NOT EXISTS principal boolean NOT NULL DEFAULT false;
ALTER TABLE integrarp.cliente_contato ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
ALTER TABLE integrarp.cliente_endereco ADD COLUMN IF NOT EXISTS bairro text;
ALTER TABLE integrarp.cliente_endereco ADD COLUMN IF NOT EXISTS complemento text;
ALTER TABLE integrarp.cliente_endereco ADD COLUMN IF NOT EXISTS cobranca boolean NOT NULL DEFAULT false;
ALTER TABLE integrarp.cliente_endereco ADD COLUMN IF NOT EXISTS entrega boolean NOT NULL DEFAULT false;
ALTER TABLE integrarp.cliente_endereco ADD COLUMN IF NOT EXISTS principal boolean NOT NULL DEFAULT false;
ALTER TABLE integrarp.cliente_endereco ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
CREATE TABLE IF NOT EXISTS integrarp.oportunidade_comercial (
  id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NOT NULL,
  nome varchar(180) NOT NULL, etapa varchar(32) NOT NULL DEFAULT 'nova', probabilidade smallint NOT NULL DEFAULT 10,
  valor_esperado numeric(18,2) NOT NULL DEFAULT 0, fechamento_previsto date NOT NULL,
  proxima_acao text, proxima_acao_em timestamptz, responsavel_id uuid NOT NULL, motivo_perda text,
  criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, atualizado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1,
  CONSTRAINT pk_oportunidade_comercial PRIMARY KEY (tenant_id,id),
  CONSTRAINT ck_oportunidade_etapa CHECK (etapa IN ('nova','qualificacao','diagnostico','proposta','negociacao','ganha','perdida','cancelada')),
  CONSTRAINT ck_oportunidade_probabilidade CHECK (probabilidade BETWEEN 0 AND 100),
  CONSTRAINT ck_oportunidade_valor CHECK (valor_esperado >= 0)
);
CREATE INDEX IF NOT EXISTS ix_oportunidade_tenant_etapa ON integrarp.oportunidade_comercial(tenant_id,etapa) WHERE removido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.atividade_comercial (
  id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, oportunidade_id uuid NOT NULL,
  tipo varchar(24) NOT NULL, titulo varchar(180) NOT NULL, descricao text, agendada_em timestamptz,
  concluida_em timestamptz, cancelada_em timestamptz, responsavel_id uuid NOT NULL,
  criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, atualizado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1,
  CONSTRAINT pk_atividade_comercial PRIMARY KEY (tenant_id,id),
  CONSTRAINT fk_atividade_oportunidade FOREIGN KEY (tenant_id,oportunidade_id) REFERENCES integrarp.oportunidade_comercial(tenant_id,id),
  CONSTRAINT ck_atividade_tipo CHECK (tipo IN ('ligacao','reuniao','email','follow_up','tarefa','anotacao'))
);

CREATE TABLE IF NOT EXISTS integrarp.politica_desconto (
  id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, percentual_inicial numeric(7,4) NOT NULL,
  percentual_final numeric(7,4) NOT NULL, perfil_aprovador varchar(100) NOT NULL, prioridade integer NOT NULL DEFAULT 0,
  ativa boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL,
  atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL, removido_em timestamptz,
  removido_por uuid, row_version bigint NOT NULL DEFAULT 1,
  CONSTRAINT pk_politica_desconto PRIMARY KEY (tenant_id,id),
  CONSTRAINT ck_politica_desconto_faixa CHECK (percentual_inicial >= 0 AND percentual_final <= 100 AND percentual_inicial <= percentual_final)
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_politica_desconto_prioridade ON integrarp.politica_desconto(tenant_id,prioridade) WHERE ativa AND removido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.tabela_preco (
  id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome varchar(140) NOT NULL, padrao boolean NOT NULL DEFAULT false,
  vigente_de date NOT NULL, vigente_ate date, ativa boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL,
  atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid,
  row_version bigint NOT NULL DEFAULT 1, CONSTRAINT pk_tabela_preco PRIMARY KEY(tenant_id,id),
  CONSTRAINT ck_tabela_preco_vigencia CHECK (vigente_ate IS NULL OR vigente_ate >= vigente_de)
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_tabela_preco_padrao ON integrarp.tabela_preco(tenant_id) WHERE padrao AND ativa AND removido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.tabela_preco_item (
  id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tabela_preco_id uuid NOT NULL, produto_id uuid NOT NULL,
  preco numeric(18,4) NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL,
  atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid,
  row_version bigint NOT NULL DEFAULT 1, CONSTRAINT pk_tabela_preco_item PRIMARY KEY(tenant_id,id),
  CONSTRAINT fk_tabela_preco_item_tabela FOREIGN KEY(tenant_id,tabela_preco_id) REFERENCES integrarp.tabela_preco(tenant_id,id),
  CONSTRAINT ck_tabela_preco_item_preco CHECK(preco >= 0), CONSTRAINT ux_tabela_preco_item UNIQUE(tenant_id,tabela_preco_id,produto_id)
);

CREATE TABLE IF NOT EXISTS integrarp.orcamento_v145 (
  id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, numero varchar(24) NOT NULL, cliente_id uuid NOT NULL,
  oportunidade_id uuid, tabela_preco_id uuid, validade date NOT NULL, status varchar(32) NOT NULL DEFAULT 'rascunho',
  desconto_global_percentual numeric(7,4) NOT NULL DEFAULT 0, subtotal numeric(18,2) NOT NULL DEFAULT 0,
  desconto numeric(18,2) NOT NULL DEFAULT 0, total numeric(18,2) NOT NULL DEFAULT 0,
  aprovado_por uuid, aprovado_em timestamptz, motivo_rejeicao text, idempotency_key varchar(160) NOT NULL,
  criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, atualizado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1,
  CONSTRAINT pk_orcamento_v145 PRIMARY KEY(tenant_id,id), CONSTRAINT ux_orcamento_v145_numero UNIQUE(tenant_id,numero),
  CONSTRAINT ux_orcamento_v145_idempotencia UNIQUE(tenant_id,idempotency_key),
  CONSTRAINT ck_orcamento_v145_status CHECK(status IN ('rascunho','em_aprovacao','aprovado','rejeitado','enviado','aceito','recusado','expirado','convertido','cancelado')),
  CONSTRAINT ck_orcamento_v145_valores CHECK(subtotal >= 0 AND desconto >= 0 AND total >= 0 AND total = subtotal-desconto)
);
CREATE TABLE IF NOT EXISTS integrarp.orcamento_item_v145 (
  id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, orcamento_id uuid NOT NULL, produto_id uuid NOT NULL,
  descricao varchar(240) NOT NULL, quantidade numeric(18,4) NOT NULL, preco_unitario numeric(18,4) NOT NULL,
  desconto_percentual numeric(7,4) NOT NULL DEFAULT 0, subtotal numeric(18,2) NOT NULL, desconto numeric(18,2) NOT NULL, total numeric(18,2) NOT NULL,
  criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL,
  removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1,
  CONSTRAINT pk_orcamento_item_v145 PRIMARY KEY(tenant_id,id),
  CONSTRAINT fk_orcamento_item_v145 FOREIGN KEY(tenant_id,orcamento_id) REFERENCES integrarp.orcamento_v145(tenant_id,id),
  CONSTRAINT ck_orcamento_item_v145_valores CHECK(quantidade > 0 AND preco_unitario >= 0 AND desconto_percentual BETWEEN 0 AND 100 AND total >= 0)
);
CREATE TABLE IF NOT EXISTS integrarp.aprovacao_desconto (
  id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, orcamento_id uuid NOT NULL, politica_id uuid NOT NULL,
  status varchar(24) NOT NULL DEFAULT 'pendente', solicitado_por uuid NOT NULL, solicitado_em timestamptz NOT NULL DEFAULT now(),
  decidido_por uuid, decidido_em timestamptz, motivo text, criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL,
  atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid,
  row_version bigint NOT NULL DEFAULT 1, CONSTRAINT pk_aprovacao_desconto PRIMARY KEY(tenant_id,id),
  CONSTRAINT fk_aprovacao_orcamento FOREIGN KEY(tenant_id,orcamento_id) REFERENCES integrarp.orcamento_v145(tenant_id,id),
  CONSTRAINT fk_aprovacao_politica FOREIGN KEY(tenant_id,politica_id) REFERENCES integrarp.politica_desconto(tenant_id,id),
  CONSTRAINT ck_aprovacao_desconto_status CHECK(status IN ('pendente','aprovada','rejeitada','cancelada'))
);

CREATE TABLE IF NOT EXISTS integrarp.template_fluxo_operacional (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome varchar(160) NOT NULL, descricao text, gatilho varchar(80) NOT NULL,
 ativo boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, atualizado_em timestamptz NOT NULL DEFAULT now(),
 atualizado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1,
 CONSTRAINT pk_template_fluxo_operacional PRIMARY KEY(tenant_id,id)
);
CREATE TABLE IF NOT EXISTS integrarp.template_fluxo_versao (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, template_id uuid NOT NULL, numero integer NOT NULL, status varchar(20) NOT NULL DEFAULT 'rascunho', publicado_em timestamptz,
 criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL,
 removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1, CONSTRAINT pk_template_fluxo_versao PRIMARY KEY(tenant_id,id),
 CONSTRAINT fk_template_fluxo_versao FOREIGN KEY(tenant_id,template_id) REFERENCES integrarp.template_fluxo_operacional(tenant_id,id),
 CONSTRAINT ux_template_fluxo_versao UNIQUE(tenant_id,template_id,numero), CONSTRAINT ck_template_fluxo_versao_status CHECK(status IN ('rascunho','publicada'))
);
CREATE TABLE IF NOT EXISTS integrarp.template_fluxo_etapa (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, versao_id uuid NOT NULL, codigo varchar(60) NOT NULL, nome varchar(160) NOT NULL,
 descricao text, ordem integer NOT NULL, perfil_responsavel varchar(100), setor_responsavel_id uuid, sla_minutos integer NOT NULL,
 tipo_tarefa varchar(60) NOT NULL, checklist_json jsonb NOT NULL DEFAULT '[]'::jsonb, exige_evidencia boolean NOT NULL DEFAULT false,
 bloqueia_proxima boolean NOT NULL DEFAULT true, acao_automatica varchar(80), ativa boolean NOT NULL DEFAULT true,
 criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL,
 removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1, CONSTRAINT pk_template_fluxo_etapa PRIMARY KEY(tenant_id,id),
 CONSTRAINT fk_template_fluxo_etapa FOREIGN KEY(tenant_id,versao_id) REFERENCES integrarp.template_fluxo_versao(tenant_id,id),
 CONSTRAINT ux_template_fluxo_etapa_codigo UNIQUE(tenant_id,versao_id,codigo), CONSTRAINT ux_template_fluxo_etapa_ordem UNIQUE(tenant_id,versao_id,ordem),
 CONSTRAINT ck_template_fluxo_etapa_sla CHECK(sla_minutos > 0)
);
CREATE TABLE IF NOT EXISTS integrarp.fluxo_operacional_instancia (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, versao_id uuid NOT NULL, entidade_tipo varchar(40) NOT NULL, entidade_id uuid NOT NULL,
 status varchar(24) NOT NULL DEFAULT 'ativa', iniciado_em timestamptz NOT NULL DEFAULT now(), concluido_em timestamptz,
 criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL,
 removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1, CONSTRAINT pk_fluxo_operacional_instancia PRIMARY KEY(tenant_id,id),
 CONSTRAINT fk_fluxo_instancia_versao FOREIGN KEY(tenant_id,versao_id) REFERENCES integrarp.template_fluxo_versao(tenant_id,id)
);
CREATE TABLE IF NOT EXISTS integrarp.fluxo_operacional_instancia_etapa (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, instancia_id uuid NOT NULL, etapa_id uuid NOT NULL, status varchar(24) NOT NULL DEFAULT 'pendente',
 tarefa_id uuid, iniciado_em timestamptz, concluido_em timestamptz, criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL,
 atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1,
 CONSTRAINT pk_fluxo_instancia_etapa PRIMARY KEY(tenant_id,id), CONSTRAINT fk_fluxo_instancia_etapa FOREIGN KEY(tenant_id,instancia_id) REFERENCES integrarp.fluxo_operacional_instancia(tenant_id,id)
);

CREATE TABLE IF NOT EXISTS integrarp.arquivo_privado (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome_original varchar(255) NOT NULL, nome_fisico uuid NOT NULL,
 mime_type varchar(100) NOT NULL, tamanho_bytes bigint NOT NULL, hash_sha256 char(64) NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL,
 removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1, CONSTRAINT pk_arquivo_privado PRIMARY KEY(tenant_id,id),
 CONSTRAINT ck_arquivo_privado_tamanho CHECK(tamanho_bytes > 0)
);
CREATE TABLE IF NOT EXISTS integrarp.evidencia_operacional (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tarefa_id uuid, arquivo_id uuid NOT NULL, descricao text,
 criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1,
 CONSTRAINT pk_evidencia_operacional PRIMARY KEY(tenant_id,id), CONSTRAINT fk_evidencia_arquivo FOREIGN KEY(tenant_id,arquivo_id) REFERENCES integrarp.arquivo_privado(tenant_id,id)
);
CREATE TABLE IF NOT EXISTS integrarp.entrega_pedido (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NOT NULL, responsavel_id uuid, destinatario varchar(180),
 documento_destinatario varchar(40), entregue_em timestamptz, observacao text, evidencia_id uuid, latitude numeric(9,6), longitude numeric(9,6),
 status varchar(24) NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL,
 atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1,
 CONSTRAINT pk_entrega_pedido PRIMARY KEY(tenant_id,id), CONSTRAINT fk_entrega_evidencia FOREIGN KEY(tenant_id,evidencia_id) REFERENCES integrarp.evidencia_operacional(tenant_id,id),
 CONSTRAINT ck_entrega_status CHECK(status IN ('pendente','atribuida','em_rota','confirmada','cancelada'))
);

CREATE TABLE IF NOT EXISTS integrarp.template_documento_v145 (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tipo varchar(30) NOT NULL, nome varchar(160) NOT NULL, versao integer NOT NULL,
 conteudo_html text NOT NULL, status varchar(20) NOT NULL DEFAULT 'rascunho', publicado_em timestamptz, ativo boolean NOT NULL DEFAULT true,
 criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por uuid NOT NULL,
 removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1, CONSTRAINT pk_template_documento_v145 PRIMARY KEY(tenant_id,id),
 CONSTRAINT ux_template_documento_v145 UNIQUE(tenant_id,tipo,versao), CONSTRAINT ck_template_documento_tipo CHECK(tipo IN ('orcamento','pedido','comprovante_entrega'))
);
CREATE TABLE IF NOT EXISTS integrarp.documento_gerado_v145 (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, template_id uuid NOT NULL, entidade_tipo varchar(30) NOT NULL, entidade_id uuid NOT NULL,
 nome varchar(255) NOT NULL, hash_sha256 char(64) NOT NULL, conteudo_html text NOT NULL, gerado_em timestamptz NOT NULL DEFAULT now(), gerado_por uuid NOT NULL,
 criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, removido_em timestamptz, removido_por uuid, row_version bigint NOT NULL DEFAULT 1,
 CONSTRAINT pk_documento_gerado_v145 PRIMARY KEY(tenant_id,id), CONSTRAINT fk_documento_template_v145 FOREIGN KEY(tenant_id,template_id) REFERENCES integrarp.template_documento_v145(tenant_id,id)
);

CREATE TABLE IF NOT EXISTS integrarp.historico_operacional_v145 (
 id uuid NOT NULL DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, entidade_tipo varchar(40) NOT NULL, entidade_id uuid NOT NULL,
 evento varchar(100) NOT NULL, dados_json jsonb NOT NULL DEFAULT '{}'::jsonb, correlation_id varchar(100) NOT NULL,
 criado_em timestamptz NOT NULL DEFAULT now(), criado_por uuid NOT NULL, CONSTRAINT pk_historico_operacional_v145 PRIMARY KEY(tenant_id,id)
);
CREATE INDEX IF NOT EXISTS ix_historico_operacional_entidade ON integrarp.historico_operacional_v145(tenant_id,entidade_tipo,entidade_id,criado_em DESC);

INSERT INTO integrarp.schema_contract(contract_name,product_version,postgresql_major,schema_name,migration_count,manifest_generated_at_utc)
VALUES('Banco Canônico Integrarp v1.45','v1.45',16,'integrarp',48,'2026-07-30T00:00:00Z'::timestamptz)
ON CONFLICT(contract_name) DO UPDATE SET product_version=EXCLUDED.product_version,migration_count=EXCLUDED.migration_count,manifest_generated_at_utc=EXCLUDED.manifest_generated_at_utc;
