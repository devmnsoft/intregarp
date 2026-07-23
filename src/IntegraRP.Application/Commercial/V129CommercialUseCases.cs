using IntegraRP.Contracts.Commercial;

namespace IntegraRP.Application.Commercial;

public interface ICommercialJourneyRepository
{
    Task<CustomerDetailDto> CreateCustomerAsync(Guid tenantId, Guid userId, CreateCustomerRequest request, string correlationId, CancellationToken ct);
    Task<ProductCategoryDto> CreateCategoryAsync(Guid tenantId, Guid userId, CreateProductCategoryRequest request, string correlationId, CancellationToken ct);
    Task<ProductDetailDto> CreateProductAsync(Guid tenantId, Guid userId, CreateProductRequest request, string correlationId, CancellationToken ct);
    Task<InventoryMovementDto> RegisterEntryAsync(Guid tenantId, Guid userId, CreateStockEntryRequest request, string correlationId, CancellationToken ct);
    Task<OrderDetailDto> CreateOrderAsync(Guid tenantId, Guid userId, CreateOrderRequest request, string correlationId, CancellationToken ct);
    Task<OrderDetailDto> AddOrderItemAsync(Guid tenantId, Guid userId, Guid orderId, AddOrderItemRequest request, string correlationId, CancellationToken ct);
    Task<TaskTransitionResultDto> ConfirmOrderAsync(Guid tenantId, Guid userId, Guid orderId, ConfirmOrderRequest request, string correlationId, CancellationToken ct);
    Task<TaskTransitionResultDto> CompletePickingTaskAsync(Guid tenantId, Guid userId, Guid taskId, TaskChecklistDto checklist, string correlationId, CancellationToken ct);
    Task<DashboardSummaryDto> GetDashboardAsync(Guid tenantId, Guid userId, CancellationToken ct);
}

public interface IOrderConfirmationService
{
    Task<TaskTransitionResultDto> ConfirmAsync(Guid tenantId, Guid userId, Guid orderId, ConfirmOrderRequest request, string correlationId, CancellationToken ct);
}

public sealed class ConfirmOrderUseCase(IOrderConfirmationService service)
{
    public Task<TaskTransitionResultDto> ExecuteAsync(Guid tenantId, Guid userId, Guid orderId, ConfirmOrderRequest request, string correlationId, CancellationToken ct)
        => service.ConfirmAsync(tenantId, userId, orderId, request, correlationId, ct);
}

public sealed class CompletePickingTaskUseCase(ICommercialJourneyRepository repository)
{
    public Task<TaskTransitionResultDto> ExecuteAsync(Guid tenantId, Guid userId, Guid taskId, TaskChecklistDto checklist, string correlationId, CancellationToken ct)
        => repository.CompletePickingTaskAsync(tenantId, userId, taskId, checklist, correlationId, ct);
}

public sealed class AuditService
{
    public string MaskSensitive(string payload) => payload.Replace("password", "********", StringComparison.OrdinalIgnoreCase).Replace("token", "*****", StringComparison.OrdinalIgnoreCase).Replace("secret", "******", StringComparison.OrdinalIgnoreCase);
}

public sealed class OutboxService
{
    public string NextStatus(string status, int attempts, int maxAttempts) => attempts >= maxAttempts ? "dead_letter" : status == "processando" ? "erro" : "processando";
}
