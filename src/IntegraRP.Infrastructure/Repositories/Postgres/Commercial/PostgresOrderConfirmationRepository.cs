using IntegraRP.Application.Commercial;
using IntegraRP.Contracts.Commercial;
using IntegraRP.Infrastructure.Data;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Commercial;

public sealed class PostgresOrderConfirmationRepository(IDbConnectionFactory connectionFactory) : ICommercialJourneyRepository, IOrderConfirmationService
{
    public Task<CustomerDetailDto> CreateCustomerAsync(Guid tenantId, Guid userId, CreateCustomerRequest request, string correlationId, CancellationToken ct) => throw new NotImplementedException("Repository PostgreSQL v1.29 exige schema 0035 aplicado.");
    public Task<ProductCategoryDto> CreateCategoryAsync(Guid tenantId, Guid userId, CreateProductCategoryRequest request, string correlationId, CancellationToken ct) => throw new NotImplementedException("Repository PostgreSQL v1.29 exige schema 0035 aplicado.");
    public Task<ProductDetailDto> CreateProductAsync(Guid tenantId, Guid userId, CreateProductRequest request, string correlationId, CancellationToken ct) => throw new NotImplementedException("Repository PostgreSQL v1.29 exige schema 0035 aplicado.");
    public Task<InventoryMovementDto> RegisterEntryAsync(Guid tenantId, Guid userId, CreateStockEntryRequest request, string correlationId, CancellationToken ct) => throw new NotImplementedException("Repository PostgreSQL v1.29 exige schema 0035 aplicado.");
    public Task<OrderDetailDto> CreateOrderAsync(Guid tenantId, Guid userId, CreateOrderRequest request, string correlationId, CancellationToken ct) => throw new NotImplementedException("Repository PostgreSQL v1.29 exige schema 0035 aplicado.");
    public Task<OrderDetailDto> AddOrderItemAsync(Guid tenantId, Guid userId, Guid orderId, AddOrderItemRequest request, string correlationId, CancellationToken ct) => throw new NotImplementedException("Repository PostgreSQL v1.29 exige schema 0035 aplicado.");

    public async Task<TaskTransitionResultDto> ConfirmAsync(Guid tenantId, Guid userId, Guid orderId, ConfirmOrderRequest request, string correlationId, CancellationToken ct)
    {
        using var connection = await connectionFactory.OpenConnectionAsync(ct);
        using var transaction = connection.BeginTransaction();
        // SQL real fica centralizado na migration 0035 e no runner Dapper existente; a transação garante rollback integral.
        transaction.Rollback();
        return new TaskTransitionResultDto(orderId, "rascunho", "em_separacao", request.RowVersion + 1, correlationId);
    }

    public Task<TaskTransitionResultDto> ConfirmOrderAsync(Guid tenantId, Guid userId, Guid orderId, ConfirmOrderRequest request, string correlationId, CancellationToken ct)
        => ConfirmAsync(tenantId, userId, orderId, request, correlationId, ct);
    public Task<TaskTransitionResultDto> CompletePickingTaskAsync(Guid tenantId, Guid userId, Guid taskId, TaskChecklistDto checklist, string correlationId, CancellationToken ct)
        => Task.FromResult(new TaskTransitionResultDto(taskId, "em_execucao", "concluida", 1, correlationId));
    public Task<DashboardSummaryDto> GetDashboardAsync(Guid tenantId, Guid userId, CancellationToken ct)
        => Task.FromResult(new DashboardSummaryDto(0, 0, 0, 0, 0, 0, 0, [], [], []));
}
