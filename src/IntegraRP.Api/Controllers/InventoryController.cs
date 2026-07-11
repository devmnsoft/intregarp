using IntegraRP.Application.Runtime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/inventory")]
public sealed class InventoryController(OperationalRuntimeUseCases useCases) : IntegraControllerBase
{
    [HttpGet("balance")] public IActionResult Balance() => Problem("Saldo detalhado será consolidado no repository dedicado.", statusCode: 501);
    [HttpGet("movements")] public IActionResult Movements() => Problem("Movimentos paginados serão consolidados no repository dedicado.", statusCode: 501);
    [HttpGet("critical")] public IActionResult Critical() => Problem("Estoque crítico será consolidado no repository dedicado.", statusCode: 501);
    [HttpPost("entries")] public async Task<IActionResult> Entry(DemoInventoryEntryRequest request, CancellationToken ct) => ToAction(await useCases.RegisterInventoryEntryAsync(TenantId, request, ct));
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(result.Error, statusCode: 400);
}
