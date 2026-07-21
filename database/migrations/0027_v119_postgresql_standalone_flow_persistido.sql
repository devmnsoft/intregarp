-- IntegraRP v1.19 - PostgreSQL standalone e compatibilidade Flow/Auth
-- Migration aditiva e idempotente; transação controlada pelo Migration Runner.

ALTER TABLE IF EXISTS integrarp.auth_password_reset ADD COLUMN IF NOT EXISTS consumed_at timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.auth_password_reset ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.auth_password_reset ADD COLUMN IF NOT EXISTS excluido_em timestamptz NULL;

DO $$
BEGIN
  IF EXISTS (
      SELECT 1 FROM information_schema.columns
       WHERE table_schema = 'integrarp'
         AND table_name = 'auth_password_reset'
         AND column_name = 'used_at'
  ) THEN
    EXECUTE 'UPDATE integrarp.auth_password_reset SET consumed_at = used_at WHERE consumed_at IS NULL AND used_at IS NOT NULL';
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_auth_password_reset_active
    ON integrarp.auth_password_reset (tenant_id, usuario_id, expires_at)
    WHERE consumed_at IS NULL AND excluido_em IS NULL;

DROP TRIGGER IF EXISTS trg_auth_password_reset_atualizado_em ON integrarp.auth_password_reset;
CREATE TRIGGER trg_auth_password_reset_atualizado_em
BEFORE UPDATE ON integrarp.auth_password_reset
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

ALTER TABLE IF EXISTS integrarp.processo_instancia ADD COLUMN IF NOT EXISTS tarefa_operacional_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS processo_definicao_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS processo_versao_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS processo_instancia_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS processo_elemento_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS origem_tipo text NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS origem_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS idempotency_key text NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;
CREATE UNIQUE INDEX IF NOT EXISTS ux_tarefa_operacional_idempotency ON integrarp.tarefa_operacional (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_processo_instancia ON integrarp.tarefa_operacional (tenant_id, processo_instancia_id) WHERE processo_instancia_id IS NOT NULL;
