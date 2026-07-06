namespace IntegraRP.Domain.Reconciliation;

public sealed record DelinquencyAlert(Guid Id, Guid TenantId, string Status, DateTimeOffset CriadoEm)
{
    public Dictionary<string, object?> Metadata { get; init; } = new();
}
