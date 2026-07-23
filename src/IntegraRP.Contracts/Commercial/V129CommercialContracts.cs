namespace IntegraRP.Contracts.Commercial;

public sealed record PagedResult<T>(IReadOnlyList<T> Items, int Page, int PageSize, long Total)
{
    public int TotalPages => PageSize <= 0 ? 0 : (int)Math.Ceiling(Total / (double)PageSize);
}
public sealed record CustomerListItemDto(Guid Id, string Name, string? Document, string? Email, string Status, long RowVersion);
public sealed record CustomerDetailDto(Guid Id, Guid TenantId, string Name, string? Document, string? Email, string? Phone, string Status, long RowVersion, DateTimeOffset CreatedAt, DateTimeOffset UpdatedAt);
public sealed record CreateCustomerRequest(string Name, string? Document, string? Email, string? Phone);
public sealed record UpdateCustomerRequest(string Name, string? Document, string? Email, string? Phone, string Status, long RowVersion);
public sealed record CustomerFilter(string? Search, string? Status, string? SortBy, bool Descending, int Page = 1, int PageSize = 20);
public sealed record ProductCategoryDto(Guid Id, string Code, string Name, string Status, long RowVersion);
public sealed record CreateProductCategoryRequest(string Code, string Name);
public sealed record UpdateProductCategoryRequest(string Code, string Name, string Status, long RowVersion);
public sealed record ProductListItemDto(Guid Id, string Sku, string Name, Guid CategoryId, string CategoryName, decimal Price, decimal MinimumStock, string Status, long RowVersion);
public sealed record ProductDetailDto(Guid Id, Guid TenantId, string Sku, string Name, Guid CategoryId, string CategoryName, decimal Price, decimal MinimumStock, string Status, long RowVersion);
public sealed record CreateProductRequest(string Sku, string Name, Guid CategoryId, decimal Price, decimal MinimumStock);
public sealed record UpdateProductRequest(string Sku, string Name, Guid CategoryId, decimal Price, decimal MinimumStock, string Status, long RowVersion);
public sealed record ProductFilter(string? Search, Guid? CategoryId, string? Status, string? SortBy, bool Descending, int Page = 1, int PageSize = 20);
public sealed record InventoryBalanceDto(Guid ProductId, string Sku, string ProductName, string LocationCode, decimal Physical, decimal Reserved, decimal Available);
public sealed record InventoryMovementDto(Guid Id, Guid ProductId, string Type, decimal Quantity, string LocationCode, string Reason, string CorrelationId, DateTimeOffset CreatedAt);
public sealed record CreateStockEntryRequest(Guid ProductId, decimal Quantity, string LocationCode, string Reason, string IdempotencyKey);
public sealed record CreateStockExitRequest(Guid ProductId, decimal Quantity, string LocationCode, string Reason, string IdempotencyKey);
public sealed record CreateStockAdjustmentRequest(Guid ProductId, decimal PhysicalQuantity, string LocationCode, string Reason, string IdempotencyKey);
public sealed record CreateStockReservationRequest(Guid ProductId, decimal Quantity, string LocationCode, string Reason, string IdempotencyKey, Guid? OrderId);
public sealed record ReleaseStockReservationRequest(Guid ProductId, decimal Quantity, string LocationCode, string Reason, string IdempotencyKey, Guid? OrderId);
public sealed record OrderListItemDto(Guid Id, string Number, Guid CustomerId, string CustomerName, string Status, decimal Total, long RowVersion, DateTimeOffset UpdatedAt);
public sealed record OrderDetailDto(Guid Id, Guid TenantId, string Number, Guid CustomerId, string CustomerName, string Status, IReadOnlyList<OrderItemDto> Items, decimal Total, long RowVersion);
public sealed record OrderItemDto(Guid Id, Guid ProductId, string Sku, string ProductName, decimal Quantity, decimal UnitPrice, decimal Discount, decimal Total);
public sealed record CreateOrderRequest(Guid CustomerId, string? Notes, string IdempotencyKey);
public sealed record AddOrderItemRequest(Guid ProductId, decimal Quantity, decimal UnitPrice, decimal Discount, string IdempotencyKey);
public sealed record ConfirmOrderRequest(long RowVersion, string IdempotencyKey);
public sealed record CancelOrderRequest(long RowVersion, string Reason, string IdempotencyKey);
public sealed record TaskListItemDto(Guid Id, Guid? OrderId, string Title, string Status, string Priority, DateTimeOffset? DueAt, long RowVersion);
public sealed record TaskDetailDto(Guid Id, Guid TenantId, Guid? OrderId, Guid? SectorId, Guid? AssigneeId, string Title, string Status, string Priority, DateTimeOffset? DueAt, TaskChecklistDto Checklist, long RowVersion, string? CorrelationId);
public sealed record TaskChecklistDto(IReadOnlyList<TaskChecklistItemDto> Items);
public sealed record TaskChecklistItemDto(string Key, string Label, bool Checked, string? Value);
public sealed record TaskTransitionResultDto(Guid TaskId, string PreviousStatus, string CurrentStatus, long RowVersion, string CorrelationId);
public sealed record DashboardSummaryDto(int OrdersInProgress, int OrdersAwaitingConfirmation, int OverdueTasks, int TasksToday, int CriticalStock, int PendingReservations, int OutboxErrors, IReadOnlyList<DashboardAttentionItemDto> Attention, IReadOnlyList<DashboardRecentOrderDto> RecentOrders, IReadOnlyList<DashboardStockAlertDto> StockAlerts);
public sealed record DashboardAttentionItemDto(string Type, string Title, string Severity, string? Url);
public sealed record DashboardRecentOrderDto(Guid Id, string Number, string CustomerName, string Status, decimal Total, DateTimeOffset UpdatedAt);
public sealed record DashboardStockAlertDto(Guid ProductId, string Sku, string ProductName, decimal Available, decimal MinimumStock);
