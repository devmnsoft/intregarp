using IntegraRP.Application.Runtime;
using Microsoft.Extensions.Logging.Abstractions;

namespace IntegraRP.Tests;

public sealed class V114OperationalSecurityTests
{
    [Fact]
    public async Task CreateOrder_Requires_Selected_Customer_And_Items()
    {
        var useCases = new OperationalRuntimeUseCases(new FakeOperationalRepository(), NullLogger<OperationalRuntimeUseCases>.Instance);

        var result = await useCases.CreateOrderAsync(Guid.NewGuid(), new CreateOrderRequest(Guid.Empty, null, null, []), CancellationToken.None);

        Assert.False(result.IsSuccess);
        Assert.Equal("Cliente obrigatório.", result.Error);
    }

    [Fact]
    public async Task AddOrderItem_Rejects_Zero_Quantity_Before_Repository()
    {
        var useCases = new OperationalRuntimeUseCases(new FakeOperationalRepository(), NullLogger<OperationalRuntimeUseCases>.Instance);

        var result = await useCases.AddOrderItemAsync(Guid.NewGuid(), Guid.NewGuid(), new AddOrderItemRequest(Guid.NewGuid(), 0), CancellationToken.None);

        Assert.False(result.IsSuccess);
        Assert.Equal("Item inválido.", result.Error);
    }

    [Fact]
    public async Task TaskComment_Requires_Text_Payload()
    {
        var useCases = new OperationalRuntimeUseCases(new FakeOperationalRepository(), NullLogger<OperationalRuntimeUseCases>.Instance);
        var context = new FakeExecutionContext(Guid.NewGuid(), Guid.NewGuid(), "operador@integrarp.local");

        var result = await useCases.CommentTaskAsync(context, Guid.NewGuid(), new AddTaskCommentRequest(" "), CancellationToken.None);

        Assert.False(result.IsSuccess);
        Assert.Equal("Comentário obrigatório.", result.Error);
    }

    private sealed record FakeExecutionContext(Guid TenantId, Guid UserId, string? Email) : ICurrentExecutionContext
    {
        public IReadOnlySet<string> Roles { get; } = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        public IReadOnlySet<string> Permissions { get; } = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        public Guid? SectorId => null;
        public bool IsSuperAdmin => false;
        public string? CorrelationId => "test-correlation";
    }

    private sealed class FakeOperationalRepository : IOperationalRuntimeRepository
    {
        public Task<IReadOnlyList<IDictionary<string, object?>>> ListCustomersAsync(Guid tenantId, CancellationToken ct) => EmptyList();
        public Task<IDictionary<string, object?>?> GetCustomerAsync(Guid tenantId, Guid id, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> CreateCustomerAsync(Guid tenantId, DemoCustomerRequest request, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> UpdateCustomerAsync(Guid tenantId, Guid id, DemoCustomerRequest request, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> DeleteCustomerAsync(Guid tenantId, Guid id, CancellationToken ct) => EmptyOne();
        public Task<IReadOnlyList<IDictionary<string, object?>>> ListProductsAsync(Guid tenantId, CancellationToken ct) => EmptyList();
        public Task<IDictionary<string, object?>?> GetProductAsync(Guid tenantId, Guid id, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> CreateProductAsync(Guid tenantId, DemoProductRequest request, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> UpdateProductAsync(Guid tenantId, Guid id, DemoProductRequest request, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> DeleteProductAsync(Guid tenantId, Guid id, CancellationToken ct) => EmptyOne();
        public Task<IReadOnlyList<IDictionary<string, object?>>> ListInventoryBalanceAsync(Guid tenantId, CancellationToken ct) => EmptyList();
        public Task<IReadOnlyList<IDictionary<string, object?>>> ListInventoryMovementsAsync(Guid tenantId, CancellationToken ct) => EmptyList();
        public Task<IReadOnlyList<IDictionary<string, object?>>> ListCriticalInventoryAsync(Guid tenantId, CancellationToken ct) => EmptyList();
        public Task<IDictionary<string, object?>?> RegisterInventoryEntryAsync(Guid tenantId, DemoInventoryEntryRequest request, CancellationToken ct) => EmptyOne();
        public Task<IReadOnlyList<IDictionary<string, object?>>> ListOrdersAsync(Guid tenantId, CancellationToken ct) => EmptyList();
        public Task<IDictionary<string, object?>?> GetOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> CreateOrderAsync(Guid tenantId, CreateOrderRequest request, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> AddOrderItemAsync(Guid tenantId, Guid id, AddOrderItemRequest request, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> RemoveOrderItemAsync(Guid tenantId, Guid id, Guid itemId, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> ConfirmOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> CancelOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => EmptyOne();
        public Task<IReadOnlyList<IDictionary<string, object?>>> ListMyTasksAsync(Guid tenantId, Guid userId, Guid? sectorId, CancellationToken ct) => EmptyList();
        public Task<IDictionary<string, object?>?> GetTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> ClaimTaskAsync(Guid tenantId, Guid id, Guid userId, string? email, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> CommentTaskAsync(Guid tenantId, Guid id, AddTaskCommentRequest request, Guid userId, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> StartTaskAsync(Guid tenantId, Guid id, Guid userId, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> SaveTaskFormAsync(Guid tenantId, Guid id, string formJson, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> SaveTaskChecklistAsync(Guid tenantId, Guid id, string checklistJson, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> AddTaskEvidenceAsync(Guid tenantId, Guid id, Guid userId, string evidenceJson, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> CompleteTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => EmptyOne();
        public Task<IDictionary<string, object?>?> CancelTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => EmptyOne();
        private static Task<IDictionary<string, object?>?> EmptyOne() => Task.FromResult<IDictionary<string, object?>?>(new Dictionary<string, object?>());
        private static Task<IReadOnlyList<IDictionary<string, object?>>> EmptyList() => Task.FromResult<IReadOnlyList<IDictionary<string, object?>>>([]);
    }
}
