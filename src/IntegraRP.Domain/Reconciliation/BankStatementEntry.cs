namespace IntegraRP.Domain.Reconciliation;

public sealed record BankStatementEntry(Guid Id, Guid TenantId, string Status, DateTimeOffset CriadoEm)
{
    public Dictionary<string, object?> Metadata { get; init; } = new();
}
