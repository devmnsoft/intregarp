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
ALTER TABLE IF EXISTS integrarp.workflow_task ADD COLUMN IF NOT EXISTS tarefa_operacional_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.workflow_task ADD COLUMN IF NOT EXISTS idempotency_key text NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_workflow_task_idempotency ON integrarp.workflow_task (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
