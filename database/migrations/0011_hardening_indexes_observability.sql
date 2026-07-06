CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE TABLE IF NOT EXISTS integrarp.lgpd_log_acesso_dado (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NULL,
    recurso text NOT NULL,
    campo text NOT NULL,
    motivo text NOT NULL,
    correlation_id text NOT NULL,
    acessado_em timestamptz NOT NULL DEFAULT now()
);

DO $$
BEGIN
    IF to_regclass('integrarp.lgpd_log_acesso_dado') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'lgpd_log_acesso_dado' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'lgpd_log_acesso_dado' AND column_name = 'acessado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_lgpd_log_acesso_dado_tenant_acessado ON integrarp.lgpd_log_acesso_dado (tenant_id, acessado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.processo_auditoria_evento') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'processo_auditoria_evento' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'processo_auditoria_evento' AND column_name = 'criado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_auditoria_tenant_criado ON integrarp.processo_auditoria_evento (tenant_id, criado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.ai_auditoria') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'ai_auditoria' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'ai_auditoria' AND column_name = 'criado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_ai_auditoria_tenant_criado ON integrarp.ai_auditoria (tenant_id, criado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.tarefa') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'status') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'responsavel_usuario_id') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_tarefa_tenant_status_responsavel ON integrarp.tarefa (tenant_id, status, responsavel_usuario_id)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.tarefa') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'prazo_em') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'prioridade') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_tarefa_tenant_prazo_prioridade ON integrarp.tarefa (tenant_id, prazo_em, prioridade)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.processo_instancia') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'processo_instancia' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'processo_instancia' AND column_name = 'status') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'processo_instancia' AND column_name = 'atualizado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_processo_instancia_tenant_status_atualizado ON integrarp.processo_instancia (tenant_id, status, atualizado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.modulo_registro') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'modulo_registro' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'modulo_registro' AND column_name = 'modulo_dinamico_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'modulo_registro' AND column_name = 'atualizado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_modulo_registro_tenant_modulo_atualizado ON integrarp.modulo_registro (tenant_id, modulo_dinamico_id, atualizado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.pedido') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'pedido' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'pedido' AND column_name = 'status') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'pedido' AND column_name = 'cliente_id') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_pedido_tenant_status_cliente ON integrarp.pedido (tenant_id, status, cliente_id)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.estoque_lote') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'estoque_lote' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'estoque_lote' AND column_name = 'produto_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'estoque_lote' AND column_name = 'criado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_estoque_lote_tenant_produto_criado ON integrarp.estoque_lote (tenant_id, produto_id, criado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.outbox_evento') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'outbox_evento' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'outbox_evento' AND column_name = 'status') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'outbox_evento' AND column_name = 'criado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_outbox_evento_tenant_status_criado ON integrarp.outbox_evento (tenant_id, status, criado_em)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.projeto_central_item') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'projeto_central_item' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'projeto_central_item' AND column_name = 'board_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'projeto_central_item' AND column_name = 'status') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_projeto_central_item_tenant_board_status ON integrarp.projeto_central_item (tenant_id, board_id, status)';
    END IF;
END $$;
