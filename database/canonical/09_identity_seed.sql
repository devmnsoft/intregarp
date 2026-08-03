-- Fase 09: identidade mínima Development/Pilot. Hash ASP.NET Identity v3 (PBKDF2-SHA512/100000).
ALTER TABLE integrarp.usuario ADD COLUMN IF NOT EXISTS is_global boolean NOT NULL DEFAULT false;
ALTER TABLE integrarp.perfil ADD COLUMN IF NOT EXISTS escopo text NOT NULL DEFAULT 'tenant';
INSERT INTO integrarp.tenant (id, slug, nome, status)
VALUES ('11111111-1111-1111-1111-111111111111','valora-mnsoft-demo','Valora Group & MNSoft Demo','ativo')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug,nome=EXCLUDED.nome,status='ativo',excluido_em=NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_tenant_slug_ativo ON integrarp.tenant(lower(slug)) WHERE excluido_em IS NULL AND status='ativo';

INSERT INTO integrarp.perfil (id,tenant_id,nome,permissoes_json,escopo)
SELECT gen_random_uuid(),t.id,n,'[]'::jsonb,CASE WHEN n='SuperAdmin' THEN 'global' ELSE 'tenant' END
FROM integrarp.tenant t CROSS JOIN unnest(ARRAY['SuperAdmin','Administrador Geral','Diretor','Financeiro','Vendas','Logística','Operador','Auditor / LGPD']) n
WHERE t.slug='valora-mnsoft-demo' AND NOT EXISTS (SELECT 1 FROM integrarp.perfil p WHERE p.tenant_id=t.id AND p.nome=n AND p.excluido_em IS NULL);

INSERT INTO integrarp.permissao (id,tenant_id,codigo,descricao)
SELECT gen_random_uuid(),t.id,c,c FROM integrarp.tenant t CROSS JOIN unnest(ARRAY[
'dashboard.view','customers.view','customers.create','customers.update','customers.deactivate','opportunities.view','opportunities.create','opportunities.update','quotes.view','quotes.create','quotes.update','quotes.approve','products.view','products.manage','inventory.view','inventory.entry','inventory.adjust','orders.view','orders.create','orders.confirm','orders.cancel','tasks.view','tasks.claim','tasks.execute','processes.view','billing.view','billing.manage','users.view','users.manage','tenants.view','tenants.manage','audit.view','notifications.view','superadmin.access']) c
WHERE t.slug='valora-mnsoft-demo' AND NOT EXISTS (SELECT 1 FROM integrarp.permissao p WHERE p.tenant_id=t.id AND p.codigo=c AND p.excluido_em IS NULL);

INSERT INTO integrarp.perfil_permissao(tenant_id,perfil_id,permissao_id)
SELECT p.tenant_id,p.id,x.id FROM integrarp.perfil p JOIN integrarp.permissao x ON x.tenant_id=p.tenant_id
WHERE p.excluido_em IS NULL AND x.excluido_em IS NULL AND NOT EXISTS
 (SELECT 1 FROM integrarp.perfil_permissao pp WHERE pp.tenant_id=p.tenant_id AND pp.perfil_id=p.id AND pp.permissao_id=x.id AND pp.excluido_em IS NULL);

WITH accounts(email,nome,role,global_account) AS (VALUES
 ('admin@integrarp.local','Administrador IntegraRP','SuperAdmin',true),
 ('diretor@integrarp.local','Diretor Piloto','Diretor',false),('financeiro@integrarp.local','Financeiro Piloto','Financeiro',false),
 ('vendas@integrarp.local','Vendas Piloto','Vendas',false),('logistica@integrarp.local','Logística Piloto','Logística',false),
 ('operador@integrarp.local','Operador Piloto','Operador',false),('auditor@integrarp.local','Auditor Piloto','Auditor / LGPD',false))
INSERT INTO integrarp.usuario(id,tenant_id,email,nome,perfil,status,is_global)
SELECT gen_random_uuid(),t.id,a.email,a.nome,a.role,'ativo',a.global_account FROM accounts a CROSS JOIN integrarp.tenant t
WHERE t.slug='valora-mnsoft-demo' AND NOT EXISTS (SELECT 1 FROM integrarp.usuario u WHERE u.tenant_id=t.id AND lower(u.email)=lower(a.email) AND u.excluido_em IS NULL);

INSERT INTO integrarp.usuario_perfil(tenant_id,usuario_id,perfil_id)
SELECT u.tenant_id,u.id,p.id FROM integrarp.usuario u JOIN integrarp.perfil p ON p.tenant_id=u.tenant_id AND p.nome=u.perfil
WHERE u.email LIKE '%@integrarp.local' AND NOT EXISTS (SELECT 1 FROM integrarp.usuario_perfil up WHERE up.tenant_id=u.tenant_id AND up.usuario_id=u.id AND up.perfil_id=p.id AND up.excluido_em IS NULL);

INSERT INTO integrarp.usuario_credencial(tenant_id,usuario_id,password_hash,force_change)
SELECT u.tenant_id,u.id,'AQAAAAIAAYagAAAAEBYBYBYBYBYBYBYBYBYBYBbcIOkFAFB33XCvH7YRbEaAya/c/8AaxRM/DTL6v1QSJg==',true
FROM integrarp.usuario u WHERE u.email LIKE '%@integrarp.local' AND NOT EXISTS
 (SELECT 1 FROM integrarp.usuario_credencial c WHERE c.tenant_id=u.tenant_id AND c.usuario_id=u.id AND c.excluido_em IS NULL);

INSERT INTO integrarp.auditoria_evento(tenant_id,usuario_id,entidade,entidade_id,acao,metadata_json)
SELECT u.tenant_id,u.id,'usuario',u.id,'bootstrap.superadmin','{"force_change":true,"installer":"canonical-v1.60"}'::jsonb
FROM integrarp.usuario u WHERE u.is_global AND NOT EXISTS (SELECT 1 FROM integrarp.auditoria_evento a WHERE a.entidade_id=u.id AND a.acao='bootstrap.superadmin');
