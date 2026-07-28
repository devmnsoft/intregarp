-- IntegraRP v1.39 - execução rastreável e multi-tenant dos handlers de outbox.
-- PostgreSQL 16; evolução aditiva. Migrations 0001 a 0044 permanecem congeladas.
ALTER TABLE integrarp.outbox_execucao_handler
    ADD COLUMN IF NOT EXISTS status varchar(24) NOT NULL DEFAULT 'processado',
    ADD COLUMN IF NOT EXISTS tentativa integer NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS iniciado_em timestamptz NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS concluido_em timestamptz,
    ADD COLUMN IF NOT EXISTS erro_resumido varchar(500),
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;

UPDATE integrarp.outbox_execucao_handler
   SET concluido_em = COALESCE(concluido_em, executado_em)
 WHERE status = 'processado' AND concluido_em IS NULL;

DO $migration$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_outbox_execucao_handler_status') THEN
        ALTER TABLE integrarp.outbox_execucao_handler
            ADD CONSTRAINT ck_outbox_execucao_handler_status
            CHECK (status IN ('processando', 'processado', 'erro', 'dead_letter')) NOT VALID;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_outbox_execucao_handler_tentativa') THEN
        ALTER TABLE integrarp.outbox_execucao_handler
            ADD CONSTRAINT ck_outbox_execucao_handler_tentativa CHECK (tentativa > 0) NOT VALID;
    END IF;
END
$migration$;

ALTER TABLE integrarp.outbox_execucao_handler VALIDATE CONSTRAINT ck_outbox_execucao_handler_status;
ALTER TABLE integrarp.outbox_execucao_handler VALIDATE CONSTRAINT ck_outbox_execucao_handler_tentativa;

CREATE UNIQUE INDEX IF NOT EXISTS ux_outbox_evento_tenant_id
    ON integrarp.outbox_evento (tenant_id, id);

DO $migration$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_outbox_execucao_evento') THEN
        ALTER TABLE integrarp.outbox_execucao_handler DROP CONSTRAINT fk_outbox_execucao_evento;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_outbox_execucao_handler') THEN
        ALTER TABLE integrarp.outbox_execucao_handler DROP CONSTRAINT uq_outbox_execucao_handler;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_outbox_execucao_handler_tenant_evento_handler') THEN
        ALTER TABLE integrarp.outbox_execucao_handler
            ADD CONSTRAINT uq_outbox_execucao_handler_tenant_evento_handler UNIQUE (tenant_id, evento_id, handler);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_outbox_execucao_evento_tenant') THEN
        ALTER TABLE integrarp.outbox_execucao_handler
            ADD CONSTRAINT fk_outbox_execucao_evento_tenant
            FOREIGN KEY (tenant_id, evento_id) REFERENCES integrarp.outbox_evento(tenant_id, id) NOT VALID;
    END IF;
END
$migration$;
ALTER TABLE integrarp.outbox_execucao_handler VALIDATE CONSTRAINT fk_outbox_execucao_evento_tenant;
CREATE INDEX IF NOT EXISTS ix_outbox_execucao_retry
    ON integrarp.outbox_execucao_handler (tenant_id, status, iniciado_em)
    WHERE status IN ('processando', 'erro');
