
-- =============================================================
-- v1.6 Release Candidate: validação executável, CI, Docker/IIS e smoke tests
-- =============================================================
CREATE TABLE IF NOT EXISTS integrarp.v16_release_candidate_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    area varchar(80) NOT NULL,
    check_name varchar(160) NOT NULL,
    status varchar(20) NOT NULL DEFAULT 'warning',
    evidence text NULL,
    next_action text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS tenant_id uuid NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS area varchar(80) NOT NULL DEFAULT 'release-candidate';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS check_name varchar(160) NOT NULL DEFAULT 'unknown';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS status varchar(20) NOT NULL DEFAULT 'warning';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS evidence text NULL;
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS next_action text NOT NULL DEFAULT 'Executar validação v1.6';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS criado_em timestamptz NOT NULL DEFAULT now();
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NULL;
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v16_release_candidate_check') THEN
        ALTER TABLE integrarp.v16_release_candidate_check ADD CONSTRAINT uq_v16_release_candidate_check UNIQUE (tenant_id, area, check_name);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v16_release_candidate_status') THEN
        ALTER TABLE integrarp.v16_release_candidate_check ADD CONSTRAINT ck_v16_release_candidate_status CHECK (status IN ('ok','warning','error'));
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_v16_release_candidate_tenant_area_status ON integrarp.v16_release_candidate_check (tenant_id, area, status);
CREATE INDEX IF NOT EXISTS ix_v16_release_candidate_criado_em ON integrarp.v16_release_candidate_check (criado_em);

DROP TRIGGER IF EXISTS trg_v16_release_candidate_check_atualizado_em ON integrarp.v16_release_candidate_check;
CREATE TRIGGER trg_v16_release_candidate_check_atualizado_em BEFORE UPDATE ON integrarp.v16_release_candidate_check FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.v16_release_candidate_check (tenant_id, area, check_name, status, evidence, next_action) VALUES
('00000000-0000-0000-0000-000000000001','build','dotnet-clean-restore-build-test','warning','Ambiente local pode não ter SDK; CI executa restore/build/test.','Instalar .NET SDK local ou acompanhar GitHub Actions.'),
('00000000-0000-0000-0000-000000000001','database','scriptcompleto-idempotente','ok','Script contém schema integrarp, extensão pgcrypto, tabelas, índices, constraints, triggers, views e seeds v1.6.','Executar scripts/db-validate-scriptcompleto.ps1 contra PostgreSQL limpo.'),
('00000000-0000-0000-0000-000000000001','database','migrations-manifest','ok','Manifest v1.6 registra ordem e duplicidade histórica 0014.','Manter migrations imutáveis e criar corretivas posteriores.'),
('00000000-0000-0000-0000-000000000001','docker','compose-release-validation','warning','Script validate-docker-release.ps1 criado para validar API, Web, Worker e PostgreSQL.','Executar em estação com Docker disponível.'),
('00000000-0000-0000-0000-000000000001','worker','outbox-checkpoint','warning','Validação via endpoint e smoke script verifica worker/status e outbox.','Ligar Worker ao banco real e revisar logs.'),
('00000000-0000-0000-0000-000000000001','security','sem-secrets-reais','ok','Exemplos usam placeholders e documentação orienta variáveis de ambiente.','Configurar segredo forte fora do repositório.')
ON CONFLICT (tenant_id, area, check_name) DO UPDATE SET status = EXCLUDED.status, evidence = EXCLUDED.evidence, next_action = EXCLUDED.next_action;

CREATE OR REPLACE FUNCTION integrarp.fn_v16_release_candidate_status(p_tenant_id uuid)
RETURNS text
LANGUAGE sql
AS $$
    SELECT CASE
        WHEN count(*) = 0 THEN 'warning'
        WHEN count(*) FILTER (WHERE status = 'error') > 0 THEN 'error'
        WHEN count(*) FILTER (WHERE status = 'warning') > 0 THEN 'warning'
        ELSE 'ok'
    END
    FROM integrarp.v16_release_candidate_check
    WHERE tenant_id = p_tenant_id
$$;

CREATE OR REPLACE VIEW integrarp.vw_v16_release_candidate_status AS
SELECT tenant_id,
       integrarp.fn_v16_release_candidate_status(tenant_id) AS status,
       jsonb_agg(jsonb_build_object('area', area, 'check', check_name, 'status', status, 'evidence', evidence, 'next_action', next_action) ORDER BY area, check_name) AS checks,
       count(*) FILTER (WHERE status = 'ok') AS ok_count,
       count(*) FILTER (WHERE status = 'warning') AS warning_count,
       count(*) FILTER (WHERE status = 'error') AS error_count
FROM integrarp.v16_release_candidate_check
GROUP BY tenant_id;

INSERT INTO integrarp.schema_migrations (version, description)
VALUES ('0018_v16_release_candidate_validation', 'v1.6 release candidate executável, banco validado, CI real, Docker/IIS e smoke tests')
ON CONFLICT (version) DO NOTHING;
