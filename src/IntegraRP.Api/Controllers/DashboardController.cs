using IntegraRP.Application.Abstractions.Services;using IntegraRP.Application.Common;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[ApiController][Route("api/dashboard")]public partial class DashboardController(ILogger<DashboardController> logger, IIntegraRpQueries queries, IConfiguration configuration):ControllerBase{
IActionResult FromResult<T>(Result<T> r)=>r.IsSuccess?Ok(r.Value):Problem(r.Error,statusCode:400);
[HttpGet]public async Task<IActionResult> V19(CancellationToken ct){try{return Ok((await V19Db.QueryAsync(configuration,@"
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
SELECT
(SELECT count(*) FROM integrarp.cliente c JOIN t ON t.tenant_id=c.tenant_id WHERE c.excluido_em IS NULL AND c.status='ativo') AS clientesAtivos,
(SELECT count(*) FROM integrarp.produto p JOIN t ON t.tenant_id=p.tenant_id WHERE p.excluido_em IS NULL AND p.status='ativo') AS produtosAtivos,
(SELECT count(*) FROM integrarp.produto p JOIN t ON t.tenant_id=p.tenant_id WHERE p.excluido_em IS NULL AND p.estoque_atual < p.estoque_minimo) AS estoqueCritico,
(SELECT count(*) FROM integrarp.pedido p JOIN t ON t.tenant_id=p.tenant_id WHERE p.excluido_em IS NULL AND p.status IN ('rascunho','aguardando_separacao','faturavel')) AS pedidosEmAberto,
(SELECT count(*) FROM integrarp.pedido p JOIN t ON t.tenant_id=p.tenant_id WHERE p.excluido_em IS NULL AND p.status='confirmado') AS pedidosConfirmados,
(SELECT count(*) FROM integrarp.tarefa_operacional x JOIN t ON t.tenant_id=x.tenant_id WHERE x.excluido_em IS NULL AND x.status='pendente') AS tarefasPendentes,
(SELECT count(*) FROM integrarp.tarefa_operacional x JOIN t ON t.tenant_id=x.tenant_id WHERE x.excluido_em IS NULL AND x.status='pendente' AND x.vencimento_em < now()) AS tarefasAtrasadas,
(SELECT count(*) FROM integrarp.fatura f JOIN t ON t.tenant_id=f.tenant_id WHERE f.excluido_em IS NULL) AS faturasEmitidas,
(SELECT count(*) FROM integrarp.titulo_financeiro x JOIN t ON t.tenant_id=x.tenant_id WHERE x.excluido_em IS NULL AND x.status='aberto') AS titulosEmAberto,
(SELECT count(*) FROM integrarp.titulo_financeiro x JOIN t ON t.tenant_id=x.tenant_id WHERE x.excluido_em IS NULL AND x.vencimento < CURRENT_DATE) AS titulosVencidos,
(SELECT count(*) FROM integrarp.outbox_evento o JOIN t ON t.tenant_id=o.tenant_id WHERE o.excluido_em IS NULL AND o.status='pendente') AS outboxPendente,
(SELECT count(*) FROM integrarp.outbox_evento o JOIN t ON t.tenant_id=o.tenant_id WHERE o.excluido_em IS NULL AND o.status='erro') AS outboxComErro,
(SELECT max(percentual) FROM integrarp.jornada_progresso_usuario j JOIN t ON t.tenant_id=j.tenant_id WHERE j.excluido_em IS NULL) AS jornadaProgresso,
(SELECT proxima_acao FROM integrarp.vw_v19_o_que_fazer_agora LIMIT 1) AS proximaAcao;",ct)).First());}catch(Exception ex){logger.LogError(ex,"Falha dashboard real v1.9");return Problem(ex.Message,statusCode:503,title:"Dashboard real indisponível");}}
[HttpGet("resumo")]public async Task<IActionResult> Resumo(CancellationToken ct){try{logger.LogInformation("Executando DashboardController");return FromResult(await queries.DashboardAsync(ct));}catch(Exception ex){logger.LogError(ex,"Erro em DashboardController");throw;}}
}
