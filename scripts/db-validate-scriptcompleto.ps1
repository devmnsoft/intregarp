param([string]$Database="integrarp",[string]$HostName="localhost",[string]$User="postgres",[string]$ScriptPath="database/scriptcompleto.sql")
$ErrorActionPreference="Stop"
function Invoke-Psql([string]$Sql){ psql -h $HostName -U $User -d $Database -v ON_ERROR_STOP=1 -c $Sql }
if (!(Test-Path $ScriptPath)) { throw "scriptcompleto.sql não encontrado: $ScriptPath" }
psql -h $HostName -U $User -d postgres -v ON_ERROR_STOP=1 -c "SELECT 'CREATE DATABASE $Database' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$Database')\gexec"
psql -h $HostName -U $User -d $Database -v ON_ERROR_STOP=1 -f $ScriptPath
psql -h $HostName -U $User -d $Database -v ON_ERROR_STOP=1 -f $ScriptPath
$critical=@('tenant','usuario','perfil','permissao','cliente','produto','estoque_movimento','pedido','pedido_item','processo_definicao','processo_instancia','tarefa','fatura','titulo_financeiro','outbox_evento','projeto_central_board','jornada_cliente','jornada_acao_recomendada','v15_customer_full_journey_check','v16_release_candidate_check')
foreach($t in $critical){ Invoke-Psql "DO `$`$ BEGIN IF to_regclass('integrarp.$t') IS NULL THEN RAISE EXCEPTION 'missing integrarp.$t'; END IF; END `$`$;" }
Invoke-Psql "SELECT COUNT(*) FROM integrarp.vw_v16_release_candidate_status;"
Write-Host "scriptcompleto aplicado duas vezes e validado."
