-- Fase 12: validação dentro da mesma transação e liberação do lock após COMMIT.
DO $final_validation$
DECLARE missing text;
BEGIN
 SELECT string_agg(x,', ') INTO missing FROM unnest(ARRAY['tenant','usuario','usuario_credencial','usuario_perfil','perfil','permissao','perfil_permissao','setor','estoque_local','processo_definicao','processo_versao','schema_migrations','schema_contract']) x WHERE to_regclass('integrarp.'||x) IS NULL;
 IF missing IS NOT NULL THEN RAISE EXCEPTION '[final-validation:tables] ausentes: %',missing; END IF;
 IF NOT EXISTS(SELECT 1 FROM integrarp.tenant WHERE slug='valora-mnsoft-demo' AND status='ativo' AND excluido_em IS NULL) THEN RAISE EXCEPTION '[final-validation:tenant] tenant piloto ausente'; END IF;
 IF (SELECT count(*) FROM integrarp.schema_migrations WHERE success)=60 THEN NULL; ELSE RAISE EXCEPTION '[final-validation:ledger] esperado 60 registros'; END IF;
 IF EXISTS(SELECT 1 FROM pg_constraint c JOIN pg_class r ON r.oid=c.conrelid JOIN pg_namespace n ON n.oid=r.relnamespace WHERE n.nspname='integrarp' AND NOT c.convalidated) THEN RAISE EXCEPTION '[final-validation:constraints] constraint não validada'; END IF;
END $final_validation$;
COMMIT;
SELECT pg_advisory_unlock(16020260803);
