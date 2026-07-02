using IntegraRP.Application.Abstractions.Bi;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/bi")]
public sealed class BiDashboardController(ILogger<BiDashboardController> logger, ISprint7BiProjectService service) : ControllerBase
{
    private static readonly Guid TenantId = Guid.Parse("11111111-1111-1111-1111-111111111111");

    [HttpGet("dashboard/executive")]
    public async Task<IActionResult> Executive(CancellationToken ct) => Ok(await Run(() => service.ExecutiveAsync(TenantId, ct), "dashboard executivo"));

    [HttpGet("dashboard/flow")]
    public async Task<IActionResult> Flow(CancellationToken ct) => Ok(await Run(() => service.FlowAsync(TenantId, ct), "dashboard flow"));

    [HttpGet("dashboard/commercial")]
    public async Task<IActionResult> Commercial(CancellationToken ct) => Ok(await Run(() => service.CommercialAsync(TenantId, ct), "dashboard comercial"));

    [HttpGet("dashboard/inventory")]
    public async Task<IActionResult> Inventory(CancellationToken ct) => Ok(await Run(() => service.InventoryAsync(TenantId, ct), "dashboard estoque"));

    [HttpGet("dashboard/billing")]
    public async Task<IActionResult> Billing(CancellationToken ct) => Ok(await Run(() => service.BillingAsync(TenantId, ct), "dashboard financeiro"));

    [HttpGet("dashboard/connect")]
    public async Task<IActionResult> Connect(CancellationToken ct) => Ok(await Run(() => service.ConnectAsync(TenantId, ct), "dashboard connect"));

    [HttpGet("score")]
    public async Task<IActionResult> Score(CancellationToken ct) => Ok(await Run(() => service.ScoreAsync(TenantId, ct), "score operacional"));

    [HttpPost("score/recalculate")]
    public async Task<IActionResult> Recalculate(CancellationToken ct) => Ok(await Run(() => service.RecalculateAsync(TenantId, ct), "recálculo do score"));

    private async Task<T> Run<T>(Func<Task<T>> action, string operation)
    {
        try { logger.LogInformation("Executando {Operation}", operation); return await action(); }
        catch (Exception ex) { logger.LogError(ex, "Erro ao executar {Operation}", operation); throw; }
    }
}
