-- Validação externa executável do contrato canônico IntegraRP v1.60 (SQL puro).
DO $validation$
DECLARE missing text;
BEGIN
 IF current_setting('server_version_num')::integer NOT BETWEEN 160000 AND 169999 THEN RAISE EXCEPTION '[validation:postgresql] PostgreSQL 16 requerido'; END IF;
 IF to_regnamespace('integrarp') IS NULL THEN RAISE EXCEPTION '[validation:schema] integrarp ausente'; END IF;
 SELECT string_agg(v,', ') INTO missing FROM unnest(ARRAY['tenant','usuario','usuario_credencial','usuario_perfil','perfil','permissao','perfil_permissao','setor','estoque_local','processo_definicao','processo_versao','schema_migrations','schema_contract']) v WHERE to_regclass('integrarp.'||v) IS NULL;
 IF missing IS NOT NULL THEN RAISE EXCEPTION '[validation:tables] ausentes: %',missing; END IF;
 SELECT string_agg(t||'.'||c,', ') INTO missing FROM (VALUES ('tenant','slug'),('usuario','email'),('usuario_credencial','password_hash'),('processo_definicao','descricao'),('processo_versao','numero_versao')) r(t,c) WHERE NOT EXISTS(SELECT FROM information_schema.columns x WHERE x.table_schema='integrarp' AND x.table_name=t AND x.column_name=c);
 IF missing IS NOT NULL THEN RAISE EXCEPTION '[validation:columns] ausentes: %',missing; END IF;
 IF EXISTS(SELECT 1 FROM pg_constraint c JOIN pg_class r ON r.oid=c.conrelid JOIN pg_namespace n ON n.oid=r.relnamespace WHERE n.nspname='integrarp' AND NOT c.convalidated) THEN RAISE EXCEPTION '[validation:constraints] inválidas'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.tenant WHERE slug='valora-mnsoft-demo' AND status='ativo' AND excluido_em IS NULL) THEN RAISE EXCEPTION '[validation:tenant] piloto ausente'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.usuario u JOIN integrarp.usuario_credencial c ON c.usuario_id=u.id WHERE lower(u.email)='admin@integrarp.local' AND length(c.password_hash)>20) THEN RAISE EXCEPTION '[validation:credential] administrador/credencial ausente'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.usuario_perfil) THEN RAISE EXCEPTION '[validation:user-role] vínculo ausente'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.perfil_permissao) THEN RAISE EXCEPTION '[validation:role-permission] vínculo ausente'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.setor WHERE excluido_em IS NULL) THEN RAISE EXCEPTION '[validation:setor] ausente'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.estoque_local WHERE codigo='principal' AND excluido_em IS NULL) THEN RAISE EXCEPTION '[validation:stock-location] ausente'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.processo_definicao WHERE codigo='pedido-ao-faturamento') OR NOT EXISTS(SELECT FROM integrarp.processo_versao WHERE status='publicado' AND numero_versao=1) THEN RAISE EXCEPTION '[validation:process] template publicado ausente'; END IF;
 IF (SELECT count(*) FROM integrarp.schema_migrations WHERE success)<>60 THEN RAISE EXCEPTION '[validation:ledger] esperado 60'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.schema_contract WHERE product_version='v1.60' AND migration_count=60) THEN RAISE EXCEPTION '[validation:contract] v1.60 ausente'; END IF;
 IF EXISTS(SELECT FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relkind IN('r','p') AND c.relname NOT LIKE 'pg_%') THEN RAISE EXCEPTION '[validation:qualification] tabela de aplicação fora de integrarp'; END IF;
END $validation$;
SELECT sc.product_version AS versao,t.nome AS tenant,
 (SELECT count(*) FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='integrarp' AND c.relkind IN('r','p')) AS quantidade_tabelas,
 (SELECT count(*) FROM integrarp.usuario WHERE excluido_em IS NULL) AS quantidade_usuarios,
 (SELECT count(*) FROM integrarp.perfil WHERE excluido_em IS NULL) AS quantidade_perfis,
 (SELECT count(*) FROM integrarp.permissao WHERE excluido_em IS NULL) AS quantidade_permissoes,
 (SELECT count(*) FROM integrarp.modulo_dinamico WHERE excluido_em IS NULL) AS quantidade_modulos,
 (SELECT count(*) FROM integrarp.processo_definicao WHERE excluido_em IS NULL) AS quantidade_processos,true AS instalacao_valida
FROM integrarp.schema_contract sc CROSS JOIN integrarp.tenant t WHERE sc.product_version='v1.60' AND t.slug='valora-mnsoft-demo';
