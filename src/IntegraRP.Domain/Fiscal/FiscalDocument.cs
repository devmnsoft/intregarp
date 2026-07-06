namespace IntegraRP.Domain.Fiscal;

public sealed record FiscalDocument(Guid Id, Guid TenantId, string Status, DateTimeOffset CriadoEm)
{
    public Dictionary<string, object?> Metadata { get; init; } = new();
}
