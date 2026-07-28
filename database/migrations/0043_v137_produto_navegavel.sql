-- IntegraRP v1.37 - suporte aditivo à jornada navegável e processamento confiável.
-- PostgreSQL 16; migrations 0001 a 0042 permanecem congeladas.

CREATE INDEX IF NOT EXISTS ix_outbox_evento_dispatch
    ON integrarp.outbox_evento (tenant_id, status, proxima_tentativa_em, criado_em)
    WHERE status IN ('pendente', 'erro');
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_fila
    ON integrarp.tarefa_operacional (tenant_id, setor_id, status, vencimento_em)
    WHERE responsavel_usuario_id IS NULL AND status = 'aberta';

DO $migration$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_notificacao_usuario_deep_link_interno') THEN
        ALTER TABLE integrarp.notificacao_usuario ADD CONSTRAINT ck_notificacao_usuario_deep_link_interno
            CHECK (url IS NULL OR (url LIKE '/%' AND url NOT LIKE '//%')) NOT VALID;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_outbox_evento_tentativas_nao_negativas') THEN
        ALTER TABLE integrarp.outbox_evento ADD CONSTRAINT ck_outbox_evento_tentativas_nao_negativas
            CHECK (tentativas >= 0) NOT VALID;
    END IF;
END
$migration$;
