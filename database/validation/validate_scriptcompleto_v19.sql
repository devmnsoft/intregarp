\set ON_ERROR_STOP on
SELECT * FROM integrarp.vw_v19_demo_funcional_status;
SELECT * FROM integrarp.vw_v19_o_que_fazer_agora;
DO $$
DECLARE
    erros int;
BEGIN
    SELECT count(*) INTO erros
      FROM integrarp.vw_v19_demo_funcional_status
     WHERE lower(status) IN ('erro','error');
    IF erros > 0 THEN
        RAISE EXCEPTION 'Validação v1.9 falhou: % checks em erro em integrarp.vw_v19_demo_funcional_status', erros;
    END IF;
END $$;
