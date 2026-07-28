-- IntegraRP v1.38 - validação de integridade e rastreabilidade do despacho real.
-- PostgreSQL 16; migrations 0001 a 0043 permanecem congeladas.
DO $migration$
BEGIN
    IF EXISTS (SELECT 1 FROM integrarp.notificacao_usuario WHERE url IS NOT NULL AND (url NOT LIKE '/%' OR url LIKE '//%')) THEN
        RAISE EXCEPTION 'Existem deep links externos ou inválidos; corrija-os antes de validar a constraint.';
    END IF;
    IF EXISTS (SELECT 1 FROM integrarp.outbox_evento WHERE tentativas < 0) THEN
        RAISE EXCEPTION 'Existem tentativas negativas na outbox; corrija-as antes de validar a constraint.';
    END IF;
END
$migration$;
ALTER TABLE integrarp.notificacao_usuario VALIDATE CONSTRAINT ck_notificacao_usuario_deep_link_interno;
ALTER TABLE integrarp.outbox_evento VALIDATE CONSTRAINT ck_outbox_evento_tentativas_nao_negativas;
CREATE TABLE IF NOT EXISTS integrarp.outbox_execucao_handler (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, evento_id uuid NOT NULL,
    handler varchar(120) NOT NULL, correlation_id varchar(120) NOT NULL, executado_em timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_outbox_execucao_handler UNIQUE (tenant_id, evento_id),
    CONSTRAINT fk_outbox_execucao_evento FOREIGN KEY (evento_id) REFERENCES integrarp.outbox_evento(id)
);
CREATE INDEX IF NOT EXISTS ix_outbox_execucao_handler_tenant_data ON integrarp.outbox_execucao_handler(tenant_id, executado_em DESC);
