CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION integrarp.set_atualizado_em()
RETURNS trigger AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS integrarp.fatura (
    fatura_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    filial_id uuid NULL,
    pedido_id uuid NULL,
    cliente_id uuid NOT NULL,
    codigo varchar(80) NOT NULL,
    numero varchar(80) NULL,
    status varchar(40) NOT NULL DEFAULT 'rascunho',
    data_emissao timestamptz NULL,
    data_vencimento date NULL,
    valor_bruto numeric(18,2) NOT NULL DEFAULT 0,
    valor_desconto numeric(18,2) NOT NULL DEFAULT 0,
    valor_acrescimo numeric(18,2) NOT NULL DEFAULT 0,
    valor_total numeric(18,2) NOT NULL DEFAULT 0,
    observacao text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.fatura_item (
    fatura_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    fatura_id uuid NOT NULL,
    pedido_item_id uuid NULL,
    produto_id uuid NULL,
    descricao varchar(260) NOT NULL,
    quantidade numeric(18,4) NOT NULL DEFAULT 1,
    valor_unitario numeric(18,2) NOT NULL DEFAULT 0,
    valor_desconto numeric(18,2) NOT NULL DEFAULT 0,
    valor_total numeric(18,2) NOT NULL DEFAULT 0,
    ordem numeric(12,4) NOT NULL DEFAULT 0,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro (
    titulo_financeiro_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    filial_id uuid NULL,
    fatura_id uuid NULL,
    pedido_id uuid NULL,
    cliente_id uuid NOT NULL,
    codigo varchar(80) NOT NULL,
    tipo varchar(40) NOT NULL DEFAULT 'receber',
    origem varchar(60) NULL,
    status varchar(40) NOT NULL DEFAULT 'aberto',
    descricao varchar(260) NOT NULL,
    data_emissao date NOT NULL DEFAULT current_date,
    data_vencimento date NOT NULL,
    data_pagamento date NULL,
    valor_original numeric(18,2) NOT NULL,
    valor_desconto numeric(18,2) NOT NULL DEFAULT 0,
    valor_acrescimo numeric(18,2) NOT NULL DEFAULT 0,
    valor_pago numeric(18,2) NOT NULL DEFAULT 0,
    valor_aberto numeric(18,2) NOT NULL,
    forma_pagamento varchar(60) NULL,
    link_boleto text NULL,
    linha_digitavel text NULL,
    codigo_barras text NULL,
    nosso_numero varchar(120) NULL,
    observacao text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro_historico (
    titulo_financeiro_historico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    titulo_financeiro_id uuid NOT NULL,
    tipo_evento varchar(80) NOT NULL,
    descricao text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.boleto_log (
    boleto_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    titulo_financeiro_id uuid NOT NULL,
    provedor varchar(80) NOT NULL DEFAULT 'fake',
    status varchar(40) NOT NULL,
    request_json jsonb NULL,
    response_json jsonb NULL,
    link_boleto text NULL,
    linha_digitavel text NULL,
    codigo_barras text NULL,
    erro text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.nota_fiscal_referencia (
    nota_fiscal_referencia_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    fatura_id uuid NULL,
    pedido_id uuid NULL,
    cliente_id uuid NOT NULL,
    tipo varchar(40) NOT NULL DEFAULT 'nfe',
    status varchar(40) NOT NULL DEFAULT 'referenciada',
    numero varchar(80) NULL,
    serie varchar(40) NULL,
    chave_acesso varchar(120) NULL,
    data_emissao timestamptz NULL,
    valor_total numeric(18,2) NULL,
    xml_storage_key text NULL,
    danfe_storage_key text NULL,
    erro text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.documento_faturamento (
    documento_faturamento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    fatura_id uuid NULL,
    nota_fiscal_referencia_id uuid NULL,
    nome_arquivo varchar(260) NOT NULL,
    storage_key text NOT NULL,
    content_type varchar(120) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.cobranca_evento (
    cobranca_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    titulo_financeiro_id uuid NOT NULL,
    tipo varchar(80) NOT NULL,
    descricao text NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'criado',
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.financeiro_configuracao (
    financeiro_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    dias_vencimento_padrao int NOT NULL DEFAULT 7,
    permitir_boleto_fake boolean NOT NULL DEFAULT true,
    permitir_nf_fake boolean NOT NULL DEFAULT true,
    ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.mensagem_template (
    mensagem_template_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    canal varchar(40) NOT NULL,
    categoria varchar(80) NOT NULL,
    assunto_template varchar(260) NULL,
    corpo_template text NOT NULL,
    variaveis_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    publico boolean NOT NULL DEFAULT false,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.mensagem_envio (
    mensagem_envio_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    template_id uuid NULL,
    outbox_evento_id uuid NULL,
    canal varchar(40) NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'pendente',
    assunto varchar(260) NULL,
    corpo_renderizado text NOT NULL,
    origem_tipo varchar(80) NULL,
    origem_id uuid NULL,
    erro text NULL,
    tentativas int NOT NULL DEFAULT 0,
    enviado_em timestamptz NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.mensagem_envio_destinatario (
    mensagem_envio_destinatario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    mensagem_envio_id uuid NOT NULL,
    destinatario varchar(260) NOT NULL,
    nome varchar(180) NULL,
    status varchar(40) NOT NULL DEFAULT 'pendente',
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.canal_conversa (
    canal_conversa_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    canal varchar(40) NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'aberta',
    cliente_id uuid NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.canal_conversa_mensagem (
    canal_conversa_mensagem_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    canal_conversa_id uuid NOT NULL,
    direcao varchar(40) NOT NULL,
    corpo text NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'registrada',
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.connect_webhook_endpoint (
    connect_webhook_endpoint_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome varchar(180) NOT NULL,
    url text NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'ativo',
    ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.connect_webhook_evento (
    connect_webhook_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    connect_webhook_endpoint_id uuid NULL,
    tipo_evento varchar(120) NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'pendente',
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.connect_configuracao (
    connect_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    fake_providers_ativos boolean NOT NULL DEFAULT true,
    ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (
    outbox_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    tipo_evento varchar(120) NOT NULL,
    canal varchar(60) NULL,
    origem_tipo varchar(80) NULL,
    origem_id uuid NULL,
    prioridade varchar(20) NOT NULL DEFAULT 'normal',
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    status varchar(40) NOT NULL DEFAULT 'pendente',
    tentativas int NOT NULL DEFAULT 0,
    max_tentativas int NOT NULL DEFAULT 5,
    proxima_tentativa_em timestamptz NULL,
    processado_em timestamptz NULL,
    erro text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    correlation_id varchar(120) NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.outbox_processamento_log (
    outbox_processamento_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    outbox_evento_id uuid NOT NULL,
    status varchar(40) NOT NULL,
    erro text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.pedido_faturamento_vinculo (
    pedido_faturamento_vinculo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    pedido_id uuid NOT NULL,
    fatura_id uuid NULL,
    titulo_financeiro_id uuid NULL,
    status varchar(40) NOT NULL DEFAULT 'criado',
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.flow_faturamento_vinculo (
    flow_faturamento_vinculo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    processo_instancia_id uuid NULL,
    tarefa_id uuid NULL,
    pedido_id uuid NULL,
    fatura_id uuid NULL,
    titulo_financeiro_id uuid NULL,
    nota_fiscal_referencia_id uuid NULL,
    status varchar(40) NOT NULL DEFAULT 'criado',
    erro text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_mensagem_template_tenant_canal_codigo') THEN
        ALTER TABLE integrarp.mensagem_template ADD CONSTRAINT uq_mensagem_template_tenant_canal_codigo UNIQUE (tenant_id, canal, codigo);
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS ux_mensagem_template_tenant_canal_codigo_idx ON integrarp.mensagem_template (coalesce(tenant_id, '00000000-0000-0000-0000-000000000000'::uuid), canal, codigo);
CREATE INDEX IF NOT EXISTS ix_fatura_tenant_status ON integrarp.fatura (tenant_id, status);
CREATE INDEX IF NOT EXISTS ix_titulo_tenant_status ON integrarp.titulo_financeiro (tenant_id, status);
CREATE INDEX IF NOT EXISTS ix_mensagem_envio_tenant_status ON integrarp.mensagem_envio (tenant_id, status);
CREATE INDEX IF NOT EXISTS ix_outbox_tenant_status ON integrarp.outbox_evento (tenant_id, status, proxima_tentativa_em);

DROP TRIGGER IF EXISTS trg_fatura_atualizado_em ON integrarp.fatura;
CREATE TRIGGER trg_fatura_atualizado_em BEFORE UPDATE ON integrarp.fatura FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();
DROP TRIGGER IF EXISTS trg_titulo_atualizado_em ON integrarp.titulo_financeiro;
CREATE TRIGGER trg_titulo_atualizado_em BEFORE UPDATE ON integrarp.titulo_financeiro FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

CREATE OR REPLACE VIEW integrarp.vw_titulos_em_aberto AS
SELECT tenant_id, titulo_financeiro_id, codigo, cliente_id, data_vencimento, valor_aberto
FROM integrarp.titulo_financeiro
WHERE excluido_em IS NULL AND status IN ('aberto', 'enviado', 'pago_parcial');

CREATE OR REPLACE VIEW integrarp.vw_titulos_vencidos AS
SELECT tenant_id, titulo_financeiro_id, codigo, cliente_id, data_vencimento, valor_aberto
FROM integrarp.titulo_financeiro
WHERE excluido_em IS NULL AND status = 'vencido';

CREATE OR REPLACE VIEW integrarp.vw_outbox_pendente AS
SELECT tenant_id, outbox_evento_id, tipo_evento, canal, origem_tipo, origem_id, prioridade, tentativas, criado_em
FROM integrarp.outbox_evento
WHERE excluido_em IS NULL AND status = 'pendente';

CREATE OR REPLACE VIEW integrarp.vw_outbox_erros AS
SELECT tenant_id, outbox_evento_id, tipo_evento, canal, tentativas, max_tentativas, erro, criado_em
FROM integrarp.outbox_evento
WHERE excluido_em IS NULL AND status = 'erro';

CREATE OR REPLACE VIEW integrarp.vw_faturamento_por_status AS
SELECT tenant_id, status, count(*) AS total, coalesce(sum(valor_total), 0) AS valor_total
FROM integrarp.fatura
WHERE excluido_em IS NULL
GROUP BY tenant_id, status;

CREATE OR REPLACE VIEW integrarp.vw_financeiro_dashboard AS
SELECT
    f.tenant_id,
    coalesce(sum(f.valor_total) FILTER (WHERE date_trunc('month', f.data_emissao) = date_trunc('month', now())), 0) AS total_faturado_mes,
    count(*) FILTER (WHERE f.status = 'emitida') AS faturas_emitidas,
    (SELECT count(*) FROM integrarp.titulo_financeiro t WHERE t.tenant_id = f.tenant_id AND t.status IN ('aberto', 'enviado')) AS titulos_em_aberto,
    (SELECT count(*) FROM integrarp.titulo_financeiro t WHERE t.tenant_id = f.tenant_id AND t.status = 'vencido') AS titulos_vencidos,
    (SELECT coalesce(sum(t.valor_aberto), 0) FROM integrarp.titulo_financeiro t WHERE t.tenant_id = f.tenant_id AND t.status IN ('aberto', 'enviado')) AS valor_em_aberto,
    (SELECT coalesce(sum(t.valor_aberto), 0) FROM integrarp.titulo_financeiro t WHERE t.tenant_id = f.tenant_id AND t.status = 'vencido') AS valor_vencido
FROM integrarp.fatura f
WHERE f.excluido_em IS NULL
GROUP BY f.tenant_id;

CREATE OR REPLACE VIEW integrarp.vw_connect_dashboard AS
SELECT
    coalesce(m.tenant_id, o.tenant_id) AS tenant_id,
    count(m.*) FILTER (WHERE m.status = 'pendente') AS mensagens_pendentes,
    count(m.*) FILTER (WHERE m.status = 'enviado') AS mensagens_enviadas,
    count(m.*) FILTER (WHERE m.status = 'erro') AS mensagens_com_erro,
    count(o.*) FILTER (WHERE o.status = 'pendente') AS outbox_pendente,
    count(o.*) FILTER (WHERE o.status = 'processado') AS outbox_processado,
    count(o.*) FILTER (WHERE o.status = 'erro') AS outbox_com_erro
FROM integrarp.mensagem_envio m
FULL JOIN integrarp.outbox_evento o ON o.tenant_id = m.tenant_id
GROUP BY coalesce(m.tenant_id, o.tenant_id);

INSERT INTO integrarp.financeiro_configuracao (tenant_id, dias_vencimento_padrao, permitir_boleto_fake, permitir_nf_fake)
SELECT '00000000-0000-0000-0000-000000000001', 7, true, true
WHERE NOT EXISTS (SELECT 1 FROM integrarp.financeiro_configuracao WHERE tenant_id = '00000000-0000-0000-0000-000000000001');

INSERT INTO integrarp.mensagem_template (tenant_id, codigo, nome, canal, categoria, assunto_template, corpo_template, publico)
VALUES
(NULL, 'pedido_confirmado_email', 'Pedido confirmado', 'email', 'pedido', 'Pedido {{pedido_codigo}} confirmado', 'Olá {{cliente_nome}}, seu pedido {{pedido_codigo}} foi confirmado.', true),
(NULL, 'fatura_emitida_email', 'Fatura emitida', 'email', 'faturamento', 'Fatura {{fatura_codigo}} emitida', 'Olá {{cliente_nome}}, sua fatura {{fatura_codigo}} vence em {{data_vencimento}}.', true),
(NULL, 'boleto_gerado_email', 'Boleto gerado', 'email', 'cobranca', 'Boleto {{fatura_codigo}}', 'Boleto fake/log: {{link_boleto}}.', true),
(NULL, 'titulo_vencendo_email', 'Título vencendo', 'email', 'cobranca', 'Título vencendo', 'Seu título vence em {{data_vencimento}}.', true),
(NULL, 'titulo_vencido_email', 'Título vencido', 'email', 'cobranca', 'Título vencido', 'Seu título venceu. Valor: {{valor_total}}.', true),
(NULL, 'pedido_enviado_logistica_email', 'Pedido para logística', 'email', 'logistica', 'Pedido faturado', 'Pedido {{pedido_codigo}} liberado para logística.', true),
(NULL, 'pedido_confirmado_whatsapp', 'Pedido confirmado WhatsApp', 'whatsapp', 'pedido', NULL, 'FAKE-WHATSAPP Pedido {{pedido_codigo}} confirmado.', true),
(NULL, 'fatura_emitida_whatsapp', 'Fatura emitida WhatsApp', 'whatsapp', 'faturamento', NULL, 'FAKE-WHATSAPP Fatura {{fatura_codigo}} emitida.', true),
(NULL, 'boleto_gerado_whatsapp', 'Boleto gerado WhatsApp', 'whatsapp', 'cobranca', NULL, 'FAKE-WHATSAPP Boleto {{link_boleto}}.', true),
(NULL, 'titulo_vencendo_whatsapp', 'Título vencendo WhatsApp', 'whatsapp', 'cobranca', NULL, 'FAKE-WHATSAPP Vence em {{data_vencimento}}.', true),
(NULL, 'titulo_vencido_whatsapp', 'Título vencido WhatsApp', 'whatsapp', 'cobranca', NULL, 'FAKE-WHATSAPP Título vencido.', true),
(NULL, 'nova_tarefa_sistema', 'Nova tarefa', 'sistema', 'flow', NULL, 'Nova tarefa {{tarefa_codigo}} disponível.', true),
(NULL, 'tarefa_atrasada_sistema', 'Tarefa atrasada', 'sistema', 'flow', NULL, 'Tarefa {{tarefa_codigo}} atrasada.', true),
(NULL, 'faturamento_concluido_sistema', 'Faturamento concluído', 'sistema', 'faturamento', NULL, 'Faturamento concluído para pedido {{pedido_codigo}}.', true),
(NULL, 'erro_outbox_sistema', 'Erro outbox', 'sistema', 'outbox', NULL, 'Erro ao processar outbox {{outbox_evento_id}}.', true)
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.fatura (tenant_id, cliente_id, codigo, status, valor_total, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'FAT-DEMO-001', 'rascunho', 100.00, '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.fatura WHERE codigo = 'FAT-DEMO-001');

INSERT INTO integrarp.titulo_financeiro (tenant_id, cliente_id, codigo, status, descricao, data_vencimento, valor_original, valor_aberto, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'TIT-DEMO-ABERTO', 'aberto', 'Título demo aberto', current_date + 7, 100.00, 100.00, '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.titulo_financeiro WHERE codigo = 'TIT-DEMO-ABERTO');

INSERT INTO integrarp.titulo_financeiro (tenant_id, cliente_id, codigo, status, descricao, data_vencimento, valor_original, valor_aberto, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'TIT-DEMO-VENCIDO', 'vencido', 'Título demo vencido', current_date - 3, 75.00, 75.00, '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.titulo_financeiro WHERE codigo = 'TIT-DEMO-VENCIDO');

INSERT INTO integrarp.outbox_evento (tenant_id, tipo_evento, canal, prioridade, status, payload_json, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', 'connect.mensagem.enfileirada', 'email', 'normal', 'pendente', '{"demo":true}'::jsonb, '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.outbox_evento WHERE metadata_json->>'demo' = 'true' AND status = 'pendente');

INSERT INTO integrarp.outbox_evento (tenant_id, tipo_evento, canal, prioridade, status, tentativas, erro, payload_json, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', 'connect.mensagem.erro', 'email', 'alta', 'erro', 1, 'Erro fake demo', '{"demo":true}'::jsonb, '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.outbox_evento WHERE metadata_json->>'demo' = 'true' AND status = 'erro');

INSERT INTO integrarp.mensagem_envio (tenant_id, canal, status, assunto, corpo_renderizado, tentativas, enviado_em, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', 'email', 'enviado', 'Mensagem demo', 'FAKE-EMAIL enviado com sucesso.', 1, now(), '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.mensagem_envio WHERE metadata_json->>'demo' = 'true');
