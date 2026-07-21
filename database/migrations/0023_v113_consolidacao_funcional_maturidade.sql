-- v1.13 - Consolidação funcional, maturidade operacional e smoke E2E
CREATE TABLE IF NOT EXISTS integrarp.v113_functional_consolidation_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id),
    codigo text NOT NULL,
    modulo text NOT NULL,
    status text NOT NULL DEFAULT 'pendente',
    detalhe text NULL,
    proxima_acao text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_v113_functional_check_tenant_codigo_active
    ON integrarp.v113_functional_consolidation_check(tenant_id, codigo)
    WHERE excluido_em IS NULL;

DROP TRIGGER IF EXISTS trg_v113_functional_check_atualizado_em ON integrarp.v113_functional_consolidation_check;
CREATE TRIGGER trg_v113_functional_check_atualizado_em
BEFORE UPDATE ON integrarp.v113_functional_consolidation_check
FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

WITH t AS (SELECT id AS tenant_id FROM integrarp.tenant WHERE slug = 'demo')
INSERT INTO integrarp.v113_functional_consolidation_check (tenant_id, codigo, modulo, status, detalhe, proxima_acao, metadata_json)
SELECT t.tenant_id, v.codigo, v.modulo, v.status, v.detalhe, v.proxima_acao, jsonb_build_object('versao','v1.13')
FROM t
CROSS JOIN (VALUES
    ('clientes-crud','customers','funcional','CRUD com listagem, detalhe, criação, edição e soft delete via repository.','Homologar tela /customers'),
    ('produtos-crud','products','funcional','CRUD com listagem, detalhe, criação, edição e soft delete via repository.','Homologar tela /products'),
    ('estoque-consultas','inventory','funcional','Saldo, movimentos e estoque crítico retornam dados reais do tenant.','Homologar /inventory/critical'),
    ('pedidos-fluxo','orders','funcional','Consulta, criação, itens, confirmação e cancelamento sem 501.','Executar smoke de pedidos'),
    ('tarefas-fluxo','tasks','funcional','Detalhe, assumir, comentar e concluir tarefa sem 501.','Executar smoke de tarefas')
) AS v(codigo, modulo, status, detalhe, proxima_acao)
ON CONFLICT (tenant_id, codigo) WHERE excluido_em IS NULL
DO UPDATE SET status = EXCLUDED.status, detalhe = EXCLUDED.detalhe, proxima_acao = EXCLUDED.proxima_acao, metadata_json = EXCLUDED.metadata_json, atualizado_em = now();

WITH t AS (SELECT id AS tenant_id FROM integrarp.tenant WHERE slug = 'demo')
INSERT INTO integrarp.template_operacional (tenant_id,codigo,nome,descricao)
SELECT t.tenant_id,codigo,nome,descricao
FROM t
CROSS JOIN (VALUES
    ('visita-comercial','Visita Comercial','Roteiro comercial com atividade recomendada e acompanhamento.'),
    ('devolucao','Devolução','Fluxo operacional de devolução com triagem e ação financeira.'),
    ('registro-avaria','Registro de Avaria','Registro de avaria com evidência e próxima ação operacional.')
) v(codigo,nome,descricao)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL
DO UPDATE SET nome=EXCLUDED.nome, descricao=EXCLUDED.descricao, atualizado_em=now();

CREATE OR REPLACE VIEW integrarp.vw_v113_consolidacao_funcional_status AS
SELECT tenant_id, codigo, modulo, status, detalhe, proxima_acao
FROM integrarp.v113_functional_consolidation_check
WHERE excluido_em IS NULL;

-- v1.20: registro manual em schema_migrations removido; Migration Runner/script completo registram checksums.
