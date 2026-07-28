namespace IntegraRP.Application.Commercial;

public sealed record OutboxEnvelope(Guid Id, Guid TenantId, string Type, string PayloadJson, string CorrelationId);

public interface IOutboxEventHandler
{
    string EventType { get; }
    Task HandleAsync(OutboxEnvelope envelope, CancellationToken cancellationToken);
}

public interface IOutboxEventDispatcher
{
    Task DispatchAsync(OutboxEnvelope envelope, CancellationToken cancellationToken);
}

public sealed class OutboxEventDispatcher(IEnumerable<IOutboxEventHandler> handlers) : IOutboxEventDispatcher
{
    private readonly IReadOnlyDictionary<string, IOutboxEventHandler> _handlers = handlers.ToDictionary(x => x.EventType, StringComparer.OrdinalIgnoreCase);
    public Task DispatchAsync(OutboxEnvelope envelope, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        return _handlers.TryGetValue(envelope.Type, out var handler)
            ? handler.HandleAsync(envelope, cancellationToken)
            : throw new InvalidOperationException($"Nenhum handler registrado para o evento '{envelope.Type}'.");
    }
}
