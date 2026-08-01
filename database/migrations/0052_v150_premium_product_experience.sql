-- IntegraRP v1.50 — correção aditiva do contrato de leitura do Flow.
-- O nome canônico pertence à definição; a view não depende do título da instância.
CREATE OR REPLACE VIEW integrarp.vw_flow_processos_em_andamento AS
SELECT
    i.tenant_id,
    i.processo_instancia_id,
    i.codigo,
    d.nome AS titulo,
    i.status,
    i.prazo_em
FROM integrarp.processo_instancia AS i
JOIN integrarp.processo_definicao AS d
  ON d.tenant_id = i.tenant_id
 AND d.processo_definicao_id = i.processo_definicao_id
 AND d.excluido_em IS NULL
WHERE i.excluido_em IS NULL
  AND i.status IN ('em_andamento', 'aguardando_tarefa');

COMMENT ON VIEW integrarp.vw_flow_processos_em_andamento IS
  'Processos ativos com título obtido da definição canônica.';
