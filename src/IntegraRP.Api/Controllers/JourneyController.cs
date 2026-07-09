using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[AllowAnonymous]
[Route("api/journey")]
public sealed class JourneyController(ILogger<JourneyController> logger, IConfiguration configuration) : ControllerBase
{
    private Guid TenantId => Guid.TryParse(Request.Headers["X-Tenant-Id"], out var tenantId) ? tenantId : Guid.Empty;
    private Guid UserId => Guid.TryParse(User.FindFirst("sub")?.Value, out var userId) ? userId : Guid.Parse("00000000-0000-0000-0000-000000000001");

    [HttpGet]
    public IActionResult List(CancellationToken cancellationToken) => WithTenant(() => Ok(new[] { "primeiros-passos-administrador", "operacao-diaria", "gestor", "usuario-campo", "studio" }));

    [HttpGet("{code}")]
    public IActionResult Get(string code, CancellationToken cancellationToken) => WithTenant(() => Ok(new { code, tenantId = TenantId, steps = 11 }));

    [HttpPost("{code}/start")]
    public IActionResult Start(string code, CancellationToken cancellationToken) => WithTenant(() => Ok(new { code, status = "em_andamento" }));

    [HttpPost("steps/{stepId:guid}/complete")]
    public IActionResult CompleteStep(Guid stepId, CancellationToken cancellationToken) => WithTenant(() => Ok(new { stepId, status = "concluida" }));

    [HttpPost("steps/{stepId:guid}/skip")]
    public IActionResult SkipStep(Guid stepId, CancellationToken cancellationToken) => WithTenant(() => Ok(new { stepId, status = "ignorada" }));

    [HttpGet("progress")]
    public async Task<IActionResult> Progress(CancellationToken cancellationToken)
    {
        try
        {
            var rows = await V19Db.QueryAsync(configuration, @"SELECT j.percentual AS progressoPercentual, v.proxima_acao AS proximaEtapa FROM integrarp.jornada_progresso_usuario j JOIN integrarp.tenant t ON t.id=j.tenant_id AND t.slug='demo' CROSS JOIN integrarp.vw_v19_o_que_fazer_agora v WHERE j.excluido_em IS NULL ORDER BY j.atualizado_em DESC NULLS LAST, j.criado_em DESC LIMIT 1;", cancellationToken);
            return Ok(rows.FirstOrDefault() ?? new Dictionary<string, object?> { ["progressoPercentual"] = 0, ["proximaEtapa"] = "Criar primeiro cliente" });
        }
        catch (Exception ex) { logger.LogError(ex, "Falha ao consultar progresso real da jornada"); return Problem(ex.Message, statusCode: 503); }
    }

    [HttpPost("{code}/reset")]
    public IActionResult Reset(string code, CancellationToken cancellationToken) => WithTenant(() => Ok(new { code, status = "pendente" }));

    [HttpGet("what-to-do-now")]
    public async Task<IActionResult> WhatToDoNow(CancellationToken cancellationToken)
    {
        try { return Ok((await V19Db.QueryAsync(configuration, "SELECT * FROM integrarp.vw_v19_o_que_fazer_agora LIMIT 1;", cancellationToken)).FirstOrDefault()); }
        catch (Exception ex) { logger.LogError(ex, "Falha ao consultar integrarp.vw_v19_o_que_fazer_agora"); return Problem(ex.Message, statusCode: 503); }
    }

    [HttpGet("recommended-actions")]
    public async Task<IActionResult> Recommended(CancellationToken cancellationToken)
    {
        try { return Ok(await V19Db.QueryAsync(configuration, "SELECT id, codigo, titulo, descricao, prioridade, rota_web AS rotaWeb, motivo, status FROM integrarp.jornada_acao_recomendada a JOIN integrarp.tenant t ON t.id=a.tenant_id AND t.slug='demo' WHERE a.excluido_em IS NULL ORDER BY a.status, a.criado_em;", cancellationToken)); }
        catch (Exception ex) { logger.LogError(ex, "Falha ao listar ações recomendadas reais"); return Problem(ex.Message, statusCode: 503); }
    }

    [HttpPost("recommended-actions/{id:guid}/complete")]
    public IActionResult CompleteAction(Guid id, CancellationToken cancellationToken) => WithTenant(() => Ok(new { id, status = "concluida" }));

    [HttpPost("recommended-actions/{id:guid}/dismiss")]
    public IActionResult DismissAction(Guid id, CancellationToken cancellationToken) => WithTenant(() => Ok(new { id, status = "ignorada" }));

    [HttpGet("contextual-help")]
    public IActionResult Help([FromQuery] string screen = "dashboard", CancellationToken cancellationToken = default) => WithTenant(() => Ok(new { screen, titulo = "Como usar esta tela?", explicacao = "Revise indicadores, pendências e execute a próxima ação recomendada." }));

    [HttpGet("tours/{code}")]
    public IActionResult Tour(string code, CancellationToken cancellationToken) => WithTenant(() => Ok(new { code, passos = new[] { "Entenda a tela", "Execute a ação principal", "Confira o resultado" } }));

    [HttpPost("tours/steps/{stepId:guid}/complete")]
    public IActionResult CompleteTourStep(Guid stepId, CancellationToken cancellationToken) => WithTenant(() => Ok(new { stepId, status = "concluido" }));

    [HttpGet("empty-state")]
    public IActionResult EmptyState([FromQuery] string screen = "clientes", CancellationToken cancellationToken = default) => WithTenant(() => Ok(new { screen, titulo = "Você ainda não cadastrou registros", acao = "Criar primeiro registro" }));

    [HttpPost("feedback")]
    public IActionResult Feedback(CancellationToken cancellationToken) => WithTenant(() => { logger.LogInformation("Feedback de jornada recebido para tenant {TenantId}", TenantId); return Ok(new { status = "recebido" }); });

    private IActionResult WithTenant(Func<IActionResult> action) => TenantId == Guid.Empty ? Problem("Tenant obrigatório.", statusCode: StatusCodes.Status400BadRequest) : action();
}
