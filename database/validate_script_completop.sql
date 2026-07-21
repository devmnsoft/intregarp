DO $$
DECLARE
  missing text;
  canonical_tables text[] := ARRAY[
    'schema_migrations','tenant','usuario','usuario_credencial','perfil','permissao','setor',
    'cliente','produto','estoque_movimento','pedido','pedido_item','tarefa_operacional',
    'auth_sessao','auth_refresh_token','auth_password_reset',
    'processo_definicao','processo_versao','processo_elemento','processo_transicao',
    'processo_instancia','processo_variavel','processo_auditoria_evento','outbox_evento'
  ];
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'integrarp') THEN
    RAISE EXCEPTION 'schema integrarp ausente';
  END IF;

  IF EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'integra') THEN
    RAISE EXCEPTION 'schema legado integra não permitido';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgcrypto') THEN
    RAISE EXCEPTION 'extensão pgcrypto ausente';
  END IF;

  FOREACH missing IN ARRAY canonical_tables LOOP
    IF NOT EXISTS (
      SELECT 1
      FROM information_schema.tables
      WHERE table_schema = 'integrarp'
        AND table_name = missing
        AND table_type = 'BASE TABLE'
    ) THEN
      RAISE EXCEPTION 'tabela crítica ausente: integrarp.%', missing;
    END IF;

    IF EXISTS (
      SELECT 1
      FROM information_schema.tables
      WHERE table_schema <> 'integrarp'
        AND table_name = missing
    ) THEN
      RAISE EXCEPTION 'tabela canônica duplicada fora de integrarp: %', missing;
    END IF;
  END LOOP;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='auth_password_reset' AND column_name='consumed_at') THEN
    RAISE EXCEPTION 'integrarp.auth_password_reset.consumed_at ausente';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_schema='integrarp' AND table_name='tenant' AND constraint_type='PRIMARY KEY') THEN
    RAISE EXCEPTION 'PK ausente em integrarp.tenant';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname='integrarp' AND tablename='tarefa_operacional') THEN
    RAISE EXCEPTION 'índices ausentes em integrarp.tarefa_operacional';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_type IN ('BASE TABLE','VIEW')
  ) THEN
    RAISE EXCEPTION 'objetos de negócio indevidos no schema public';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM information_schema.routines
    WHERE routine_schema = 'public'
      AND routine_name LIKE 'fn_%'
  ) THEN
    RAISE EXCEPTION 'função de negócio indevida no schema public';
  END IF;
END $$;

SELECT 'integrarp validation ok' AS status;
