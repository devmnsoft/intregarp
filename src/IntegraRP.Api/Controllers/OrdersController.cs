using IntegraRP.Application.Runtime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/orders")]
public sealed class OrdersController(OperationalRuntimeUseCases useCases) : IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List(CancellationToken ct) => ToAction(await useCases.ListOrdersAsync(TenantId, ct));
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) => ToAction(await useCases.GetOrderAsync(TenantId, id, ct));
    [HttpPost] public async Task<IActionResult> Create(CancellationToken ct) => ToAction(await useCases.CreateOrderAsync(TenantId, ct));
    [HttpPost("{id:guid}/items")] public async Task<IActionResult> AddItem(Guid id, CancellationToken ct) => ToAction(await useCases.AddOrderItemAsync(TenantId, id, ct));
    [HttpDelete("{id:guid}/items/{itemId:guid}")] public async Task<IActionResult> RemoveItem(Guid id, Guid itemId, CancellationToken ct) => ToAction(await useCases.RemoveOrderItemAsync(TenantId, id, itemId, ct));
    [HttpPost("{id:guid}/confirm")] public async Task<IActionResult> Confirm(Guid id, CancellationToken ct) => ToAction(await useCases.ConfirmOrderAsync(TenantId, id, ct));
    [HttpPost("{id:guid}/cancel")] public async Task<IActionResult> Cancel(Guid id, CancellationToken ct) => ToAction(await useCases.CancelOrderAsync(TenantId, id, ct));
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(result.Error, statusCode: 400);
}
