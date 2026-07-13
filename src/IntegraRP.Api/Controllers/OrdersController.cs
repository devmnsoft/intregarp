using IntegraRP.Application.Runtime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/orders")]
public sealed class OrdersController(OperationalRuntimeUseCases useCases) : IntegraControllerBase
{
    [Authorize(Policy = "orders.view")]
    [HttpGet] public async Task<IActionResult> List(CancellationToken ct) => ToAction(await useCases.ListOrdersAsync(TenantId, ct));
    [Authorize(Policy = "orders.view")]
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) => ToAction(await useCases.GetOrderAsync(TenantId, id, ct));
    [Authorize(Policy = "orders.create")]
    [HttpPost] public async Task<IActionResult> Create(CreateOrderRequest request, CancellationToken ct) => ToAction(await useCases.CreateOrderAsync(TenantId, request, ct));
    [Authorize(Policy = "orders.create")]
    [HttpPost("{id:guid}/items")] public async Task<IActionResult> AddItem(Guid id, AddOrderItemRequest request, CancellationToken ct) => ToAction(await useCases.AddOrderItemAsync(TenantId, id, request, ct));
    [Authorize(Policy = "orders.create")]
    [HttpDelete("{id:guid}/items/{itemId:guid}")] public async Task<IActionResult> RemoveItem(Guid id, Guid itemId, CancellationToken ct) => ToAction(await useCases.RemoveOrderItemAsync(TenantId, id, itemId, ct));
    [Authorize(Policy = "orders.confirm")]
    [HttpPost("{id:guid}/confirm")] public async Task<IActionResult> Confirm(Guid id, CancellationToken ct) => ToAction(await useCases.ConfirmOrderAsync(TenantId, id, ct));
    [Authorize(Policy = "orders.cancel")]
    [HttpPost("{id:guid}/cancel")] public async Task<IActionResult> Cancel(Guid id, CancellationToken ct) => ToAction(await useCases.CancelOrderAsync(TenantId, id, ct));
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(title: "Falha de validação", detail: result.Error, statusCode: 400);
}
