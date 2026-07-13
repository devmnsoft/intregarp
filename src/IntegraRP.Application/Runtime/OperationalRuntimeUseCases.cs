using IntegraRP.Application.Common;
using System.Security.Claims;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Application.Runtime;

public interface IOperationalRuntimeRepository
{
    Task<IReadOnlyList<IDictionary<string, object?>>> ListCustomersAsync(Guid tenantId, CancellationToken ct);
    Task<IDictionary<string, object?>?> GetCustomerAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<IDictionary<string, object?>?> CreateCustomerAsync(Guid tenantId, DemoCustomerRequest request, CancellationToken ct);
    Task<IDictionary<string, object?>?> UpdateCustomerAsync(Guid tenantId, Guid id, DemoCustomerRequest request, CancellationToken ct);
    Task<IDictionary<string, object?>?> DeleteCustomerAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<IReadOnlyList<IDictionary<string, object?>>> ListProductsAsync(Guid tenantId, CancellationToken ct);
    Task<IDictionary<string, object?>?> GetProductAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<IDictionary<string, object?>?> CreateProductAsync(Guid tenantId, DemoProductRequest request, CancellationToken ct);
    Task<IDictionary<string, object?>?> UpdateProductAsync(Guid tenantId, Guid id, DemoProductRequest request, CancellationToken ct);
    Task<IDictionary<string, object?>?> DeleteProductAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<IReadOnlyList<IDictionary<string, object?>>> ListInventoryBalanceAsync(Guid tenantId, CancellationToken ct);
    Task<IReadOnlyList<IDictionary<string, object?>>> ListInventoryMovementsAsync(Guid tenantId, CancellationToken ct);
    Task<IReadOnlyList<IDictionary<string, object?>>> ListCriticalInventoryAsync(Guid tenantId, CancellationToken ct);
    Task<IDictionary<string, object?>?> RegisterInventoryEntryAsync(Guid tenantId, DemoInventoryEntryRequest request, CancellationToken ct);
    Task<IReadOnlyList<IDictionary<string, object?>>> ListOrdersAsync(Guid tenantId, CancellationToken ct);
    Task<IDictionary<string, object?>?> GetOrderAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<IDictionary<string, object?>?> CreateOrderAsync(Guid tenantId, CreateOrderRequest request, CancellationToken ct);
    Task<IDictionary<string, object?>?> AddOrderItemAsync(Guid tenantId, Guid id, AddOrderItemRequest request, CancellationToken ct);
    Task<IDictionary<string, object?>?> RemoveOrderItemAsync(Guid tenantId, Guid id, Guid itemId, CancellationToken ct);
    Task<IDictionary<string, object?>?> ConfirmOrderAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<IDictionary<string, object?>?> CancelOrderAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<IReadOnlyList<IDictionary<string, object?>>> ListMyTasksAsync(Guid tenantId, Guid userId, Guid? sectorId, CancellationToken ct);
    Task<IDictionary<string, object?>?> GetTaskAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<IDictionary<string, object?>?> ClaimTaskAsync(Guid tenantId, Guid id, Guid userId, string? email, CancellationToken ct);
    Task<IDictionary<string, object?>?> CommentTaskAsync(Guid tenantId, Guid id, AddTaskCommentRequest request, Guid userId, CancellationToken ct);
    Task<IDictionary<string, object?>?> CompleteTaskAsync(Guid tenantId, Guid id, CancellationToken ct);
}

public sealed record DemoCustomerRequest(string? Nome, string? Documento, string? Email);
public sealed record DemoProductRequest(string? Sku, string? Nome, decimal EstoqueMinimo = 0, decimal EstoqueAtual = 0);
public sealed record DemoInventoryEntryRequest(string? Sku, decimal Quantidade = 1);
public sealed record CreateOrderRequest(Guid CustomerId, DateTimeOffset? ExpectedDeliveryDate, string? Notes, IReadOnlyList<AddOrderItemRequest> Items);
public sealed record AddOrderItemRequest(Guid ProductId, decimal Quantity, decimal? UnitPrice = null, decimal Discount = 0);
public sealed record AddTaskCommentRequest(string Text, IReadOnlyList<Guid>? MentionedUserIds = null);

