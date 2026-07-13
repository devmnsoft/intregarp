-- IntegraRP database complete idempotent script v1.9
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em()
RETURNS trigger AS $$ BEGIN NEW.atualizado_em = now(); RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS integrarp.schema_migrations (version text PRIMARY KEY, aplicado_em timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS integrarp.tenant (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), slug text NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
ALTER TABLE integrarp.tenant ADD COLUMN IF NOT EXISTS slug text;
UPDATE integrarp.tenant SET slug = lower(replace(nome,' ','-')) WHERE slug IS NULL;
ALTER TABLE integrarp.tenant ALTER COLUMN slug SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_tenant_slug ON integrarp.tenant(slug) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, email text NOT NULL, nome text NOT NULL, perfil text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_usuario_tenant_email ON integrarp.usuario(tenant_id,email) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.perfil (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, permissoes_json jsonb NOT NULL DEFAULT '[]'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_perfil_tenant_nome ON integrarp.perfil(tenant_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.permissao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, descricao text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_permissao_tenant_codigo ON integrarp.permissao(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.setor (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_setor_tenant_nome ON integrarp.setor(tenant_id,nome) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.cliente (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, documento text NULL, email text NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_tenant_nome ON integrarp.cliente(tenant_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.cliente_contato (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NOT NULL, nome text NOT NULL, email text NULL, telefone text NULL, principal boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_contato_principal ON integrarp.cliente_contato(cliente_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.cliente_endereco (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NOT NULL, logradouro text NOT NULL, cidade text NOT NULL, uf text NOT NULL, principal boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_endereco_principal ON integrarp.cliente_endereco(cliente_id,logradouro) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.produto_categoria (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_categoria_tenant_nome ON integrarp.produto_categoria(tenant_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.produto (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, categoria_id uuid NULL, sku text NOT NULL, nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', estoque_minimo numeric NOT NULL DEFAULT 0, estoque_atual numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_tenant_sku ON integrarp.produto(tenant_id,sku) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.estoque_local (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_local_tenant_codigo ON integrarp.estoque_local(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.estoque_movimento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, produto_id uuid NOT NULL, local_id uuid NOT NULL, tipo text NOT NULL, quantidade numeric NOT NULL, saldo_apos numeric NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

CREATE TABLE IF NOT EXISTS integrarp.pedido (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NULL, numero text NOT NULL, status text NOT NULL, valor_total numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_tenant_numero ON integrarp.pedido(tenant_id,numero) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.pedido_item (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NOT NULL, produto_id uuid NOT NULL, quantidade numeric NOT NULL, valor_unitario numeric NOT NULL, valor_total numeric NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_item_produto ON integrarp.pedido_item(pedido_id,produto_id) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.tarefa_operacional (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, codigo text NOT NULL, titulo text NOT NULL, status text NOT NULL, vencimento_em timestamptz NULL, responsavel_email text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_tarefa_operacional_tenant_codigo ON integrarp.tarefa_operacional(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.fatura (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, numero text NOT NULL, status text NOT NULL, valor_total numeric NOT NULL, emitida_em timestamptz NOT NULL DEFAULT now(), criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_fatura_tenant_numero ON integrarp.fatura(tenant_id,numero) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, fatura_id uuid NULL, numero text NOT NULL, valor numeric NOT NULL, vencimento date NOT NULL, status text NOT NULL, boleto_fake_linha_digitavel text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_titulo_financeiro_tenant_numero ON integrarp.titulo_financeiro(tenant_id,numero) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tipo text NOT NULL, payload_json jsonb NOT NULL DEFAULT '{}'::jsonb, status text NOT NULL DEFAULT 'pendente', tentativas int NOT NULL DEFAULT 0, max_tentativas int NOT NULL DEFAULT 3, proxima_tentativa_em timestamptz NULL, processado_em timestamptz NULL, erro text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_outbox_evento_tenant_tipo_status ON integrarp.outbox_evento(tenant_id,tipo,status) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.outbox_processamento_log (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, outbox_evento_id uuid NULL, status text NOT NULL, detalhe text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.worker_checkpoint (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, ultimo_processamento_em timestamptz NOT NULL DEFAULT now(), status text NOT NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_worker_checkpoint_tenant_codigo ON integrarp.worker_checkpoint(tenant_id,codigo);

CREATE TABLE IF NOT EXISTS integrarp.jornada_usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_usuario_tenant_codigo ON integrarp.jornada_usuario(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.jornada_etapa (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, jornada_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, ordem int NOT NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_etapa_codigo ON integrarp.jornada_etapa(jornada_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.jornada_progresso_usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, jornada_id uuid NOT NULL, percentual numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_progresso_usuario ON integrarp.jornada_progresso_usuario(tenant_id,usuario_id,jornada_id) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.jornada_acao_recomendada (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, descricao text NOT NULL, prioridade text NOT NULL DEFAULT 'media', rota_web text NOT NULL, motivo text NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_acao_tenant_codigo ON integrarp.jornada_acao_recomendada(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.template_operacional (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, descricao text NOT NULL, status text NOT NULL DEFAULT 'disponivel', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_template_operacional_tenant_codigo ON integrarp.template_operacional(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.atividade_operacional (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, descricao text NOT NULL, modulo text NOT NULL, rota_web text NOT NULL, rota_api text NULL, icone text NULL, ordem int NOT NULL DEFAULT 0, perfil_recomendado text NULL, status text NOT NULL DEFAULT 'funcional', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_atividade_operacional_tenant_codigo ON integrarp.atividade_operacional(tenant_id,codigo) WHERE excluido_em IS NULL;

-- =====================================================
-- V1.9 - SEED DEMO FUNCIONAL COMPLETO
-- =====================================================
INSERT INTO integrarp.tenant (slug,nome,metadata_json) VALUES ('demo','Demo IntegraRP','{"demo":true,"versao":"v1.9"}'::jsonb)
ON CONFLICT (slug) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome, metadata_json=EXCLUDED.metadata_json;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.permissao (tenant_id,codigo,descricao)
SELECT t.tenant_id, p.codigo, p.codigo FROM t CROSS JOIN (VALUES
('customers.view'),('customers.create'),('customers.update'),('products.view'),('products.create'),('inventory.view'),('inventory.entry'),('orders.view'),('orders.create'),('orders.confirm'),('tasks.view'),('tasks.claim'),('tasks.complete'),('billing.view'),('billing.create'),('outbox.view'),('outbox.process'),('dashboard.view'),('journey.view'),('templates.view'),('templates.install'),('activities.view')) p(codigo)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET descricao=EXCLUDED.descricao;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.perfil (tenant_id,nome,permissoes_json)
SELECT t.tenant_id, v.nome, (SELECT jsonb_agg(codigo ORDER BY codigo) FROM integrarp.permissao WHERE tenant_id=t.tenant_id) FROM t CROSS JOIN (VALUES ('Administrador'),('Gestor'),('Vendas'),('Operador'),('Financeiro'),('Logística')) v(nome)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET permissoes_json=EXCLUDED.permissoes_json;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.usuario (tenant_id,email,nome,perfil)
SELECT t.tenant_id, v.email, v.nome, v.perfil FROM t CROSS JOIN (VALUES
('admin@demo.integrarp.local','Admin Demo','Administrador'),('gestor@demo.integrarp.local','Gestor Demo','Gestor'),('vendedor@demo.integrarp.local','Vendedor Demo','Vendas'),('operador@demo.integrarp.local','Operador Demo','Operador'),('financeiro@demo.integrarp.local','Financeiro Demo','Financeiro'),('logistica@demo.integrarp.local','Logística Demo','Logística')) v(email,nome,perfil)
ON CONFLICT (tenant_id,email) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome, perfil=EXCLUDED.perfil;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.setor (tenant_id,nome) SELECT t.tenant_id, nome FROM t CROSS JOIN (VALUES ('Administração'),('Comercial'),('Estoque'),('Logística'),('Financeiro')) v(nome)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.cliente (tenant_id,nome,documento,email) SELECT t.tenant_id,nome,doc,email FROM t CROSS JOIN (VALUES ('Cliente Demo Atacado','00000000000191','atacado@demo.local'),('Cliente Demo Varejo','00000000000272','varejo@demo.local'),('Cliente Demo Interior','00000000000353','interior@demo.local')) v(nome,doc,email)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET documento=EXCLUDED.documento,email=EXCLUDED.email,status='ativo';
WITH c AS (SELECT tenant_id,id cliente_id,nome FROM integrarp.cliente WHERE nome LIKE 'Cliente Demo%')
INSERT INTO integrarp.cliente_contato (tenant_id,cliente_id,nome,email,telefone) SELECT tenant_id,cliente_id,'Contato principal '||nome,coalesce((SELECT email FROM integrarp.cliente cc WHERE cc.id=c.cliente_id),'contato@demo.local'),'11999990000' FROM c
ON CONFLICT (cliente_id,nome) WHERE excluido_em IS NULL DO UPDATE SET email=EXCLUDED.email;
WITH c AS (SELECT tenant_id,id cliente_id,nome FROM integrarp.cliente WHERE nome LIKE 'Cliente Demo%')
INSERT INTO integrarp.cliente_endereco (tenant_id,cliente_id,logradouro,cidade,uf) SELECT tenant_id,cliente_id,'Rua Demo, 100','São Paulo','SP' FROM c
ON CONFLICT (cliente_id,logradouro) WHERE excluido_em IS NULL DO UPDATE SET cidade=EXCLUDED.cidade;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.produto_categoria (tenant_id,nome) SELECT t.tenant_id,nome FROM t CROSS JOIN (VALUES ('Bebidas'),('Alimentos'),('Diversos')) v(nome)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), cat AS (SELECT tenant_id,id,nome FROM integrarp.produto_categoria)
INSERT INTO integrarp.produto (tenant_id,categoria_id,sku,nome,estoque_minimo,estoque_atual)
SELECT t.tenant_id, cat.id, v.sku, v.nome, v.minimo, v.saldo FROM t CROSS JOIN (VALUES ('DEMO-A','Produto Demo A','Bebidas',10,120),('DEMO-B','Produto Demo B','Alimentos',5,80),('DEMO-CRIT','Produto Demo Crítico','Diversos',20,3)) v(sku,nome,categoria,minimo,saldo) JOIN cat ON cat.tenant_id=t.tenant_id AND cat.nome=v.categoria
ON CONFLICT (tenant_id,sku) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome, estoque_minimo=EXCLUDED.estoque_minimo, estoque_atual=EXCLUDED.estoque_atual;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.estoque_local (tenant_id,codigo,nome) SELECT t.tenant_id,codigo,nome FROM t CROSS JOIN (VALUES ('principal','Estoque Principal'),('expedicao','Estoque Expedição')) v(codigo,nome)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome;
WITH p AS (SELECT p.tenant_id,p.id produto_id,p.estoque_atual,l.id local_id FROM integrarp.produto p JOIN integrarp.estoque_local l ON l.tenant_id=p.tenant_id AND l.codigo='principal' WHERE p.sku LIKE 'DEMO-%')
INSERT INTO integrarp.estoque_movimento (tenant_id,produto_id,local_id,tipo,quantidade,saldo_apos,metadata_json) SELECT tenant_id,produto_id,local_id,'entrada',estoque_atual,estoque_atual,'{"seed":"v1.9"}'::jsonb FROM p WHERE NOT EXISTS (SELECT 1 FROM integrarp.estoque_movimento m WHERE m.produto_id=p.produto_id AND m.metadata_json->>'seed'='v1.9');

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), c AS (SELECT * FROM integrarp.cliente WHERE nome='Cliente Demo Atacado')
INSERT INTO integrarp.pedido (tenant_id,cliente_id,numero,status,valor_total) SELECT t.tenant_id,c.id,v.numero,v.status,v.valor FROM t,c CROSS JOIN (VALUES ('PED-DEMO-001','rascunho',100),('PED-DEMO-002','confirmado',200),('PED-DEMO-003','aguardando_separacao',150),('PED-DEMO-004','faturavel',300)) v(numero,status,valor)
ON CONFLICT (tenant_id,numero) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,valor_total=EXCLUDED.valor_total;
WITH ped AS (SELECT * FROM integrarp.pedido WHERE numero LIKE 'PED-DEMO-%'), prod AS (SELECT * FROM integrarp.produto WHERE sku='DEMO-A')
INSERT INTO integrarp.pedido_item (tenant_id,pedido_id,produto_id,quantidade,valor_unitario,valor_total) SELECT ped.tenant_id,ped.id,prod.id,2,50,100 FROM ped JOIN prod ON prod.tenant_id=ped.tenant_id
ON CONFLICT (pedido_id,produto_id) WHERE excluido_em IS NULL DO UPDATE SET quantidade=EXCLUDED.quantidade,valor_total=EXCLUDED.valor_total;
WITH ped AS (SELECT * FROM integrarp.pedido WHERE numero LIKE 'PED-DEMO-%')
INSERT INTO integrarp.tarefa_operacional (tenant_id,pedido_id,codigo,titulo,status,vencimento_em,responsavel_email)
SELECT tenant_id,id,'TASK-'||numero, CASE status WHEN 'aguardando_separacao' THEN 'Separar pedido' WHEN 'faturavel' THEN 'Faturar pedido' ELSE 'Acompanhar pedido' END, CASE numero WHEN 'PED-DEMO-001' THEN 'pendente' WHEN 'PED-DEMO-002' THEN 'concluida' ELSE 'pendente' END, CASE numero WHEN 'PED-DEMO-003' THEN now()-interval '1 day' ELSE now()+interval '2 days' END, 'operador@demo.integrarp.local' FROM ped
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,vencimento_em=EXCLUDED.vencimento_em;
WITH ped AS (SELECT * FROM integrarp.pedido WHERE numero='PED-DEMO-004') INSERT INTO integrarp.fatura (tenant_id,pedido_id,numero,status,valor_total) SELECT tenant_id,id,'FAT-DEMO-001','emitida',valor_total FROM ped
ON CONFLICT (tenant_id,numero) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,valor_total=EXCLUDED.valor_total;
WITH f AS (SELECT * FROM integrarp.fatura WHERE numero='FAT-DEMO-001')
INSERT INTO integrarp.titulo_financeiro (tenant_id,fatura_id,numero,valor,vencimento,status,boleto_fake_linha_digitavel) SELECT tenant_id,id,v.numero,valor_total,v.vencimento,v.status,v.boleto FROM f CROSS JOIN (VALUES ('TIT-DEMO-001',CURRENT_DATE + 10,'aberto','34191.79001 01043.510047 91020.150008 8 90000000030000'),('TIT-DEMO-002',CURRENT_DATE - 5,'vencido','34191.79001 01043.510047 91020.150008 8 90000000015000')) v(numero,vencimento,status,boleto)
ON CONFLICT (tenant_id,numero) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,boleto_fake_linha_digitavel=EXCLUDED.boleto_fake_linha_digitavel;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.outbox_evento (tenant_id,tipo,payload_json,status,tentativas,erro) SELECT t.tenant_id,tipo,jsonb_build_object('demo',true,'tipo',tipo),status,tentativas,erro FROM t CROSS JOIN (VALUES ('demo.pendente','pendente',0,NULL),('demo.processado','processado',1,NULL),('demo.erro','erro',2,'Falha fake para retry')) v(tipo,status,tentativas,erro)
ON CONFLICT (tenant_id,tipo,status) WHERE excluido_em IS NULL DO UPDATE SET tentativas=EXCLUDED.tentativas,erro=EXCLUDED.erro;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.jornada_usuario (tenant_id,codigo,titulo) SELECT tenant_id,'primeiros-passos','Jornada primeiros passos' FROM t
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET titulo=EXCLUDED.titulo;
WITH j AS (SELECT * FROM integrarp.jornada_usuario WHERE codigo='primeiros-passos') INSERT INTO integrarp.jornada_etapa (tenant_id,jornada_id,codigo,titulo,ordem,status) SELECT tenant_id,id,codigo,titulo,ordem,status FROM j CROSS JOIN (VALUES ('cliente','Criar cliente',1,'concluida'),('produto','Criar produto',2,'concluida'),('estoque','Registrar estoque',3,'concluida'),('pedido','Criar pedido',4,'concluida'),('faturamento','Faturar',5,'pendente')) v(codigo,titulo,ordem,status)
ON CONFLICT (jornada_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status;
WITH j AS (SELECT * FROM integrarp.jornada_usuario WHERE codigo='primeiros-passos'), u AS (SELECT * FROM integrarp.usuario WHERE email='admin@demo.integrarp.local') INSERT INTO integrarp.jornada_progresso_usuario (tenant_id,usuario_id,jornada_id,percentual) SELECT j.tenant_id,u.id,j.id,80 FROM j,u
ON CONFLICT (tenant_id,usuario_id,jornada_id) WHERE excluido_em IS NULL DO UPDATE SET percentual=EXCLUDED.percentual;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.jornada_acao_recomendada (tenant_id,codigo,titulo,descricao,rota_web,motivo) SELECT t.tenant_id,'acompanhar-dashboard','Acompanhar dashboard','Fluxo demo carregado com dados reais.','/dashboard','seed v1.9' FROM t
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET titulo=EXCLUDED.titulo;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.template_operacional (tenant_id,codigo,nome,descricao) SELECT t.tenant_id,codigo,nome,descricao FROM t CROSS JOIN (VALUES ('pedido-faturamento','Pedido ao Faturamento','Fluxo completo pedido ao faturamento'),('separacao-pedido','Separação de Pedido','Checklist de separação'),('entrega-pod','Entrega com POD','Entrega com evidência'),('cobranca-vencido','Cobrança de Título Vencido','Cobrança operacional')) v(codigo,nome,descricao)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome,descricao=EXCLUDED.descricao;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.atividade_operacional (tenant_id,codigo,titulo,descricao,modulo,rota_web,rota_api,icone,ordem,perfil_recomendado,status,metadata_json) SELECT t.tenant_id,codigo,titulo,descricao,modulo,rota_web,rota_api,icone,ordem,perfil,status,jsonb_build_object('permissao',permissao) FROM t CROSS JOIN (VALUES
('cadastrar-cliente','Cadastrar cliente','Criar cliente demo ou real','Comercial','/customers','/api/customers','users',10,'Vendas','funcional','customers.create'),('cadastrar-produto','Cadastrar produto','Criar produto comercial','Estoque','/products','/api/products','box',20,'Operador','funcional','products.create'),('entrada-estoque','Registrar entrada de estoque','Atualizar saldo real','Estoque','/inventory','/api/inventory/entries','warehouse',30,'Operador','funcional','inventory.entry'),('criar-pedido','Criar pedido','Gerar pedido com itens','Pedidos','/orders','/api/orders','cart',40,'Vendas','funcional','orders.create'),('confirmar-pedido','Confirmar pedido','Confirmar pedido em rascunho','Pedidos','/orders','/api/orders/{id}/confirm','check',50,'Vendas','funcional','orders.confirm'),('minhas-tarefas','Ver minhas tarefas','Listar tarefas pendentes','Tarefas','/tasks/my','/api/tasks/my','tasks',60,'Operador','funcional','tasks.view'),('concluir-tarefa','Concluir tarefa','Finalizar tarefa operacional','Tarefas','/tasks/my','/api/tasks/{id}/complete','done',70,'Operador','funcional','tasks.complete'),('gerar-fatura','Gerar fatura','Faturar pedido','Financeiro','/billing/invoices','/api/billing/invoices','invoice',80,'Financeiro','funcional','billing.create'),('gerar-titulo','Gerar título','Criar título financeiro','Financeiro','/billing/titles','/api/billing/financial-titles','money',90,'Financeiro','funcional','billing.create'),('gerar-boleto-fake','Gerar boleto fake','Criar linha digitável fake','Financeiro','/billing/titles','/api/billing/financial-titles/{id}/fake-slip','barcode',100,'Financeiro','funcional','billing.create'),('processar-outbox','Processar outbox','Processar pendências Connect','Connect','/connect/outbox','/api/connect/outbox/process','send',110,'Administrador','funcional','outbox.process'),('ver-dashboard','Ver dashboard','Acompanhar KPIs reais','Dashboard','/dashboard','/api/dashboard','chart',120,'Gestor','funcional','dashboard.view'),('instalar-template','Instalar template','Instalar pacote operacional','Templates','/templates','/api/operational-templates','template',130,'Administrador','funcional','templates.install'),('ver-jornada','Ver jornada','Continuar onboarding','Jornada','/journey/what-to-do-now','/api/journey/what-to-do-now','map',140,'Gestor','funcional','journey.view')) v(codigo,titulo,descricao,modulo,rota_web,rota_api,icone,ordem,perfil,status,permissao)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET titulo=EXCLUDED.titulo,descricao=EXCLUDED.descricao,status=EXCLUDED.status,metadata_json=EXCLUDED.metadata_json;

CREATE OR REPLACE VIEW integrarp.vw_v19_o_que_fazer_agora AS
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), c AS (SELECT t.tenant_id, (SELECT count(*) FROM integrarp.cliente WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) clientes, (SELECT count(*) FROM integrarp.produto WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) produtos, (SELECT count(*) FROM integrarp.estoque_movimento WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) estoque, (SELECT count(*) FROM integrarp.pedido WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) pedidos, (SELECT count(*) FROM integrarp.pedido WHERE tenant_id=t.tenant_id AND status='rascunho' AND excluido_em IS NULL) rascunhos, (SELECT count(*) FROM integrarp.tarefa_operacional WHERE tenant_id=t.tenant_id AND status='pendente' AND excluido_em IS NULL) tarefas, (SELECT count(*) FROM integrarp.fatura WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) faturas, (SELECT count(*) FROM integrarp.titulo_financeiro WHERE tenant_id=t.tenant_id AND boleto_fake_linha_digitavel IS NOT NULL AND excluido_em IS NULL) boletos, (SELECT count(*) FROM integrarp.outbox_evento WHERE tenant_id=t.tenant_id AND status='pendente' AND excluido_em IS NULL) outbox_pendente, (SELECT count(*) FROM integrarp.outbox_evento WHERE tenant_id=t.tenant_id AND status='erro' AND excluido_em IS NULL) outbox_erro FROM t)
SELECT tenant_id,
CASE WHEN clientes=0 THEN 'criar-primeiro-cliente' WHEN produtos=0 THEN 'criar-primeiro-produto' WHEN estoque=0 THEN 'registrar-estoque' WHEN pedidos=0 THEN 'criar-pedido' WHEN rascunhos>0 THEN 'confirmar-pedido' WHEN tarefas>0 THEN 'concluir-tarefa' WHEN faturas=0 THEN 'gerar-fatura' WHEN boletos=0 THEN 'gerar-boleto-fake' WHEN outbox_pendente>0 THEN 'processar-outbox' WHEN outbox_erro>0 THEN 'reprocessar-outbox' ELSE 'acompanhar-dashboard' END AS codigo,
CASE WHEN clientes=0 THEN 'Criar primeiro cliente' WHEN produtos=0 THEN 'Criar primeiro produto' WHEN estoque=0 THEN 'Registrar estoque' WHEN pedidos=0 THEN 'Criar pedido' WHEN rascunhos>0 THEN 'Confirmar pedido' WHEN tarefas>0 THEN 'Concluir tarefa pendente' WHEN faturas=0 THEN 'Gerar fatura' WHEN boletos=0 THEN 'Gerar boleto fake' WHEN outbox_pendente>0 THEN 'Processar outbox' WHEN outbox_erro>0 THEN 'Reprocessar outbox' ELSE 'Acompanhar dashboard' END AS titulo,
'dados reais do banco'::text AS detalhe,
CASE WHEN clientes=0 THEN '/customers' WHEN produtos=0 THEN '/products' WHEN estoque=0 THEN '/inventory' WHEN pedidos=0 THEN '/orders' WHEN rascunhos>0 THEN '/orders' WHEN tarefas>0 THEN '/tasks/my' WHEN faturas=0 THEN '/billing/invoices' WHEN boletos=0 THEN '/billing/titles' WHEN outbox_pendente>0 OR outbox_erro>0 THEN '/connect/outbox' ELSE '/dashboard' END AS rota_web
FROM c;

CREATE OR REPLACE VIEW integrarp.vw_v19_demo_funcional_status AS
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
SELECT 'tenant_demo' check_codigo,'Tenant demo existe' check_titulo, CASE WHEN EXISTS(SELECT 1 FROM t) THEN 'ok' ELSE 'erro' END status, 'slug demo' detalhe, 'criar tenant demo' proxima_acao
UNION ALL SELECT 'usuarios_demo','Usuários demo existem',CASE WHEN (SELECT count(*) FROM integrarp.usuario u JOIN t ON t.tenant_id=u.tenant_id WHERE u.email LIKE '%@demo.integrarp.local')>=6 THEN 'ok' ELSE 'erro' END,'6 usuários esperados','reaplicar seed'
UNION ALL SELECT 'atividades','Atividades existem',CASE WHEN (SELECT count(*) FROM integrarp.atividade_operacional a JOIN t ON t.tenant_id=a.tenant_id)>=14 THEN 'ok' ELSE 'erro' END,'14 atividades mínimas','reaplicar seed'
UNION ALL SELECT 'fluxo_operacional','Cliente produto estoque pedido tarefa faturamento outbox',CASE WHEN EXISTS(SELECT 1 FROM integrarp.pedido p JOIN t ON t.tenant_id=p.tenant_id) AND EXISTS(SELECT 1 FROM integrarp.fatura f JOIN t ON t.tenant_id=f.tenant_id) THEN 'ok' ELSE 'erro' END,'fluxo demo','executar demo';

INSERT INTO integrarp.schema_migrations(version) VALUES ('0021_v19_demo_funcional_inserts_telas_jornada') ON CONFLICT (version) DO NOTHING;

-- Compatibilidade v1.8 preservada para testes de regressão
CREATE TABLE IF NOT EXISTS integrarp.v18_screen_audit (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo text NOT NULL, objeto text NOT NULL, status text NOT NULL, proxima_acao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.v18_template_catalog (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, descricao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.v18_functional_validation_check (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, area text NOT NULL, modulo text NOT NULL, status text NOT NULL, checks_json jsonb NOT NULL DEFAULT '{}'::jsonb, warnings_json jsonb NOT NULL DEFAULT '[]'::jsonb, proxima_acao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE INDEX IF NOT EXISTS ix_v18_screen_audit_tenant_modulo_status ON integrarp.v18_screen_audit(tenant_id,modulo,status);
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='ck_v18_screen_audit_status') THEN ALTER TABLE integrarp.v18_screen_audit ADD CONSTRAINT ck_v18_screen_audit_status CHECK (status IN ('ok','warning','error','funcional','pendente')); END IF; END $$;
DROP TRIGGER IF EXISTS trg_v18_screen_audit_atualizado_em ON integrarp.v18_screen_audit;
CREATE TRIGGER trg_v18_screen_audit_atualizado_em BEFORE UPDATE ON integrarp.v18_screen_audit FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
CREATE OR REPLACE VIEW integrarp.vw_v18_dashboard_operacional AS SELECT tenant_id, modulo, status, proxima_acao FROM integrarp.v18_screen_audit WHERE excluido_em IS NULL;
INSERT INTO integrarp.schema_migrations(version) VALUES ('0020_v18_produto_funcional_cruds_telas_jornada') ON CONFLICT (version) DO NOTHING;
-- v1.13 - Consolidação funcional, maturidade operacional e smoke E2E
SET search_path TO integrarp;

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

INSERT INTO integrarp.schema_migrations(version)
VALUES ('0023_v113_consolidacao_funcional_maturidade')
ON CONFLICT (version) DO NOTHING;
-- v1.14 - consolidação operacional e segurança real
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

ALTER TABLE integrarp.produto ADD COLUMN IF NOT EXISTS preco_custo numeric NOT NULL DEFAULT 0;
ALTER TABLE integrarp.produto ADD COLUMN IF NOT EXISTS preco_venda numeric NOT NULL DEFAULT 0;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS data_entrega_prevista timestamptz NULL;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS desconto_total numeric NOT NULL DEFAULT 0;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS setor_id uuid NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS descricao text NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS sla_minutos integer NULL;

CREATE TABLE IF NOT EXISTS integrarp.tarefa_comentario (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    tarefa_id uuid NOT NULL,
    author_user_id uuid NOT NULL,
    texto text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.pedido_status_historico (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    pedido_id uuid NOT NULL,
    status_anterior text NULL,
    status_novo text NOT NULL,
    motivo text NULL,
    usuario_id uuid NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS ix_produto_tenant_sku_ativo ON integrarp.produto (tenant_id, sku) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_responsavel ON integrarp.tarefa_operacional (tenant_id, responsavel_usuario_id, setor_id, status) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_comentario_tenant_tarefa ON integrarp.tarefa_comentario (tenant_id, tarefa_id) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_pedido_status_historico_tenant_pedido ON integrarp.pedido_status_historico (tenant_id, pedido_id, criado_em);
