param([string]$Database='integrarp',[string]$HostName='localhost',[string]$User='postgres',[string]$Port='5432')
$ErrorActionPreference='Stop'
function RunPsql([string]$Sql){ psql -h $HostName -p $Port -U $User -d $Database -v ON_ERROR_STOP=1 -c $Sql }
$critical=@('tenant','usuario','perfil','permissao','cliente','produto','estoque_movimento','pedido','pedido_item','processo_definicao','processo_instancia','tarefa','fatura','titulo_financeiro','outbox_evento','projeto_central_board','jornada_cliente','jornada_acao_recomendada','v15_customer_full_journey_check')
RunPsql "SELECT schema_name FROM information_schema.schemata WHERE schema_name='integrarp';"
foreach($t in $critical){ RunPsql "SELECT to_regclass('integrarp.$t') AS object_name;" }
RunPsql "SELECT COUNT(*) FROM pg_trigger WHERE tgname LIKE 'trg_%_atualizado_em';"
RunPsql "SELECT COUNT(*) FROM pg_constraint c JOIN pg_namespace n ON n.oid=c.connamespace WHERE n.nspname='integrarp';"
RunPsql "SELECT integrarp.fn_v16_release_candidate_status('00000000-0000-0000-0000-000000000001');"
RunPsql "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema IN ('public','integra');"
