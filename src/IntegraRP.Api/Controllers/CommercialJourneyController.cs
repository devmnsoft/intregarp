using IntegraRP.Application.Commercial;
using IntegraRP.Contracts.Commercial;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/v129/commercial")]
public sealed class CommercialJourneyController(ICommercialJourneyRepository repository, ConfirmOrderUseCase confirmOrderUseCase) : ControllerBase
{
    private Guid TenantId => Guid.TryParse(User.FindFirst("tenant_id")?.Value, out var id) ? id : Guid.Empty;
    private Guid UserId => Guid.TryParse(User.FindFirst("sub")?.Value, out var id) ? id : Guid.Empty;
    private string CorrelationId => HttpContext.TraceIdentifier;

    [HttpPost("customers")] public async Task<IActionResult> CreateCustomer(CreateCustomerRequest request, CancellationToken ct) => Created("", await repository.CreateCustomerAsync(TenantId, UserId, request, CorrelationId, ct));
    [HttpPost("categories")] public async Task<IActionResult> CreateCategory(CreateProductCategoryRequest request, CancellationToken ct) => Created("", await repository.CreateCategoryAsync(TenantId, UserId, request, CorrelationId, ct));
    [HttpPost("products")] public async Task<IActionResult> CreateProduct(CreateProductRequest request, CancellationToken ct) => Created("", await repository.CreateProductAsync(TenantId, UserId, request, CorrelationId, ct));
    [HttpPost("inventory/entries")] public async Task<IActionResult> Entry(CreateStockEntryRequest request, CancellationToken ct) => Ok(await repository.RegisterEntryAsync(TenantId, UserId, request, CorrelationId, ct));
    [HttpPost("orders")] public async Task<IActionResult> CreateOrder(CreateOrderRequest request, CancellationToken ct) => Created("", await repository.CreateOrderAsync(TenantId, UserId, request, CorrelationId, ct));
    [HttpPost("orders/{orderId:guid}/items")] public async Task<IActionResult> AddItem(Guid orderId, AddOrderItemRequest request, CancellationToken ct) => Ok(await repository.AddOrderItemAsync(TenantId, UserId, orderId, request, CorrelationId, ct));
    [HttpPost("orders/{orderId:guid}/confirm")] public async Task<IActionResult> Confirm(Guid orderId, ConfirmOrderRequest request, CancellationToken ct) => Ok(await confirmOrderUseCase.ExecuteAsync(TenantId, UserId, orderId, request, CorrelationId, ct));
    [HttpPost("tasks/{taskId:guid}/complete")] public async Task<IActionResult> CompleteTask(Guid taskId, TaskChecklistDto checklist, CancellationToken ct) => Ok(await repository.CompletePickingTaskAsync(TenantId, UserId, taskId, checklist, CorrelationId, ct));
    [HttpGet("dashboard")] public async Task<IActionResult> Dashboard(CancellationToken ct) => Ok(await repository.GetDashboardAsync(TenantId, UserId, ct));
}
