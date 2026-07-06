CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE TABLE IF NOT EXISTS integrarp.piloto_v1_demo_catalogo (
    id UUID PRIMARY KEY,
    categoria TEXT NOT NULL,
    chave TEXT NOT NULL,
    nome TEXT NOT NULL,
    descricao TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'ativo',
    tenant_demo TEXT NOT NULL DEFAULT 'Valora Group & MNSoft Demo',
    metadados JSONB NOT NULL DEFAULT '{}'::jsonb,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT now(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_piloto_v1_demo_catalogo UNIQUE (categoria, chave)
);

CREATE INDEX IF NOT EXISTS ix_piloto_v1_demo_catalogo_categoria
    ON integrarp.piloto_v1_demo_catalogo (categoria);

CREATE INDEX IF NOT EXISTS ix_piloto_v1_demo_catalogo_status
    ON integrarp.piloto_v1_demo_catalogo (status);

INSERT INTO integrarp.piloto_v1_demo_catalogo (id, categoria, chave, nome, descricao, status, metadados)
VALUES
    ('00000000-0012-0000-0000-000000000001', 'tenant', 'valora-mnsoft-demo', 'Valora Group & MNSoft Demo', 'Tenant demonstrativo do piloto v1.0.', 'ativo', '{"ambiente":"piloto","senha_demo":"Integr@RP-Piloto-2026!"}'),
    ('00000000-0012-0000-0000-000000000002', 'usuario', 'admin@integrarp.local', 'Administrador Geral', 'Conta demo para administração geral.', 'ativo', '{"perfil":"Administrador Geral"}'),
    ('00000000-0012-0000-0000-000000000003', 'usuario', 'diretor@integrarp.local', 'Diretor', 'Conta demo para visão executiva.', 'ativo', '{"perfil":"Diretor"}'),
    ('00000000-0012-0000-0000-000000000004', 'usuario', 'financeiro@integrarp.local', 'Financeiro', 'Conta demo para faturamento, títulos e boletos fake/log.', 'ativo', '{"perfil":"Financeiro"}'),
    ('00000000-0012-0000-0000-000000000005', 'usuario', 'vendas@integrarp.local', 'Vendas', 'Conta demo para cliente, produto e pedido.', 'ativo', '{"perfil":"Vendas"}'),
    ('00000000-0012-0000-0000-000000000006', 'usuario', 'logistica@integrarp.local', 'Logística', 'Conta demo para estoque, rotas e romaneios.', 'ativo', '{"perfil":"Logística"}'),
    ('00000000-0012-0000-0000-000000000007', 'usuario', 'motorista@integrarp.local', 'Motorista', 'Conta demo para POD, GPS, assinatura e ocorrências.', 'ativo', '{"perfil":"Motorista"}'),
    ('00000000-0012-0000-0000-000000000008', 'usuario', 'promotor@integrarp.local', 'Promotor de Vendas', 'Conta demo para execução em campo.', 'ativo', '{"perfil":"Promotor de Vendas"}'),
    ('00000000-0012-0000-0000-000000000009', 'usuario', 'auditor@integrarp.local', 'Auditor / LGPD', 'Conta demo para auditoria, LGPD e IA governada.', 'ativo', '{"perfil":"Auditor / LGPD"}'),
    ('00000000-0012-0000-0000-000000000010', 'cliente', 'cliente-alfa', 'Cliente Alfa Distribuição', 'Cliente demo com pedido confirmado e faturado.', 'ativo', '{}'),
    ('00000000-0012-0000-0000-000000000011', 'produto', 'sku-cafe-premium', 'Café Premium 500g', 'Produto demo com entrada, lote e reserva de estoque.', 'ativo', '{"sku":"CAF-PREM-500"}'),
    ('00000000-0012-0000-0000-000000000012', 'pedido', 'pedido-pos-venda', 'Pedido ao Pós-venda', 'Cenário ponta a ponta de pedido, faturamento, entrega e auditoria.', 'em_fluxo', '{"flow":"Pedido ao Pós-venda"}'),
    ('00000000-0012-0000-0000-000000000013', 'financeiro', 'boleto-fake-demo', 'Boleto fake demo', 'Título e boleto fake/log para homologação sem integração bancária real.', 'processado', '{"provider":"fake/log"}'),
    ('00000000-0012-0000-0000-000000000014', 'connect', 'outbox-pendente-demo', 'Outbox pendente demo', 'Mensagem pendente para validação do worker.', 'pendente', '{}'),
    ('00000000-0012-0000-0000-000000000015', 'connect', 'outbox-processado-demo', 'Outbox processado demo', 'Mensagem processada para histórico de conectividade.', 'processado', '{}'),
    ('00000000-0012-0000-0000-000000000016', 'flow', 'processo-pedido-pos-venda', 'Processo Pedido ao Pós-venda', 'Processo BPMN publicado para o piloto.', 'publicado', '{}'),
    ('00000000-0012-0000-0000-000000000017', 'studio', 'controle-avarias', 'Controle de Avarias', 'Módulo dinâmico publicado com registros demo.', 'publicado', '{}'),
    ('00000000-0012-0000-0000-000000000018', 'project', 'board-piloto-v1', 'Board Project Demo', 'Board com sprint, cards e feed de homologação.', 'ativo', '{}'),
    ('00000000-0012-0000-0000-000000000019', 'operacoes', 'rota-romaneio-pod-demo', 'Rota, Romaneio e POD Demo', 'Rota demo com paradas, ocorrência e comprovante de entrega.', 'ativo', '{}'),
    ('00000000-0012-0000-0000-000000000020', 'ia', 'conversa-governada-demo', 'Conversa IA Governada Demo', 'Perguntas autorizadas, fallback humano e auditoria da IA.', 'auditado', '{}')
ON CONFLICT (categoria, chave) DO UPDATE
SET nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    status = EXCLUDED.status,
    metadados = EXCLUDED.metadados,
    atualizado_em = now();

CREATE OR REPLACE VIEW integrarp.vw_piloto_validacao_fluxos AS
SELECT categoria, chave, nome, status
FROM integrarp.piloto_v1_demo_catalogo
WHERE categoria IN ('flow', 'studio', 'pedido', 'financeiro', 'connect', 'project', 'operacoes', 'ia');

CREATE OR REPLACE VIEW integrarp.vw_piloto_saude_operacional AS
SELECT status, count(*) AS total
FROM integrarp.piloto_v1_demo_catalogo
GROUP BY status;

CREATE OR REPLACE VIEW integrarp.vw_piloto_dados_demo AS
SELECT categoria, count(*) AS total
FROM integrarp.piloto_v1_demo_catalogo
GROUP BY categoria;

CREATE OR REPLACE VIEW integrarp.vw_piloto_pendencias AS
SELECT categoria, chave, nome, descricao
FROM integrarp.piloto_v1_demo_catalogo
WHERE status IN ('pendente', 'em_fluxo');
