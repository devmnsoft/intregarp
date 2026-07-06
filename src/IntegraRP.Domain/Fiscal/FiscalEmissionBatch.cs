namespace IntegraRP.Domain.Fiscal;

public sealed record FiscalEmissionBatch(Guid Id, Guid TenantId, string Status, DateTimeOffset CriadoEm)
{
    public Dictionary<string, object?> Metadata { get; init; } = new();
}
