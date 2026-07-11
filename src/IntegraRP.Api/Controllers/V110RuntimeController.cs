using IntegraRP.Application.Runtime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Obsolete("Compatibilidade v1.10/v1.11: use os controllers operacionais específicos da v1.12.")]
[ApiController]
[Authorize]
[Route("api/v110-runtime")]
public sealed class V110RuntimeController(OperationalRuntimeUseCases useCases) : IntegraControllerBase
{
    [HttpGet("customers")] public async Task<IActionResult> Customers(CancellationToken ct) => ToAction(await useCases.ListCustomersAsync(TenantId, ct));
    [HttpPost("customers")] public async Task<IActionResult> CreateCustomer([FromBody] DemoCustomerRequest request, CancellationToken ct) => ToAction(await useCases.CreateCustomerAsync(TenantId, request, ct));
    [HttpPut("customers/{id:guid}")] public async Task<IActionResult> UpdateCustomer(Guid id, [FromBody] DemoCustomerRequest request, CancellationToken ct) => ToAction(await useCases.UpdateCustomerAsync(TenantId, id, request, ct));
    [HttpGet("products")] public async Task<IActionResult> Products(CancellationToken ct) => ToAction(await useCases.ListProductsAsync(TenantId, ct));
    [HttpPost("products")] public async Task<IActionResult> CreateProduct([FromBody] DemoProductRequest request, CancellationToken ct) => ToAction(await useCases.CreateProductAsync(TenantId, request, ct));
    [HttpPut("products/{id:guid}")] public async Task<IActionResult> UpdateProduct(Guid id, [FromBody] DemoProductRequest request, CancellationToken ct) => ToAction(await useCases.UpdateProductAsync(TenantId, id, request, ct));
    [HttpPost("inventory/entries")] public async Task<IActionResult> InventoryEntry([FromBody] DemoInventoryEntryRequest request, CancellationToken ct) => ToAction(await useCases.RegisterInventoryEntryAsync(TenantId, request, ct));
    [HttpGet("orders")] public async Task<IActionResult> Orders(CancellationToken ct) => ToAction(await useCases.ListOrdersAsync(TenantId, ct));
    [HttpPost("orders/{id:guid}/confirm")] public async Task<IActionResult> ConfirmOrder(Guid id, CancellationToken ct) => ToAction(await useCases.ConfirmOrderAsync(TenantId, id, ct));
    [HttpGet("tasks/my")] public async Task<IActionResult> Tasks(CancellationToken ct) => ToAction(await useCases.ListMyTasksAsync(TenantId, ct));
    [HttpPost("tasks/{id:guid}/complete")] public async Task<IActionResult> CompleteTask(Guid id, CancellationToken ct) => ToAction(await useCases.CompleteTaskAsync(TenantId, id, ct));

    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(result.Error, statusCode: 400);
}
