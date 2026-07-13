using IntegraRP.Application.Runtime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/inventory")]
public sealed class InventoryController(OperationalRuntimeUseCases useCases) : IntegraControllerBase
{
    [Authorize(Policy = "inventory.view")]
    [HttpGet("balance")] public async Task<IActionResult> Balance(CancellationToken ct) => ToAction(await useCases.ListInventoryBalanceAsync(TenantId, ct));
    [Authorize(Policy = "inventory.view")]
    [HttpGet("movements")] public async Task<IActionResult> Movements(CancellationToken ct) => ToAction(await useCases.ListInventoryMovementsAsync(TenantId, ct));
    [Authorize(Policy = "inventory.view")]
    [HttpGet("critical")] public async Task<IActionResult> Critical(CancellationToken ct) => ToAction(await useCases.ListCriticalInventoryAsync(TenantId, ct));
    [Authorize(Policy = "inventory.move")]
    [HttpPost("entries")] public async Task<IActionResult> Entry(DemoInventoryEntryRequest request, CancellationToken ct) => ToAction(await useCases.RegisterInventoryEntryAsync(TenantId, request, ct));
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(result.Error, statusCode: 400);
}
