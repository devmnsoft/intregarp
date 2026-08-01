-- IntegraRP v1.51 — contrato canônico de prazo dos processos ativos.
-- processo_instancia não possui prazo próprio: o prazo operacional é o menor
-- vencimento ainda aberto entre as tarefas pertencentes à instância.
CREATE OR REPLACE VIEW integrarp.vw_flow_processos_em_andamento AS
SELECT
    i.tenant_id,
    i.processo_instancia_id,
    i.codigo,
    d.nome AS titulo,
    i.status,
    deadlines.prazo_em
FROM integrarp.processo_instancia AS i
JOIN integrarp.processo_definicao AS d
  ON d.tenant_id = i.tenant_id
 AND d.processo_definicao_id = i.processo_definicao_id
 AND d.excluido_em IS NULL
LEFT JOIN LATERAL (
    SELECT min(t.vencimento_em) AS prazo_em
    FROM integrarp.tarefa AS t
    WHERE t.tenant_id = i.tenant_id
      AND t.processo_instancia_id = i.processo_instancia_id
      AND t.excluido_em IS NULL
      AND t.status IN ('pendente', 'atribuida', 'em_execucao', 'pausada')
) AS deadlines ON true
WHERE i.excluido_em IS NULL
  AND i.status IN ('em_andamento', 'aguardando_tarefa');

COMMENT ON VIEW integrarp.vw_flow_processos_em_andamento IS
  'Processos ativos; prazo derivado do menor vencimento das tarefas operacionais abertas.';
