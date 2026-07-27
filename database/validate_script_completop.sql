-- Produto: IntegraRP
-- Versao: v1.31
-- PostgreSQL: 16
-- Schema: integrarp
-- Validador executavel do contrato comercial v1.31.
\set ON_ERROR_STOP on

DO $validation$
DECLARE
    missing text;
    invalid_constraints text;
BEGIN
    IF current_setting('server_version_num')::integer < 160000 THEN
        RAISE EXCEPTION 'PostgreSQL 16 ou superior requerido; encontrado %', current_setting('server_version');
    END IF;

    SELECT string_agg(required.object_name, ', ' ORDER BY required.object_name)
      INTO missing
      FROM (VALUES
        ('cliente'), ('produto_categoria'), ('produto'), ('pedido'), ('pedido_item'),
        ('estoque_saldo'), ('estoque_movimento'), ('estoque_reserva'),
        ('tarefa_operacional'), ('auditoria_evento'), ('outbox_evento'),
        ('worker_tenant_job_lock'), ('worker_dead_letter'), ('processo_instancia')
      ) AS required(object_name)
     WHERE to_regclass('integrarp.' || required.object_name) IS NULL;
    IF missing IS NOT NULL THEN
        RAISE EXCEPTION 'Objetos obrigatorios ausentes em integrarp: %', missing;
    END IF;

    SELECT string_agg(required.table_name || '.' || required.column_name, ', ' ORDER BY 1)
      INTO missing
      FROM (VALUES
        ('cliente','tenant_id','uuid'), ('cliente','row_version','bigint'), ('cliente','correlation_id','text'),
        ('produto','categoria_id','uuid'), ('produto','preco','numeric'), ('produto','row_version','bigint'),
        ('pedido','cliente_id','uuid'), ('pedido','idempotency_key','text'), ('pedido','row_version','bigint'),
        ('estoque_reserva','local_codigo','text'),
        ('tarefa_operacional','prioridade','text'), ('tarefa_operacional','checklist_definicao_json','jsonb'),
        ('tarefa_operacional','checklist_resposta_json','jsonb'), ('tarefa_operacional','row_version','bigint'),
        ('outbox_evento','idempotency_key','text'), ('outbox_evento','proxima_tentativa_em','timestamp with time zone')
      ) AS required(table_name,column_name,data_type)
     WHERE NOT EXISTS (
       SELECT 1 FROM information_schema.columns c
        WHERE c.table_schema='integrarp' AND c.table_name=required.table_name
          AND c.column_name=required.column_name AND c.data_type=required.data_type
     );
    IF missing IS NOT NULL THEN
        RAISE EXCEPTION 'Colunas/tipos obrigatorios ausentes: %', missing;
    END IF;

    SELECT string_agg(n.nspname || '.' || c.relname || ':' || con.conname, ', ' ORDER BY 1)
      INTO invalid_constraints
      FROM pg_constraint con
      JOIN pg_class c ON c.oid=con.conrelid
      JOIN pg_namespace n ON n.oid=c.relnamespace
     WHERE n.nspname='integrarp' AND NOT con.convalidated;
    IF invalid_constraints IS NOT NULL THEN
        RAISE EXCEPTION 'Constraints nao validadas: %', invalid_constraints;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
               WHERE n.nspname IN ('public','integra') AND c.relkind IN ('r','p','v','m','S')
                 AND c.relname NOT LIKE 'pg_%') THEN
        RAISE EXCEPTION 'Objetos de aplicacao encontrados fora do schema integrarp';
    END IF;
END
$validation$;

-- Smoke queries reais: qualquer divergencia de contrato encerra a validacao.
SELECT count(*) AS clientes FROM integrarp.cliente WHERE tenant_id IS NOT NULL AND excluido_em IS NULL;
SELECT produto_id, local_codigo, saldo_fisico, saldo_reservado
  FROM integrarp.estoque_saldo WHERE tenant_id IS NOT NULL ORDER BY produto_id, local_codigo LIMIT 1;
SELECT id, numero, status, total FROM integrarp.pedido WHERE tenant_id IS NOT NULL ORDER BY criado_em DESC LIMIT 1;
SELECT id, status, prioridade FROM integrarp.tarefa_operacional WHERE tenant_id IS NOT NULL ORDER BY criado_em DESC LIMIT 1;
SELECT id, status, tentativas FROM integrarp.outbox_evento WHERE tenant_id IS NOT NULL ORDER BY criado_em DESC LIMIT 1;
