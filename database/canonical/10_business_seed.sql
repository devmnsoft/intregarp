-- Fase 10: seed operacional mínimo, sem clientes, pedidos ou faturas demonstrativos.
INSERT INTO integrarp.setor(id,tenant_id,nome,status)
SELECT gen_random_uuid(),t.id,n,'ativo' FROM integrarp.tenant t CROSS JOIN unnest(ARRAY['Administração','Diretoria','Financeiro','Vendas','Logística','Operações','Auditoria / LGPD']) n
WHERE t.slug='valora-mnsoft-demo' AND NOT EXISTS (SELECT 1 FROM integrarp.setor s WHERE s.tenant_id=t.id AND s.nome=n AND s.excluido_em IS NULL);
INSERT INTO integrarp.estoque_local(id,tenant_id,codigo,nome,status)
SELECT gen_random_uuid(),t.id,'principal','Estoque Principal','ativo' FROM integrarp.tenant t WHERE t.slug='valora-mnsoft-demo'
AND NOT EXISTS (SELECT 1 FROM integrarp.estoque_local l WHERE l.tenant_id=t.id AND l.codigo='principal' AND l.excluido_em IS NULL);
WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.processo_definicao(id,processo_definicao_id,tenant_id,codigo,nome,descricao,status)
SELECT '16000000-0000-0000-0000-000000000100','16000000-0000-0000-0000-000000000100',id,'pedido-ao-faturamento','Pedido ao Faturamento','Fluxo operacional canônico','publicado' FROM t
ON CONFLICT(id) DO UPDATE SET descricao=EXCLUDED.descricao,status='publicado';
WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.processo_versao(id,processo_versao_id,tenant_id,processo_definicao_id,nome,codigo,status,numero_versao,publicado_em,bpmn_json)
SELECT '16000000-0000-0000-0000-000000000101','16000000-0000-0000-0000-000000000101',id,'16000000-0000-0000-0000-000000000100','Pedido ao Faturamento v1','pedido-ao-faturamento-v1','publicado',1,now(),'{}'::jsonb FROM t
ON CONFLICT(id) DO UPDATE SET status='publicado',numero_versao=1;
