-- IntegraRP v1.43: converge o contrato de processos antes da criação de índices.
-- A migration é aditiva e pode ser promovida pelo gerador antes da migration 0003.
ALTER TABLE IF EXISTS integrarp.processo_definicao
  ADD COLUMN IF NOT EXISTS processo_definicao_id uuid;
UPDATE integrarp.processo_definicao
SET processo_definicao_id = id
WHERE processo_definicao_id IS NULL AND id IS NOT NULL;

ALTER TABLE IF EXISTS integrarp.processo_versao
  ADD COLUMN IF NOT EXISTS processo_versao_id uuid,
  ADD COLUMN IF NOT EXISTS processo_definicao_id uuid,
  ADD COLUMN IF NOT EXISTS numero integer,
  ADD COLUMN IF NOT EXISTS descricao text,
  ADD COLUMN IF NOT EXISTS bpmn_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  ADD COLUMN IF NOT EXISTS publicado_em timestamptz;
UPDATE integrarp.processo_versao SET processo_versao_id = id WHERE processo_versao_id IS NULL AND id IS NOT NULL;

ALTER TABLE IF EXISTS integrarp.processo_elemento
  ADD COLUMN IF NOT EXISTS processo_elemento_id uuid,
  ADD COLUMN IF NOT EXISTS processo_versao_id uuid,
  ADD COLUMN IF NOT EXISTS tipo varchar(80),
  ADD COLUMN IF NOT EXISTS configuracao_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  ADD COLUMN IF NOT EXISTS posicao_x numeric(12,2),
  ADD COLUMN IF NOT EXISTS posicao_y numeric(12,2);
UPDATE integrarp.processo_elemento SET processo_elemento_id = id WHERE processo_elemento_id IS NULL AND id IS NOT NULL;

ALTER TABLE IF EXISTS integrarp.processo_transicao
  ADD COLUMN IF NOT EXISTS processo_transicao_id uuid,
  ADD COLUMN IF NOT EXISTS processo_versao_id uuid,
  ADD COLUMN IF NOT EXISTS elemento_origem_id uuid,
  ADD COLUMN IF NOT EXISTS elemento_destino_id uuid,
  ADD COLUMN IF NOT EXISTS condicao_json jsonb NOT NULL DEFAULT '{}'::jsonb;
UPDATE integrarp.processo_transicao SET processo_transicao_id = id WHERE processo_transicao_id IS NULL AND id IS NOT NULL;

ALTER TABLE IF EXISTS integrarp.processo_instancia
  ADD COLUMN IF NOT EXISTS processo_instancia_id uuid,
  ADD COLUMN IF NOT EXISTS processo_definicao_id uuid,
  ADD COLUMN IF NOT EXISTS processo_versao_id uuid,
  ADD COLUMN IF NOT EXISTS iniciado_em timestamptz,
  ADD COLUMN IF NOT EXISTS concluido_em timestamptz,
  ADD COLUMN IF NOT EXISTS prazo_em timestamptz;
UPDATE integrarp.processo_instancia SET processo_instancia_id = id WHERE processo_instancia_id IS NULL AND id IS NOT NULL;

ALTER TABLE IF EXISTS integrarp.processo_variavel
  ADD COLUMN IF NOT EXISTS processo_variavel_id uuid,
  ADD COLUMN IF NOT EXISTS processo_instancia_id uuid,
  ADD COLUMN IF NOT EXISTS valor_json jsonb NOT NULL DEFAULT '{}'::jsonb;
UPDATE integrarp.processo_variavel SET processo_variavel_id = id WHERE processo_variavel_id IS NULL AND id IS NOT NULL;

DO $v143_process_contract$
DECLARE
  incompatíveis bigint;
BEGIN
  SELECT count(*) INTO incompatíveis FROM integrarp.processo_versao
   WHERE processo_definicao_id IS NULL;
  IF incompatíveis > 0 THEN
    RAISE EXCEPTION 'integrarp.processo_versao.processo_definicao_id: % registros incompatíveis; associe cada versão a uma definição antes do upgrade v1.43', incompatíveis;
  END IF;
END
$v143_process_contract$;

CREATE UNIQUE INDEX IF NOT EXISTS ux_processo_definicao_id
  ON integrarp.processo_definicao (processo_definicao_id);
CREATE INDEX IF NOT EXISTS ix_processo_versao_tenant_definicao
  ON integrarp.processo_versao (tenant_id, processo_definicao_id);
CREATE INDEX IF NOT EXISTS ix_processo_elemento_tenant_versao
  ON integrarp.processo_elemento (tenant_id, processo_versao_id);
CREATE INDEX IF NOT EXISTS ix_processo_transicao_tenant_versao
  ON integrarp.processo_transicao (tenant_id, processo_versao_id);
CREATE INDEX IF NOT EXISTS ix_processo_instancia_tenant_status_v143
  ON integrarp.processo_instancia (tenant_id, status);
CREATE UNIQUE INDEX IF NOT EXISTS ux_processo_variavel_tenant_instancia_nome
  ON integrarp.processo_variavel (tenant_id, processo_instancia_id, nome);

INSERT INTO integrarp.schema_contract (
  contract_name, product_version, postgresql_major, schema_name,
  migration_count, manifest_generated_at_utc
) VALUES (
  'Banco Canônico Integrarp v1.43', 'v1.43', 16, 'integrarp', 47,
  '2026-07-29T00:00:00Z'::timestamptz
)
ON CONFLICT (contract_name) DO UPDATE SET
  product_version = EXCLUDED.product_version,
  postgresql_major = EXCLUDED.postgresql_major,
  schema_name = EXCLUDED.schema_name,
  migration_count = EXCLUDED.migration_count,
  manifest_generated_at_utc = EXCLUDED.manifest_generated_at_utc;
