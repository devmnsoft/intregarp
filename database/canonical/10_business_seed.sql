-- Fase 10: seed operacional mínimo e determinístico para a jornada de
-- homologação. UUIDs estáveis e ON CONFLICT tornam a instalação repetível.
INSERT INTO integrarp.setor(id,tenant_id,nome,status)
SELECT gen_random_uuid(),t.id,n,'ativo' FROM integrarp.tenant t CROSS JOIN unnest(ARRAY['Administração','Diretoria','Financeiro','Vendas','Logística','Operações','Auditoria / LGPD']) n
WHERE t.slug='valora-mnsoft-demo' AND NOT EXISTS (SELECT 1 FROM integrarp.setor s WHERE s.tenant_id=t.id AND s.nome=n AND s.excluido_em IS NULL);
INSERT INTO integrarp.estoque_local(id,tenant_id,codigo,nome,status)
SELECT gen_random_uuid(),t.id,'principal','Estoque Principal','ativo' FROM integrarp.tenant t WHERE t.slug='valora-mnsoft-demo'
AND NOT EXISTS (SELECT 1 FROM integrarp.estoque_local l WHERE l.tenant_id=t.id AND l.codigo='principal' AND l.excluido_em IS NULL);
WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.processo_definicao(id,tenant_id,codigo,nome,descricao,status)
SELECT '16000000-0000-0000-0000-000000000100',id,'pedido-ao-faturamento','Pedido ao Faturamento','Fluxo operacional canônico','publicado' FROM t
ON CONFLICT(id) DO UPDATE SET descricao=EXCLUDED.descricao,status='publicado';
WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.processo_versao(id,processo_versao_id,tenant_id,processo_definicao_id,nome,codigo,status,numero_versao,publicado_em,bpmn_json)
SELECT '16000000-0000-0000-0000-000000000101','16000000-0000-0000-0000-000000000101',id,'16000000-0000-0000-0000-000000000100','Pedido ao Faturamento v1','pedido-ao-faturamento-v1','publicado',1,now(),'{}'::jsonb FROM t
ON CONFLICT(id) DO UPDATE SET status='publicado',numero_versao=1;

WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.cliente(id,tenant_id,nome,codigo,status,dados)
SELECT '16000000-0000-0000-0000-000000000200',id,'Cliente Piloto Valora','CLI-PILOTO','ativo','{"documento":"12.345.678/0001-90","email":"contato@valora.local"}'::jsonb FROM t
ON CONFLICT(id) DO UPDATE SET nome=EXCLUDED.nome,status='ativo';

WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.produto(id,tenant_id,nome,codigo,status,preco,dados)
SELECT '16000000-0000-0000-0000-000000000201',id,'Produto Operacional Piloto','SKU-PILOTO','ativo',249.90,'{"estoque_minimo":5}'::jsonb FROM t
ON CONFLICT(id) DO UPDATE SET nome=EXCLUDED.nome,preco=EXCLUDED.preco,status='ativo';

WITH contexto AS (
 SELECT t.id AS tenant_id,l.id AS local_id FROM integrarp.tenant t
 JOIN integrarp.estoque_local l ON l.tenant_id=t.id AND l.codigo='principal'
 WHERE t.slug='valora-mnsoft-demo'
)
INSERT INTO integrarp.estoque_saldo(id,tenant_id,produto_id,estoque_local_id,quantidade,reservado,status)
SELECT '16000000-0000-0000-0000-000000000208',tenant_id,'16000000-0000-0000-0000-000000000201',local_id,12,1,'ativo' FROM contexto
ON CONFLICT(tenant_id,produto_id,estoque_local_id) DO UPDATE SET quantidade=12,reservado=1,status='ativo';

WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.pedido(id,tenant_id,nome,codigo,numero,cliente_id,status,valor_total,dados)
SELECT '16000000-0000-0000-0000-000000000202',id,'Pedido piloto','PED-PILOTO','PED-0001','16000000-0000-0000-0000-000000000200','confirmado',249.90,'{"origem":"instalador-v1.61"}'::jsonb FROM t
ON CONFLICT(id) DO UPDATE SET cliente_id=EXCLUDED.cliente_id,valor_total=EXCLUDED.valor_total,status='confirmado';

WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.processo_instancia(id,processo_instancia_id,tenant_id,processo_definicao_id,nome,codigo,status,dados)
SELECT '16000000-0000-0000-0000-000000000203','16000000-0000-0000-0000-000000000203',id,'16000000-0000-0000-0000-000000000100','Execução do pedido piloto','PROC-PILOTO','em_andamento','{"pedido_id":"16000000-0000-0000-0000-000000000202"}'::jsonb FROM t
ON CONFLICT(id) DO UPDATE SET processo_instancia_id=EXCLUDED.processo_instancia_id,processo_definicao_id=EXCLUDED.processo_definicao_id,status='em_andamento';

WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.tarefa(id,tenant_id,nome,titulo,codigo,status,prioridade,dados)
SELECT '16000000-0000-0000-0000-000000000204',id,'Conferir pedido piloto','Conferir pedido piloto','TAR-PILOTO','pendente','alta','{"pedido_id":"16000000-0000-0000-0000-000000000202"}'::jsonb FROM t
ON CONFLICT(id) DO UPDATE SET titulo=EXCLUDED.titulo,status='pendente',prioridade='alta';

WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.faturamento_pendente(id,tenant_id,pedido_id,processo_instancia_id,tarefa_id,status)
SELECT '16000000-0000-0000-0000-000000000205',id,'16000000-0000-0000-0000-000000000202','16000000-0000-0000-0000-000000000203','16000000-0000-0000-0000-000000000204','pendente' FROM t
ON CONFLICT(tenant_id,pedido_id) DO UPDATE SET status='pendente',processo_instancia_id=EXCLUDED.processo_instancia_id,tarefa_id=EXCLUDED.tarefa_id;

WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.notificacao(id,tenant_id,evento,titulo,corpo,canal,status,metadata_json)
SELECT '16000000-0000-0000-0000-000000000206',id,'pedido.pendente_faturamento','Pedido pronto para análise','Revise as pendências antes de preparar o faturamento.','sistema','pendente','{}'::jsonb FROM t
ON CONFLICT(id) DO UPDATE SET titulo=EXCLUDED.titulo,corpo=EXCLUDED.corpo,status='pendente';

WITH t AS (SELECT id FROM integrarp.tenant WHERE slug='valora-mnsoft-demo')
INSERT INTO integrarp.central_acao(id,tenant_id,tipo,entidade_tipo,entidade_id,titulo,impacto,prazo_em,acao_recomendada,deep_link,prioridade,status)
SELECT '16000000-0000-0000-0000-000000000207',id,'faturamento_pendente','pedido','16000000-0000-0000-0000-000000000202','Preparar faturamento do pedido PED-0001','O pedido permanece aguardando faturamento.',now()+interval '1 day','Revisar documentos e concluir a preparação.','/Orders/Billing',1,'aberta' FROM t
ON CONFLICT(tenant_id,tipo,entidade_tipo,entidade_id) DO UPDATE SET titulo=EXCLUDED.titulo,impacto=EXCLUDED.impacto,status='aberta';
