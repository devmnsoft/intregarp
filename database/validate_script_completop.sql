-- Validação externa do contrato canônico IntegraRP v1.60.2 (SQL PostgreSQL puro).
DO $validation$
DECLARE missing text;
BEGIN
 IF current_setting('server_version_num')::integer NOT BETWEEN 160000 AND 169999 THEN RAISE EXCEPTION '[validation:postgresql] PostgreSQL 16 requerido'; END IF;
 IF to_regnamespace('integrarp') IS NULL THEN RAISE EXCEPTION '[validation:schema] integrarp ausente'; END IF;
 SELECT string_agg(v,', ') INTO missing FROM unnest(ARRAY[
 'tenant','usuario','usuario_credencial','perfil','permissao','usuario_perfil','perfil_permissao','setor','cliente','cliente_contato','cliente_endereco','produto_categoria','produto','estoque_local','estoque_saldo','estoque_movimento','estoque_reserva','pedido','pedido_item','orcamento','orcamento_item','processo_definicao','processo_versao','processo_elemento','processo_transicao','processo_instancia','tarefa','tarefa_comentario','tarefa_anexo','faturamento_pendente','notificacao','central_acao','auditoria_evento','outbox_evento','schema_migrations','schema_contract']) v WHERE to_regclass('integrarp.'||v) IS NULL;
 IF missing IS NOT NULL THEN RAISE EXCEPTION '[validation:tables] ausentes: %',missing; END IF;
 SELECT string_agg(t||'.'||c,', ') INTO missing FROM (VALUES
 ('tenant','slug'),('usuario','email'),('usuario','senha_hash'),('usuario','bloqueado_ate'),('usuario_credencial','password_hash'),
 ('processo_definicao','id'),('processo_definicao','processo_definicao_id'),('processo_definicao','descricao'),('processo_definicao','modulo_origem'),('processo_definicao','setor_dono_id'),('processo_definicao','versao_publicada_id'),('processo_definicao','metadata_json'),
 ('produto','preco'),('pedido','cliente_id'),('pedido','valor_total'),('tarefa','titulo'),('outbox_evento','payload_json'),('faturamento_pendente','pedido_id')) r(t,c)
 WHERE NOT EXISTS(SELECT FROM information_schema.columns x WHERE x.table_schema='integrarp' AND x.table_name=t AND x.column_name=c);
 IF missing IS NOT NULL THEN RAISE EXCEPTION '[validation:columns] ausentes: %',missing; END IF;
 IF EXISTS(SELECT 1 FROM pg_constraint c JOIN pg_class r ON r.oid=c.conrelid JOIN pg_namespace n ON n.oid=r.relnamespace WHERE n.nspname='integrarp' AND NOT c.convalidated) THEN RAISE EXCEPTION '[validation:constraints] inválidas'; END IF;
 IF NOT EXISTS(SELECT FROM pg_indexes WHERE schemaname='integrarp' AND tablename='processo_definicao' AND indexdef ILIKE '%tenant_id%codigo%') THEN RAISE EXCEPTION '[validation:indexes] processo_definicao tenant/codigo ausente'; END IF;
 IF EXISTS(SELECT FROM pg_views v WHERE v.schemaname='integrarp' AND NOT EXISTS(SELECT FROM pg_rewrite r WHERE r.ev_class=(quote_ident(v.schemaname)||'.'||quote_ident(v.viewname))::regclass)) THEN RAISE EXCEPTION '[validation:views] view inválida'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.tenant WHERE slug='valora-mnsoft-demo' AND status='ativo' AND excluido_em IS NULL) THEN RAISE EXCEPTION '[validation:tenant] piloto ausente'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.usuario u JOIN integrarp.usuario_credencial c ON c.usuario_id=u.id AND c.tenant_id=u.tenant_id WHERE lower(u.email)='admin@integrarp.local' AND c.password_hash LIKE 'AQAAAAIAAYagAAAA%') THEN RAISE EXCEPTION '[validation:credential] administrador/hash Identity v3 ausente'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.usuario_perfil up JOIN integrarp.perfil p ON p.id=up.perfil_id WHERE p.nome IN ('SuperAdmin','Administrador Geral')) THEN RAISE EXCEPTION '[validation:user-role] administrador sem perfil'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.perfil_permissao pp JOIN integrarp.permissao p ON p.id=pp.permissao_id WHERE p.codigo='dashboard.view') THEN RAISE EXCEPTION '[validation:role-permission] permissão ausente'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.processo_definicao WHERE codigo='pedido-ao-faturamento') THEN RAISE EXCEPTION '[validation:process] processo padrão ausente'; END IF;
 IF (SELECT count(*) FROM integrarp.schema_migrations WHERE success)<60 THEN RAISE EXCEPTION '[validation:ledger] incompleto'; END IF;
 IF NOT EXISTS(SELECT FROM integrarp.schema_contract WHERE product_version='v1.60.2' AND postgresql_major=16) THEN RAISE EXCEPTION '[validation:contract] v1.60.2 ausente'; END IF;
 IF EXISTS(SELECT FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relkind IN('r','p') AND c.relname NOT LIKE 'pg_%') THEN RAISE EXCEPTION '[validation:qualification] tabela de aplicação fora de integrarp'; END IF;
END $validation$;
SELECT sc.product_version AS versao,
 (SELECT count(*) FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='integrarp' AND c.relkind IN('r','p')) AS tabelas,
 (SELECT count(*) FROM integrarp.usuario WHERE excluido_em IS NULL) AS usuarios,
 (SELECT count(*) FROM integrarp.perfil WHERE excluido_em IS NULL) AS perfis,
 (SELECT count(*) FROM integrarp.permissao WHERE excluido_em IS NULL) AS permissoes,
 (SELECT count(*) FROM integrarp.processo_definicao WHERE excluido_em IS NULL) AS processos,
 true AS instalacao_valida
FROM integrarp.schema_contract sc WHERE sc.product_version='v1.60.2';
