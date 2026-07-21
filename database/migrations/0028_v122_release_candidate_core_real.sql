BEGIN;

-- v1.22 release candidate hardening marker.
-- This migration is intentionally additive and idempotent. It records the
-- release-candidate database contract without changing existing data because
-- the runtime schema objects required by authentication, tasks, Flow, outbox
-- and audit already exist in the consolidated script at the v1.21 base.
CREATE TABLE IF NOT EXISTS integrarp.release_candidate_evidencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    versao text NOT NULL,
    base_sha text NOT NULL,
    status text NOT NULL,
    observacao text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    row_version bigint NOT NULL DEFAULT 1,
    CONSTRAINT ck_release_candidate_evidencia_status CHECK (status IN ('parcial','bloqueado','homologacao','aprovado')),
    CONSTRAINT uq_release_candidate_evidencia_versao UNIQUE (versao)
);

INSERT INTO integrarp.release_candidate_evidencia (versao, base_sha, status, observacao)
VALUES ('v1.22', '1bddde90549e062fd4514fe61eb89b93ab690122', 'parcial', 'Registro idempotente da preparação do release candidate v1.22; evidências detalhadas em docs/v1.22-*.md.')
ON CONFLICT (versao) DO UPDATE SET
    base_sha = EXCLUDED.base_sha,
    status = EXCLUDED.status,
    observacao = EXCLUDED.observacao,
    atualizado_em = now(),
    row_version = integrarp.release_candidate_evidencia.row_version + 1;

CREATE INDEX IF NOT EXISTS ix_release_candidate_evidencia_status
    ON integrarp.release_candidate_evidencia (status, criado_em DESC);

COMMIT;
