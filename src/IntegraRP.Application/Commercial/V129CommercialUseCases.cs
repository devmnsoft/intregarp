using IntegraRP.Contracts.Commercial;
using System.Text.Json;
using System.Text.Json.Nodes;

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
    private static readonly string[] SensitiveFragments = ["password", "token", "secret", "authorization", "documento", "telefone", "email", "financial"];
    public string MaskSensitive(string payload)
    {
        var root = JsonNode.Parse(payload) ?? throw new JsonException("Payload de auditoria inválido.");
        Mask(root);
        return root.ToJsonString();
    }

    private static void Mask(JsonNode node)
    {
        if (node is JsonObject obj)
        {
            foreach (var property in obj.ToList())
            {
                if (SensitiveFragments.Any(fragment => property.Key.Contains(fragment, StringComparison.OrdinalIgnoreCase)))
                    obj[property.Key] = "***";
                else if (property.Value is not null) Mask(property.Value);
            }
        }
        else if (node is JsonArray array)
            foreach (var item in array) if (item is not null) Mask(item);
    }
}

public sealed class OutboxService
{
    public string NextStatus(string status, int attempts, int maxAttempts) => attempts >= maxAttempts ? "dead_letter" : status == "processando" ? "erro" : "processando";
}
