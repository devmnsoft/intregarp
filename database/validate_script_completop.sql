DO $$
DECLARE missing text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname='integrarp') THEN RAISE EXCEPTION 'schema integrarp ausente'; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname='pgcrypto') THEN RAISE EXCEPTION 'extensão pgcrypto ausente'; END IF;
  FOREACH missing IN ARRAY ARRAY['schema_migrations','tenant','usuario','auth_sessao','auth_refresh_token','auth_password_reset','tarefa_operacional','process_definition','process_version','process_instance','workflow_task'] LOOP
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='integrarp' AND table_name=missing) THEN RAISE EXCEPTION 'tabela crítica ausente: %', missing; END IF;
  END LOOP;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='auth_password_reset' AND column_name='consumed_at') THEN RAISE EXCEPTION 'auth_password_reset.consumed_at ausente'; END IF;
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE') THEN RAISE EXCEPTION 'objetos indevidos no schema public'; END IF;
END $$;

SELECT 'integrarp validation ok' AS status;
