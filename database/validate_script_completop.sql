-- Produto: IntegraRP
-- Versao: v1.30
-- Validador do script completo
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'integrarp') THEN
    RAISE EXCEPTION 'Schema integrarp ausente';
  END IF;
END $$;
