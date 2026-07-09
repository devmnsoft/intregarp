using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/demo")]
public sealed class DemoController(IConfiguration configuration, ILogger<DemoController> logger) : ControllerBase
{
    [HttpGet("status")]
    public async Task<IActionResult> Status(CancellationToken cancellationToken)
    {
        try { return Ok(await BuildStatusAsync(cancellationToken)); }
        catch (Exception ex) { logger.LogError(ex, "Falha ao montar status demo v1.9"); return Problem(ex.Message, statusCode: 503, title: "Demo real indisponível"); }
    }

    [HttpPost("reset")]
    public IActionResult Reset() => Problem("Reset físico deve ser feito reaplicando database/scriptcompleto.sql em banco limpo para evitar OK falso.", statusCode: 409);

    [HttpPost("run-step/{stepCode}")]
    public async Task<IActionResult> RunStep(string stepCode, CancellationToken cancellationToken)
    {
        var status = await BuildStatusAsync(cancellationToken);
        var step = ((IEnumerable<Dictionary<string, object?>>)status["steps"]!).FirstOrDefault(s => string.Equals(Convert.ToString(s["stepCode"]), stepCode, StringComparison.OrdinalIgnoreCase));
        return step is null ? NotFound(new { status = "erro", etapa = stepCode, erro = "Etapa inexistente." }) : Ok(step);
    }

    [HttpPost("run-all")]
    public async Task<IActionResult> RunAll(CancellationToken cancellationToken)
    {
        try
        {
            var status = await BuildStatusAsync(cancellationToken);
            var failed = ((IEnumerable<Dictionary<string, object?>>)status["steps"]!).FirstOrDefault(s => !string.Equals(Convert.ToString(s["status"]), "ok", StringComparison.OrdinalIgnoreCase));
            return Ok(new { status = failed is null ? "ok" : "erro", etapa = failed?["stepCode"] ?? "concluido", erro = failed?["mensagem"], statusGeral = status });
        }
        catch (Exception ex) { logger.LogError(ex, "Falha ao executar run-all demo v1.9"); return Problem(ex.Message, statusCode: 503, title: "Run-all real falhou"); }
    }

    private async Task<Dictionary<string, object?>> BuildStatusAsync(CancellationToken cancellationToken)
    {
        var checks = await V19Db.QueryAsync(configuration, "SELECT check_codigo, check_titulo, status, detalhe, proxima_acao FROM integrarp.vw_v19_demo_funcional_status ORDER BY check_codigo;", cancellationToken);
        var next = await V19Db.QueryAsync(configuration, "SELECT * FROM integrarp.vw_v19_o_que_fazer_agora LIMIT 1;", cancellationToken);
        var steps = checks.Select(c => new Dictionary<string, object?>
        {
            ["stepCode"] = c["check_codigo"], ["titulo"] = c["check_titulo"], ["status"] = c["status"], ["dadosEncontrados"] = c["detalhe"], ["mensagem"] = c["proxima_acao"], ["rotaWeb"] = RouteFor(Convert.ToString(c["check_codigo"]) ?? "")
        }).ToList();
        return new Dictionary<string, object?> { ["status"] = steps.Any(s => Convert.ToString(s["status"]) == "erro") ? "erro" : "ok", ["steps"] = steps, ["proximaAcao"] = next.FirstOrDefault() };
    }

    private static string RouteFor(string code) => code switch
    {
        "clientes" => "/customers", "produtos" => "/products", "estoque" => "/inventory", "pedidos" => "/orders", "tarefas" => "/tasks/my", "faturas" => "/billing/invoices", "titulos" => "/billing/titles", "outbox" => "/connect/outbox", "jornada" => "/journey/what-to-do-now", "atividades" => "/activities", "templates" => "/templates", _ => "/dashboard"
    };
}
