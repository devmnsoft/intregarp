using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/validation")]
public sealed class V19ValidationController(IConfiguration configuration, ILogger<V19ValidationController> logger) : ControllerBase
{
    [HttpGet("e2e/customer-to-billing")]
    public async Task<IActionResult> CustomerToBilling(CancellationToken cancellationToken)
    {
        var sw = Stopwatch.StartNew();
        try
        {
            var checks = await V19Db.QueryAsync(configuration, "SELECT check_codigo AS etapa, status, detalhe, proxima_acao AS proximaAcao FROM integrarp.vw_v19_demo_funcional_status ORDER BY check_codigo;", cancellationToken);
            var failed = checks.FirstOrDefault(c => string.Equals(Convert.ToString(c["status"]), "erro", StringComparison.OrdinalIgnoreCase));
            var next = await V19Db.QueryAsync(configuration, "SELECT * FROM integrarp.vw_v19_o_que_fazer_agora LIMIT 1;", cancellationToken);
            return Ok(new { statusGeral = failed is null ? "ok" : "erro", etapa = failed?["etapa"] ?? "customer-to-billing", statusEtapa = failed?["status"] ?? "ok", erro = failed?["detalhe"], warning = (string?)null, proximaAcao = next.FirstOrDefault(), idsEnvolvidos = new { tenant = "demo" }, tempoExecucaoMs = sw.ElapsedMilliseconds, checks });
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "E2E customer-to-billing falhou com erro real");
            return Problem(ex.Message, statusCode: 503, title: "Validação E2E indisponível");
        }
    }

    [HttpGet("worker/status")]
    public async Task<IActionResult> WorkerStatus(CancellationToken cancellationToken)
    {
        try { return Ok((await V19Db.QueryAsync(configuration, "SELECT count(*) FILTER (WHERE status='pendente') AS pendentes, count(*) FILTER (WHERE status='processado') AS processados, count(*) FILTER (WHERE status='erro') AS erros FROM integrarp.outbox_evento;", cancellationToken)).First()); }
        catch (Exception ex) { return Problem(ex.Message, statusCode: 503); }
    }
}
