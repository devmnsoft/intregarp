-- Fase 01: preflight atômico. Execute com psql --set ON_ERROR_STOP=1.
DO $preflight$
BEGIN
  IF current_setting('server_version_num')::integer NOT BETWEEN 160000 AND 169999 THEN
    RAISE EXCEPTION '[preflight:postgresql] PostgreSQL 16 requerido; encontrado %', current_setting('server_version');
  END IF;
END $preflight$;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;
SELECT pg_advisory_lock(16020260803);
BEGIN;
