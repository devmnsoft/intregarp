-- IntegraRP v1.55 — contrato canônico de processos e tarefas operacionais.
-- A instância histórica não possui título nem prazo próprios. O título pertence
-- à definição e o prazo efetivo é derivado da menor tarefa ainda aberta.
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

CREATE OR REPLACE VIEW integrarp.vw_flow_processos_atrasados AS
SELECT
    tenant_id,
    processo_instancia_id,
    codigo,
    titulo,
    status,
    prazo_em
FROM integrarp.vw_flow_processos_em_andamento
WHERE prazo_em IS NOT NULL
  AND prazo_em < now();

COMMENT ON VIEW integrarp.vw_flow_processos_em_andamento IS
  'Processos ativos com título da definição e prazo da menor tarefa operacional aberta.';
COMMENT ON VIEW integrarp.vw_flow_processos_atrasados IS
  'Processos ativos cujo prazo operacional canônico já venceu.';
