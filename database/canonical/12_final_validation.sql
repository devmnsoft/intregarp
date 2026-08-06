-- Fase 12: validação dentro da mesma transação e liberação do lock após COMMIT.
DO $final_validation$
DECLARE missing text;
BEGIN
 SELECT string_agg(x,', ') INTO missing FROM unnest(ARRAY['tenant','usuario','usuario_credencial','usuario_perfil','perfil','permissao','perfil_permissao','setor','estoque_local','processo_definicao','processo_versao','schema_migrations','schema_contract']) x WHERE to_regclass('integrarp.'||x) IS NULL;
 IF missing IS NOT NULL THEN RAISE EXCEPTION '[final-validation:tables] ausentes: %',missing; END IF;
 IF NOT EXISTS(SELECT 1 FROM integrarp.tenant WHERE slug='valora-mnsoft-demo' AND status='ativo' AND excluido_em IS NULL) THEN RAISE EXCEPTION '[final-validation:tenant] tenant piloto ausente'; END IF;
 IF NOT EXISTS(SELECT 1 FROM integrarp.cliente WHERE id='16000000-0000-0000-0000-000000000200') THEN RAISE EXCEPTION '[final-validation:seed] cliente piloto ausente'; END IF;
 IF NOT EXISTS(SELECT 1 FROM integrarp.produto WHERE id='16000000-0000-0000-0000-000000000201' AND preco > 0) THEN RAISE EXCEPTION '[final-validation:seed] produto piloto ausente'; END IF;
 IF NOT EXISTS(SELECT 1 FROM integrarp.estoque_saldo WHERE produto_id='16000000-0000-0000-0000-000000000201' AND quantidade-reservado > 0) THEN RAISE EXCEPTION '[final-validation:seed] saldo de estoque piloto ausente'; END IF;
 IF NOT EXISTS(SELECT 1 FROM integrarp.pedido WHERE id='16000000-0000-0000-0000-000000000202' AND cliente_id IS NOT NULL AND valor_total > 0) THEN RAISE EXCEPTION '[final-validation:seed] pedido piloto ausente'; END IF;
 IF NOT EXISTS(SELECT 1 FROM integrarp.tarefa WHERE id='16000000-0000-0000-0000-000000000204' AND titulo IS NOT NULL) THEN RAISE EXCEPTION '[final-validation:seed] tarefa piloto ausente'; END IF;
 IF NOT EXISTS(SELECT 1 FROM integrarp.faturamento_pendente WHERE pedido_id='16000000-0000-0000-0000-000000000202' AND status='pendente') THEN RAISE EXCEPTION '[final-validation:seed] faturamento pendente ausente'; END IF;
 IF NOT EXISTS(SELECT 1 FROM integrarp.notificacao WHERE id='16000000-0000-0000-0000-000000000206') THEN RAISE EXCEPTION '[final-validation:seed] notificação ausente'; END IF;
 IF NOT EXISTS(SELECT 1 FROM integrarp.central_acao WHERE id='16000000-0000-0000-0000-000000000207' AND status='aberta') THEN RAISE EXCEPTION '[final-validation:seed] central de ações ausente'; END IF;
 IF (SELECT count(*) FROM integrarp.schema_migrations WHERE success)=60 THEN NULL; ELSE RAISE EXCEPTION '[final-validation:ledger] esperado 60 registros'; END IF;
 IF EXISTS(SELECT 1 FROM pg_constraint c JOIN pg_class r ON r.oid=c.conrelid JOIN pg_namespace n ON n.oid=r.relnamespace WHERE n.nspname='integrarp' AND NOT c.convalidated) THEN RAISE EXCEPTION '[final-validation:constraints] constraint não validada'; END IF;
END $final_validation$;
COMMIT;
SELECT pg_advisory_unlock(16020260803);
