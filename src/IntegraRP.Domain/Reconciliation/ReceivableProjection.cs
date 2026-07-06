namespace IntegraRP.Domain.Reconciliation;

public sealed record ReceivableProjection(Guid Id, Guid TenantId, string Status, DateTimeOffset CriadoEm)
{
    public Dictionary<string, object?> Metadata { get; init; } = new();
}