public sealed class OperationalRuntimeUseCases(IOperationalRuntimeRepository repository, ILogger<OperationalRuntimeUseCases> logger)
{
    public Task<Result<IReadOnlyList<IDictionary<string, object?>>>> ListCustomersAsync(Guid tenantId, CancellationToken ct) => RunList(() => repository.ListCustomersAsync(tenantId, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> GetCustomerAsync(Guid tenantId, Guid id, CancellationToken ct) => RunOne(() => repository.GetCustomerAsync(tenantId, id, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> CreateCustomerAsync(Guid tenantId, DemoCustomerRequest request, CancellationToken ct) => RunOne(() => repository.CreateCustomerAsync(tenantId, request, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> UpdateCustomerAsync(Guid tenantId, Guid id, DemoCustomerRequest request, CancellationToken ct) => RunOne(() => repository.UpdateCustomerAsync(tenantId, id, request, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> DeleteCustomerAsync(Guid tenantId, Guid id, CancellationToken ct) => RunOne(() => repository.DeleteCustomerAsync(tenantId, id, ct), tenantId);
    public Task<Result<IReadOnlyList<IDictionary<string, object?>>>> ListProductsAsync(Guid tenantId, CancellationToken ct) => RunList(() => repository.ListProductsAsync(tenantId, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> GetProductAsync(Guid tenantId, Guid id, CancellationToken ct) => RunOne(() => repository.GetProductAsync(tenantId, id, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> CreateProductAsync(Guid tenantId, DemoProductRequest request, CancellationToken ct) => RunOne(() => repository.CreateProductAsync(tenantId, request, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> UpdateProductAsync(Guid tenantId, Guid id, DemoProductRequest request, CancellationToken ct) => RunOne(() => repository.UpdateProductAsync(tenantId, id, request, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> DeleteProductAsync(Guid tenantId, Guid id, CancellationToken ct) => RunOne(() => repository.DeleteProductAsync(tenantId, id, ct), tenantId);
    public Task<Result<IReadOnlyList<IDictionary<string, object?>>>> ListInventoryBalanceAsync(Guid tenantId, CancellationToken ct) => RunList(() => repository.ListInventoryBalanceAsync(tenantId, ct), tenantId);
    public Task<Result<IReadOnlyList<IDictionary<string, object?>>>> ListInventoryMovementsAsync(Guid tenantId, CancellationToken ct) => RunList(() => repository.ListInventoryMovementsAsync(tenantId, ct), tenantId);
    public Task<Result<IReadOnlyList<IDictionary<string, object?>>>> ListCriticalInventoryAsync(Guid tenantId, CancellationToken ct) => RunList(() => repository.ListCriticalInventoryAsync(tenantId, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> RegisterInventoryEntryAsync(Guid tenantId, DemoInventoryEntryRequest request, CancellationToken ct) => RunOne(() => repository.RegisterInventoryEntryAsync(tenantId, request, ct), tenantId);
    public Task<Result<IReadOnlyList<IDictionary<string, object?>>>> ListOrdersAsync(Guid tenantId, CancellationToken ct) => RunList(() => repository.ListOrdersAsync(tenantId, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> GetOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => RunOne(() => repository.GetOrderAsync(tenantId, id, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> CreateOrderAsync(Guid tenantId, CreateOrderRequest request, CancellationToken ct)
    {
        if (request.CustomerId == Guid.Empty) return Task.FromResult(Result<IDictionary<string, object?>?>.Failure("Cliente obrigatório."));
        if (request.Items is null || request.Items.Count == 0) return Task.FromResult(Result<IDictionary<string, object?>?>.Failure("Pedido deve possuir ao menos um item."));
        if (request.Items.Any(i => i.ProductId == Guid.Empty || i.Quantity <= 0 || i.Discount < 0)) return Task.FromResult(Result<IDictionary<string, object?>?>.Failure("Itens do pedido inválidos."));
        return RunOne(() => repository.CreateOrderAsync(tenantId, request, ct), tenantId);
    }
    public Task<Result<IDictionary<string, object?>?>> AddOrderItemAsync(Guid tenantId, Guid id, AddOrderItemRequest request, CancellationToken ct) => request.ProductId == Guid.Empty || request.Quantity <= 0 ? Task.FromResult(Result<IDictionary<string, object?>?>.Failure("Item inválido.")) : RunOne(() => repository.AddOrderItemAsync(tenantId, id, request, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> RemoveOrderItemAsync(Guid tenantId, Guid id, Guid itemId, CancellationToken ct) => RunOne(() => repository.RemoveOrderItemAsync(tenantId, id, itemId, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> ConfirmOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => RunOne(() => repository.ConfirmOrderAsync(tenantId, id, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> CancelOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => RunOne(() => repository.CancelOrderAsync(tenantId, id, ct), tenantId);
    public Task<Result<IReadOnlyList<IDictionary<string, object?>>>> ListMyTasksAsync(Guid tenantId, ClaimsPrincipal user, CancellationToken ct) => RunList(() => repository.ListMyTasksAsync(tenantId, ReadGuid(user, ClaimTypes.NameIdentifier, "sub", "user_id") ?? Guid.Empty, ReadGuid(user, "sector_id", "sectorId"), ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> GetTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => RunOne(() => repository.GetTaskAsync(tenantId, id, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> ClaimTaskAsync(Guid tenantId, Guid id, ClaimsPrincipal user, CancellationToken ct) => RunOne(() => repository.ClaimTaskAsync(tenantId, id, ReadGuid(user, ClaimTypes.NameIdentifier, "sub", "user_id") ?? Guid.Empty, user.FindFirstValue(ClaimTypes.Email) ?? user.FindFirstValue("email"), ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> CommentTaskAsync(Guid tenantId, Guid id, AddTaskCommentRequest request, ClaimsPrincipal user, CancellationToken ct) => string.IsNullOrWhiteSpace(request.Text) ? Task.FromResult(Result<IDictionary<string, object?>?>.Failure("Comentário obrigatório.")) : RunOne(() => repository.CommentTaskAsync(tenantId, id, request, ReadGuid(user, ClaimTypes.NameIdentifier, "sub", "user_id") ?? Guid.Empty, ct), tenantId);
    public Task<Result<IDictionary<string, object?>?>> CompleteTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => RunOne(() => repository.CompleteTaskAsync(tenantId, id, ct), tenantId);

    private static Guid? ReadGuid(ClaimsPrincipal user, params string[] claimTypes)
    {
        foreach (var claimType in claimTypes)
        {
            var value = user.FindFirstValue(claimType);
            if (Guid.TryParse(value, out var guid)) return guid;
        }
        return null;
    }

    private async Task<Result<IReadOnlyList<IDictionary<string, object?>>>> RunList(Func<Task<IReadOnlyList<IDictionary<string, object?>>>> action, Guid tenantId)
    {
        if (tenantId == Guid.Empty) return Result<IReadOnlyList<IDictionary<string, object?>>>.Failure("Tenant obrigatório.");
        try { return Result<IReadOnlyList<IDictionary<string, object?>>>.Success(await action()); }
        catch (Exception ex) { logger.LogError(ex, "Falha operacional v1.12 para tenant {TenantId}.", tenantId); return Result<IReadOnlyList<IDictionary<string, object?>>>.Failure("Falha operacional. Consulte os logs pelo correlation_id."); }
    }

    private async Task<Result<IDictionary<string, object?>?>> RunOne(Func<Task<IDictionary<string, object?>?>> action, Guid tenantId)
    {
        if (tenantId == Guid.Empty) return Result<IDictionary<string, object?>?>.Failure("Tenant obrigatório.");
        try { return Result<IDictionary<string, object?>?>.Success(await action()); }
        catch (Exception ex) { logger.LogError(ex, "Falha operacional v1.12 para tenant {TenantId}.", tenantId); return Result<IDictionary<string, object?>?>.Failure("Falha operacional. Consulte os logs pelo correlation_id."); }
    }
}
