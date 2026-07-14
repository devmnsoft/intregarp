
-- =============================================================
-- v1.6 Release Candidate - validação real, CI, Docker, smoke tests
-- =============================================================
CREATE TABLE IF NOT EXISTS integrarp.v16_release_candidate_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    area varchar(80) NOT NULL,
    check_name varchar(140) NOT NULL,
    status varchar(20) NOT NULL DEFAULT 'warning',
    evidence text NULL,
    next_action text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS tenant_id uuid NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS area varchar(80) NOT NULL DEFAULT 'release-candidate';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS check_name varchar(140) NOT NULL DEFAULT 'pending';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS status varchar(20) NOT NULL DEFAULT 'warning';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS evidence text NULL;
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS next_action text NULL;
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS criado_em timestamptz NOT NULL DEFAULT now();
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v16_release_candidate_check_area_name') THEN
        ALTER TABLE integrarp.v16_release_candidate_check ADD CONSTRAINT uq_v16_release_candidate_check_area_name UNIQUE (tenant_id, area, check_name);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v16_release_candidate_check_status') THEN
        ALTER TABLE integrarp.v16_release_candidate_check ADD CONSTRAINT ck_v16_release_candidate_check_status CHECK (status IN ('ok','warning','error'));
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_v16_release_candidate_check_tenant_area ON integrarp.v16_release_candidate_check (tenant_id, area, status);
CREATE INDEX IF NOT EXISTS ix_v16_release_candidate_check_updated ON integrarp.v16_release_candidate_check (atualizado_em DESC);

DROP TRIGGER IF EXISTS trg_v16_release_candidate_check_atualizado_em ON integrarp.v16_release_candidate_check;
CREATE TRIGGER trg_v16_release_candidate_check_atualizado_em BEFORE UPDATE ON integrarp.v16_release_candidate_check FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.v16_release_candidate_check (tenant_id, area, check_name, status, evidence, next_action) VALUES
('00000000-0000-0000-0000-000000000001','build','dotnet-sdk-codex','warning','SDK .NET ausente no ambiente Codex; CI executa restore/build/test em ubuntu-latest e windows-latest.','Acompanhar GitHub Actions antes de promover RC.'),
('00000000-0000-0000-0000-000000000001','mobile','typecheck-codex','ok','npm install e npm run typecheck executados com sucesso no Codex.','Manter typecheck no CI.'),
('00000000-0000-0000-0000-000000000001','database','scriptcompleto-idempotente','warning','Workflow database-validation aplica scriptcompleto.sql duas vezes em PostgreSQL limpo.','Validar execução do workflow.'),
('00000000-0000-0000-0000-000000000001','docker','docker-codex','warning','Docker ausente no ambiente Codex; script validate-docker-release.ps1 criado para Windows/local.','Executar em host com Docker.'),
('00000000-0000-0000-0000-000000000001','smoke','customer-full-journey','warning','Smoke script cobre health, Swagger e validação da jornada do cliente.','Executar com API e banco reais.')
ON CONFLICT (tenant_id, area, check_name) DO UPDATE SET status = EXCLUDED.status, evidence = EXCLUDED.evidence, next_action = EXCLUDED.next_action;

CREATE OR REPLACE VIEW integrarp.vw_v16_release_candidate_status AS
SELECT tenant_id,
       CASE
           WHEN count(*) FILTER (WHERE status = 'error') > 0 THEN 'error'
           WHEN count(*) FILTER (WHERE status = 'warning') > 0 THEN 'warning'
           ELSE 'ok'
       END AS status,
       jsonb_agg(jsonb_build_object('area', area, 'check', check_name, 'status', status, 'evidence', evidence, 'next_action', next_action) ORDER BY area, check_name) AS checks,
       'Executar CI, database-validation, release-candidate e smoke tests em ambiente com .NET, PostgreSQL e Docker.'::text AS next_action
FROM integrarp.v16_release_candidate_check
GROUP BY tenant_id;

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.
VALUES ('0018_v16_release_candidate_validation', 'v1.6 release candidate: validação de build, banco, CI, Docker e smoke tests')
ON CONFLICT (version) DO NOTHING;
