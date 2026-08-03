-- Fase 02: metadados do contrato.
CREATE TABLE IF NOT EXISTS integrarp.schema_contract (
 contract_name text PRIMARY KEY, product_version text NOT NULL, postgresql_major integer NOT NULL,
 schema_name text NOT NULL, migration_count integer NOT NULL, manifest_generated_at_utc timestamptz NOT NULL,
 installed_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(),
 installer_checksum text NULL, install_mode text NOT NULL DEFAULT 'Development'
);
ALTER TABLE integrarp.schema_contract ADD COLUMN IF NOT EXISTS installer_checksum text;
ALTER TABLE integrarp.schema_contract ADD COLUMN IF NOT EXISTS install_mode text NOT NULL DEFAULT 'Development';
