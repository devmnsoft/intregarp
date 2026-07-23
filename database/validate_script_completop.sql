-- IntegraRP v1.29 validator
DO $$
DECLARE
  migration_count integer;
BEGIN
  SELECT count(*) INTO migration_count FROM regexp_matches(pg_read_file('database/script_completop.sql'), '-- >>> ', 'g');
  IF migration_count <> 35 THEN
    RAISE EXCEPTION 'script_completop v1.29 deve conter 35 migrations, encontrado %', migration_count;
  END IF;
END $$;
