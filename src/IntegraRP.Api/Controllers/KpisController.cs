using IntegraRP.Application.Abstractions.Bi;
using IntegraRP.Contracts.Bi;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/bi/kpis")]
public sealed class KpisController(ILogger<KpisController> logger, ISprint7BiProjectService service) : ControllerBase
{
    private static readonly Guid TenantId = Guid.Parse("11111111-1111-1111-1111-111111111111");
    [HttpGet] public async Task<IActionResult> List(CancellationToken ct) => Ok(await Run(() => service.ListKpisAsync(TenantId, ct), "listar KPIs"));
    [HttpGet("current")] public async Task<IActionResult> Current(CancellationToken ct) => Ok(await Run(() => service.CalculateAllAsync(TenantId, ct), "KPIs atuais"));
    [HttpPost] public async Task<IActionResult> Create([FromBody] CreateKpiDefinitionRequest request, CancellationToken ct) => Ok(await Run(() => service.CreateKpiAsync(TenantId, request, ct), "criar KPI"));
    [HttpPut("{id:guid}")] public async Task<IActionResult> Update(Guid id, [FromBody] UpdateKpiDefinitionRequest request, CancellationToken ct) => Ok(await Run(() => service.UpdateKpiAsync(TenantId, id, request, ct), "editar KPI"));
    [HttpPost("{id:guid}/target")] public async Task<IActionResult> Target(Guid id, [FromBody] SetKpiTargetRequest request, CancellationToken ct) => Ok(await Run(() => service.SetTargetAsync(TenantId, id, request, ct), "meta KPI"));
    [HttpPost("{id:guid}/calculate")] public async Task<IActionResult> Calculate(Guid id, CancellationToken ct) => Ok((await Run(() => service.CalculateAllAsync(TenantId, ct), "calcular KPI")).FirstOrDefault(x => x.KpiDefinitionId == id));
    [HttpPost("calculate-all")] public async Task<IActionResult> CalculateAll(CancellationToken ct) => Ok(await Run(() => service.CalculateAllAsync(TenantId, ct), "calcular KPIs"));
    [HttpGet("alerts")] public async Task<IActionResult> Alerts(CancellationToken ct) => Ok(await Run(() => service.AlertsAsync(TenantId, ct), "alertas KPI"));
    private async Task<T> Run<T>(Func<Task<T>> action, string operation) { try { logger.LogInformation("Executando {Operation}", operation); return await action(); } catch (Exception ex) { logger.LogError(ex, "Erro em {Operation}", operation); throw; } }
}
