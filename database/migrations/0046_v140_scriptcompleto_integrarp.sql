-- IntegraRP v1.40: metadados do contrato canônico, sem transação de topo.
CREATE TABLE IF NOT EXISTS integrarp.schema_contract (
    contract_name text PRIMARY KEY,
    product_version text NOT NULL,
    postgresql_major integer NOT NULL,
    schema_name text NOT NULL,
    migration_count integer NOT NULL,
    manifest_generated_at_utc timestamptz NOT NULL,
    installed_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_schema_contract_postgresql CHECK (postgresql_major = 16),
    CONSTRAINT ck_schema_contract_schema CHECK (schema_name = 'integrarp')
);

INSERT INTO integrarp.schema_contract (
    contract_name, product_version, postgresql_major, schema_name,
    migration_count, manifest_generated_at_utc
)
VALUES ('Banco Canônico Integrarp v1.40', 'v1.40', 16, 'integrarp', 46, '2026-07-28T00:00:00Z'::timestamptz)
ON CONFLICT (contract_name) DO UPDATE
SET product_version = EXCLUDED.product_version,
    postgresql_major = EXCLUDED.postgresql_major,
    schema_name = EXCLUDED.schema_name,
    migration_count = EXCLUDED.migration_count,
    manifest_generated_at_utc = EXCLUDED.manifest_generated_at_utc;

COMMENT ON TABLE integrarp.schema_contract IS 'Contrato canônico e versão instalada do banco IntegraRP.';
