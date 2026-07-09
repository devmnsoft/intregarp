SELECT * FROM integrarp.vw_v19_demo_funcional_status;
SELECT * FROM integrarp.vw_v19_o_que_fazer_agora;
SELECT 'schema_guard' AS check_codigo, 'Sem objetos indevidos fora de integrarp' AS check_titulo,
CASE WHEN NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema IN ('public','integra')) THEN 'ok' ELSE 'erro' END AS status,
'validação objetiva' AS detalhe,
'remover objetos fora do schema integrarp' AS proxima_acao;
